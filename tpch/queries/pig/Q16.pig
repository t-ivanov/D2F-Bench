
parts = LOAD '$input/part' USING 
OrcStorage() AS (p_partkey:long, p_name:chararray, p_mfgr:chararray, p_brand:chararray, p_type:chararray, p_size:long, p_container:chararray, p_retailprice:double, p_comment:chararray);

partsupp = LOAD '$input/partsupp' USING 
OrcStorage() AS (ps_partkey:long, ps_suppkey:long, ps_availqty:long, ps_supplycost:double, ps_comment:chararray);

supplier = LOAD '$input/supplier' USING 
OrcStorage() AS (s_suppkey:long, s_name:chararray, s_address:chararray, s_nationkey:int, s_phone:chararray, s_acctbal:double, s_comment:chararray);

fsupplier = FILTER supplier BY (NOT s_comment MATCHES '.*Customer.*Complaints.*');
fs1 = FOREACH fsupplier GENERATE s_suppkey;

pss = JOIN partsupp BY ps_suppkey, fs1 BY s_suppkey;

fpartsupp = FOREACH pss GENERATE partsupp::ps_partkey as ps_partkey, partsupp::ps_suppkey as ps_suppkey;

fparts = FILTER parts BY 
(p_brand != 'Brand#34' AND NOT (p_type MATCHES 'ECONOMY BRUSHED.*') AND 
(p_size==22) or 
(p_size==14) or
(p_size==27) or
(p_size==49) or
(p_size==21) or
(p_size==33) or
(p_size==35) or
(p_size==28));

pparts = FOREACH fparts GENERATE p_partkey, p_brand, p_type, p_size;

p1 = JOIN pparts BY p_partkey, fpartsupp by ps_partkey;
grResult = GROUP p1 BY (p_brand, p_type, p_size);
countResult = FOREACH grResult
{
  dkeys = DISTINCT p1.ps_suppkey;
  GENERATE group.p_brand as p_brand, group.p_type as p_type, group.p_size as p_size, COUNT(dkeys) as supplier_cnt;
}
orderResult = ORDER countResult BY supplier_cnt DESC, p_brand, p_type, p_size;

STORE orderResult into '$output/Q16_out' USING PigStorage('|');
