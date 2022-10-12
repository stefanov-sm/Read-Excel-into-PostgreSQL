<?php
const xlOpenXMLWorkbook = 51, xlXMLSpreadsheet = 46;
// Ref. https://learn.microsoft.com/en-us/office/vba/api/excel.xlfileformat

function xlsx_to_spreadsheetml($xlsx_filename, $xml_filename)
{
    $excel_engine = new COM('Excel.Application');
    $excel_engine -> Visible = FALSE;
    $excel_engine -> DisplayAlerts = FALSE;

    $workbook = $excel_engine -> Workbooks -> Open($xlsx_filename);
    $workbook -> SaveAs($xml_filename, xlXMLSpreadsheet);
    $workbook -> Close(FALSE);
    $excel_engine -> Quit();
};
