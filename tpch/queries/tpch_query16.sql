-- create the result table
drop table if exists q16_parts_supplier_relationship;
create table q16_parts_supplier_relationship(p_brand string, p_type string, p_size int, supplier_cnt int);
drop table if exists q16_tmp;
create table q16_tmp(p_brand string, p_type string, p_size int, ps_suppkey int);
drop table if exists supplier_tmp;
create table supplier_tmp(s_suppkey int);


-- the query
insert overwrite table supplier_tmp
select 
  s_suppkey
from 
  supplier
where 
  not s_comment like '%Customer%Complaints%';

insert overwrite table q16_tmp
select 
  p_brand, p_type, p_size, ps_suppkey
from 
  partsupp ps join part p 
  on 
    p.p_partkey = ps.ps_partkey and p.p_brand <> 'Brand#34' 
    and not p.p_type like 'ECONOMY BRUSHED%'
  join supplier_tmp s 
  on 
    ps.ps_suppkey = s.s_suppkey;

insert overwrite table q16_parts_supplier_relationship
select 
  p_brand, p_type, p_size, count(distinct ps_suppkey) as supplier_cnt
from 
  (select 
     * 
   from
     q16_tmp 
   where p_size = 22 or p_size = 14 or p_size = 27 or
         p_size = 49 or p_size = 21 or p_size = 33 or
         p_size = 35 or p_size = 28
) q16_all
group by 
p_brand, 
p_type, 
p_size
order by 
supplier_cnt desc, 
p_brand, 
p_type, 
p_size;