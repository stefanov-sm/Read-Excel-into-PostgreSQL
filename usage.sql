-- 5 is a parameter, the number of spreadsheet columns
with t as
(
 select *,
 (rn - 1) % 5 col_no, -- rn is 1-based
 (rn - 1) / 5 row_no
 from spreadsheetml_fromfile('path-to/ecb.xml')
)
select
  max(cell_data) filter (where col_no = 0) subject,
  max(cell_data) filter (where col_no = 1) "name",
  max(cell_data) filter (where col_no = 2) ::timestamp date_time,
  max(cell_data) filter (where col_no = 3) "ISO (currency)",
  max(cell_data) filter (where col_no = 4) ::numeric rate
from t
where row_no > 0 -- skip the title row
group by row_no
order by row_no;
