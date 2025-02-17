package common;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.*;
import java.util.*;

public class excelReader {

    // Function to read and map values from an Excel file and return a list of maps
    public static List<Map<String, Object>> readExcel(String filePath) {
        List<Map<String, Object>> dataList = new ArrayList<>();

        try (FileInputStream fis = new FileInputStream(new File(filePath));
             Workbook workbook = new XSSFWorkbook(fis)) {

            // Get the first sheet (you can change the sheet index if needed)
            Sheet sheet = workbook.getSheetAt(0);

            // Get the header row (column names)
            Row headerRow = sheet.getRow(0);
            Map<String, Integer> headerMap = new HashMap<>();
            for (int i = 0; i < headerRow.getPhysicalNumberOfCells(); i++) {
                headerMap.put(headerRow.getCell(i).getStringCellValue(), i);
            }

            // Iterate through rows (starting from row 1 to skip the header)
            for (int rowIndex = 1; rowIndex < sheet.getPhysicalNumberOfRows(); rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                if (row != null) {
                    // Create a map for each row with column names as keys
                    Map<String, Object> rowMap = new HashMap<>();
                    for (String columnName : headerMap.keySet()) {
                        int columnIndex = headerMap.get(columnName);
                        Cell cell = row.getCell(columnIndex);
                        if (cell != null) {
                            // Map column name to cell value
                            switch (cell.getCellType()) {
                                case STRING:
                                    rowMap.put(columnName, cell.getStringCellValue());
                                    break;
                                case NUMERIC:
                                    rowMap.put(columnName, cell.getNumericCellValue());
                                    break;
                                case BOOLEAN:
                                    rowMap.put(columnName, cell.getBooleanCellValue());
                                    break;
                                default:
                                    rowMap.put(columnName, "UNKNOWN");
                                    break;
                            }
                        }
                    }
                    // Add row map to data list
                    dataList.add(rowMap);
                }
            }

            workbook.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return dataList;
    }

    // Function to read and map values from a CSV file and return a list of maps
    public static List<Map<String, Object>> readCsv(String filePath) {
        List<Map<String, Object>> dataList = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            int rowCount = 0;
            List<String> headers = new ArrayList<>();

            // Read the first line as header
            if ((line = br.readLine()) != null) {
                headers = Arrays.asList(line.split(","));
            }

            // Read the rest of the lines as data rows
            while ((line = br.readLine()) != null) {
                rowCount++;
                String[] values = line.split(","); // Split by comma

                // Create a map for each row with column names as keys
                Map<String, Object> rowMap = new HashMap<>();
                for (int i = 0; i < headers.size(); i++) {
                    String columnName = headers.get(i);
                    String cellValue = values.length > i ? values[i] : "";
                    rowMap.put(columnName, cellValue); // Store column name as key
                }

                // Add row map to data list
                dataList.add(rowMap);
            }

            if (rowCount == 0) {
                System.out.println("The CSV file is empty.");
            }

            br.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return dataList;
    }
}
