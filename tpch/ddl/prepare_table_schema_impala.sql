
-- ========================================================== --
-- Query 1 tables ---
-- ========================================================== --
drop table if exists q1_pricing_summary_report;

-- create the target table
CREATE TABLE q1_pricing_summary_report ( L_RETURNFLAG STRING, L_LINESTATUS STRING, SUM_QTY DOUBLE, SUM_BASE_PRICE DOUBLE, SUM_DISC_PRICE DOUBLE, SUM_CHARGE DOUBLE, AVE_QTY DOUBLE, AVE_PRICE DOUBLE, AVE_DISC DOUBLE, COUNT_ORDER INT);

-- ========================================================== --
-- Query 2 tables ---
-- ========================================================== --
DROP TABLE if exists q2_minimum_cost_supplier;
DROP TABLE if exists q2_minimum_cost_supplier_tmp1;
DROP TABLE if exists q2_minimum_cost_supplier_tmp2;

-- create result tables
create table q2_minimum_cost_supplier_tmp1 (s_acctbal double, s_name string, n_name string, p_partkey int, ps_supplycost double, p_mfgr string, s_address string, s_phone string, s_comment string);
create table q2_minimum_cost_supplier_tmp2 (p_partkey int, ps_min_supplycost double);
create table q2_minimum_cost_supplier (s_acctbal double, s_name string, n_name string, p_partkey int, p_mfgr string, s_address string, s_phone string, s_comment string);

-- ========================================================== --
-- Query 3 tables ---
-- ========================================================== --
DROP TABLE if exists q3_shipping_priority;
-- create the target table
create table q3_shipping_priority (l_orderkey bigint, revenue double, o_orderdate string, o_shippriority int);

-- ========================================================== --
-- Query 4 tables ---
-- ========================================================== --
DROP TABLE if exists q4_order_priority_tmp;
DROP TABLE if exists q4_order_priority;
-- create the target table
CREATE TABLE q4_order_priority_tmp (O_ORDERKEY INT);
CREATE TABLE q4_order_priority (O_ORDERPRIORITY STRING, ORDER_COUNT INT);

-- ========================================================== --
-- Query 5 tables ---
-- ========================================================== --
DROP TABLE if exists q5_local_supplier_volume;
-- create the target table
create table q5_local_supplier_volume (N_NAME STRING, REVENUE DOUBLE);

-- ========================================================== --
-- Query 6 tables ---
-- ========================================================== --
DROP TABLE if exists q6_forecast_revenue_change;

-- create the target table
create table q6_forecast_revenue_change (revenue double);

-- ========================================================== --
-- Query 7 tables ---
-- ========================================================== --
DROP TABLE if exists q7_volume_shipping;
DROP TABLE if exists q7_volume_shipping_tmp;
-- create the target table
create table q7_volume_shipping (supp_nation string, cust_nation string, l_year int, revenue double);
create table q7_volume_shipping_tmp(supp_nation string, cust_nation string, s_nationkey int, c_nationkey int);

-- ========================================================== --
-- Query 8 tables ---
-- ========================================================== --
DROP TABLE if exists q8_national_market_share;
-- create the result table
create table q8_national_market_share(o_year string, mkt_share double);

-- ========================================================== --
-- Query 9 tables ---
-- ========================================================== --
DROP TABLE if exists q9_product_type_profit;

-- create the result table
create table q9_product_type_profit (nation string, o_year string, sum_profit double);

-- ========================================================== --
-- Query 10 tables ---
-- ========================================================== --
DROP TABLE if exists q10_returned_item;

-- create the result table
create table q10_returned_item (c_custkey int, c_name string, revenue double, c_acctbal string, n_name string, c_address string, c_phone string, c_comment string);

-- ========================================================== --
-- Query 11 tables ---
-- ========================================================== --
DROP TABLE if exists q11_important_stock;
DROP TABLE if exists q11_part_tmp;
DROP TABLE if exists q11_sum_tmp;

-- create the target table
create table q11_important_stock(ps_partkey INT, value DOUBLE);
create table q11_part_tmp(ps_partkey int, part_value double);
create table q11_sum_tmp(total_value double);

-- ========================================================== --
-- Query 12 tables ---
-- ========================================================== --
DROP TABLE if exists q12_shipping;

