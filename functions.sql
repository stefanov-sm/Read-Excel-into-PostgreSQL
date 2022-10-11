CREATE OR REPLACE FUNCTION spreadsheetml_dump(xl xml)
RETURNS TABLE(row_number integer, cell_data text, cell_type text) LANGUAGE sql as
$$
 select * from xmltable
 (
  xmlnamespaces
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
   row_number for ordinality, 
   cell_data text path 'msoxl:Data', 
   cell_type text path 'msoxl:Data/@msoxl:Type'
 );
$$;

CREATE OR REPLACE FUNCTION spreadsheetml_fromfile(xlfile text)
RETURNS TABLE(row_number integer, cell_data text, cell_type text) LANGUAGE plpgsql as
$$
declare
 lo_oid oid;
 xlxml xml;
begin
 lo_oid := lo_import(xlfile);
 xlxml := convert_from(lo_get(lo_oid), 'utf-8')::xml;
 perform lo_unlink(lo_oid);
 return query select * from xmltable
 (
  xmlnamespaces
  (
   'urn:schemas-microsoft-com:office:spreadsheet' as msoxl,
   'urn:schemas-microsoft-com:office:office'      as o,
   'urn:schemas-microsoft-com:office:excel'       as x,
   'urn:schemas-microsoft-com:office:spreadsheet' as ss,
   'http://www.w3.org/TR/REC-html40' as html
  ), 
  '/msoxl:Workbook/msoxl:Worksheet/msoxl:Table/msoxl:Row/msoxl:Cell' 
  passing by ref xlxml
  columns
   row_number for ordinality, 
   cell_data text path 'msoxl:Data', 
   cell_type text path 'msoxl:Data/@msoxl:Type'
 );
end;
$$;
