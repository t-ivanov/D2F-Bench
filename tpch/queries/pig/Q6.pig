
lineitem = load '$input/lineitem' USING 
OrcStorage() as (l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, l_receiptdate,l_shippingstruct, l_shipmode, l_comment);

flineitem = FILTER lineitem BY l_shipdate >= '1993-01-01' AND l_shipdate < '1994-01-01' AND l_discount >= 0.05  AND l_discount <= 0.07 AND l_quantity < 25;

saving = FOREACH flineitem GENERATE l_extendedprice * l_discount;
grpResult = GROUP saving ALL;
sumResult = FOREACH grpResult GENERATE SUM(saving);

store sumResult into '$output/Q6_out' USING PigStorage('|');