-- create the result table
create table q12_shipping(l_shipmode string, high_line_count double, low_line_count double);

-- ========================================================== --
-- Query 13 tables ---
-- ========================================================== --
DROP TABLE if exists q13_customer_distribution;

-- create the result table
create table q13_customer_distribution (c_count int, custdist int);

-- ========================================================== --
-- Query 14 tables ---
-- ========================================================== --
DROP TABLE if exists q14_promotion_effect;

-- create the result table
create table q14_promotion_effect(promo_revenue double);

-- ========================================================== --
-- Query 15 tables ---
-- ========================================================== --
DROP TABLE if exists revenue;
DROP TABLE if exists max_revenue;
DROP TABLE if exists q15_top_supplier;

-- create result tables
create table revenue(supplier_no int, total_revenue double); 
create table max_revenue(max_revenue double); 
create table q15_top_supplier(s_suppkey int, s_name string, s_address string, s_phone string, total_revenue double);

-- ========================================================== --
-- Query 16 tables ---
-- ========================================================== --
DROP TABLE if exists q16_parts_supplier_relationship;
DROP TABLE if exists q16_tmp;
DROP TABLE if exists supplier_tmp;

-- create the result table
create table q16_parts_supplier_relationship(p_brand string, p_type string, p_size int, supplier_cnt int);
create table q16_tmp(p_brand string, p_type string, p_size int, ps_suppkey int);
create table supplier_tmp(s_suppkey int);

-- ========================================================== --
-- Query 17 tables ---
-- ========================================================== --
DROP TABLE if exists q17_small_quantity_order_revenue;
DROP TABLE if exists lineitem_tmp;

-- create the result table
create table q17_small_quantity_order_revenue (avg_yearly double);
create table lineitem_tmp (t_partkey int, t_avg_quantity double);

-- ========================================================== --
-- Query 18 tables ---
-- ========================================================== --
DROP TABLE if exists q18_tmp;
DROP TABLE if exists q18_large_volume_customer;

-- create the result tables
create table q18_tmp(l_orderkey bigint, t_sum_quantity double);
create table q18_large_volume_customer(c_name string, c_custkey int, o_orderkey int, o_orderdate string, o_totalprice double, sum_quantity double);

-- ========================================================== --
-- Query 19 tables ---
-- ========================================================== --
DROP TABLE if exists q19_discounted_revenue;

-- create the result table
create table q19_discounted_revenue(revenue double);

-- ========================================================== --
-- Query 20 tables ---
-- ========================================================== --
DROP TABLE if exists q20_tmp1;
DROP TABLE if exists q20_tmp2;
DROP TABLE if exists q20_tmp3;
DROP TABLE if exists q20_tmp4;
DROP TABLE if exists q20_potential_part_promotion;

-- create the target table
create table q20_tmp1(p_partkey int);
create table q20_tmp2(l_partkey int, l_suppkey int, sum_quantity double);
create table q20_tmp3(ps_suppkey int, ps_availqty int, sum_quantity double);
create table q20_tmp4(ps_suppkey int);
create table q20_potential_part_promotion(s_name string, s_address string);

-- ========================================================== --
-- Query 21 tables ---
-- ========================================================== --
DROP TABLE if exists q21_tmp1;
DROP TABLE if exists q21_tmp2;
DROP TABLE if exists q21_suppliers_who_kept_orders_waiting;

-- create target tables
create table q21_tmp1(l_orderkey bigint, count_suppkey int, max_suppkey int);
create table q21_tmp2(l_orderkey bigint, count_suppkey int, max_suppkey int);
create table q21_suppliers_who_kept_orders_waiting(s_name string, numwait int);


-- ========================================================== --
-- Query 22 tables ---
-- ========================================================== --
DROP TABLE if exists q22_customer_tmp;
DROP TABLE if exists q22_customer_tmp1;
DROP TABLE if exists q22_orders_tmp;
DROP TABLE if exists q22_global_sales_opportunity;

-- create target tables
create table q22_customer_tmp(c_acctbal double, c_custkey int, cntrycode string);
create table q22_customer_tmp1(avg_acctbal double);
create table q22_orders_tmp(o_custkey bigint);
create table q22_global_sales_opportunity(cntrycode string, numcust bigint, totacctbal double);
