-- DROP FUNCTION IF EXIATA spreadsheetml_table(xml);
CREATE OR REPLACE FUNCTION spreadsheetml_table(xl xml)
RETURNS TABLE(rn integer, cell_data text, cell_type text) IMMUTABLE AS
$body$
 select *
 from xmltable
 (
  XMLNAMESPACES
  (
   'urn:schemas-microsoft-com:office:spreadsheet' as msoxl,
   'urn:schemas-microsoft-com:office:office'      as o,
   'urn:schemas-microsoft-com:office:excel'       as x,
   'urn:schemas-microsoft-com:office:spreadsheet' as ss,
   'http://www.w3.org/TR/REC-html40' as html
  ),
  '/msoxl:Workbook/msoxl:Worksheet/msoxl:Table/msoxl:Row/msoxl:Cell'
  passing by ref xl
  columns
  rn for ordinality,
  cell_data text path 'msoxl:Data',
  cell_type text path 'msoxl:Data/@msoxl:Type'
 ) xlt;
$body$ LANGUAGE sql;
