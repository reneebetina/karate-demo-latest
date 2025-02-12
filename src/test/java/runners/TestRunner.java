package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TestRunner{
    @Test
    void testParallel(){
        Results results = Runner.path("classpath:features")
                //.karateEnv("test") // must always define this value. you can use this line if you run on your local machine
                .outputCucumberJson(true)
                .parallel(1); // change to whatever value is applicable for your project
        generateReport(results.getReportDir());
        assertTrue(results.getFailCount()== 0, results.getErrorMessages());
    }

    public static void generateReport(String karateOutputPath){
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath),new String[] {"json"},true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"),"Demo Project Name - Renee Betina Esperas");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths,config);
        reportBuilder.generateReports();
    }
}
