-- 5 is a parameter, the number of spreadsheet columns
select 
  (row_number - 1) / 5 ordinal,
  max(cell_data) filter (where row_number % 5 =  1) "A",  
  max(cell_data) filter (where row_number % 5 =  2) "B",  
  max(cell_data) filter (where row_number % 5 =  3) "C",
  max(cell_data) filter (where row_number % 5 =  4) "D",  
  max(cell_data) filter (where row_number % 5 =  0) "E"
from spreadsheetml_fromfile('path-to/ecb.xml') 
group by ordinal
order by ordinal;
