package common;

import java.util.Base64;
import java.nio.file.*;
public class utils {
    public static String fileToBase64(String filePath) throws Exception{
        byte[] input_file = Files.readAllBytes(Paths.get(filePath));
        byte[] encodeBytes = Base64.getEncoder().encode(input_file);
        return new String(encodeBytes);
    }
    public static String getFileName(String filePath){
        Path customPath = Paths.get(filePath);
        Path fileName = customPath.getFileName();
        System.out.println("Extracted Filename is "+ fileName.toString());
        return new String(fileName.toString());
    }

    // you may add more here but keep it minimal
}