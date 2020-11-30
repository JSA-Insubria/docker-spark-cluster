CREATE TABLE part (
p_partkey BIGINT,
p_name STRING,
p_mfgr STRING,
p_brand STRING,
p_type STRING,
p_size BIGINT,
p_container STRING,
p_retailprice DECIMAL,
p_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';


CREATE TABLE supplier (
s_suppkey BIGINT,
s_name STRING,
s_address STRING,
s_nationkey BIGINT,
s_phone STRING,
s_acctbal DECIMAL,
s_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';


CREATE TABLE partsupp (
ps_partkey BIGINT,
ps_suppkey BIGINT,
ps_availqty BIGINT,
ps_supplycost DECIMAL,
ps_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';


CREATE TABLE customer (
c_custkey BIGINT,
c_name STRING,
c_address STRING,
c_nationkey BIGINT,
c_phone STRING,
c_acctbal DECIMAL,
c_mktsegment STRING,
c_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';


CREATE TABLE orders (
o_orderkey BIGINT,
o_custkey BIGINT,
o_orderstatus STRING,
o_totalprice DECIMAL,
o_orderdate DATE,
o_orderpriority STRING,
o_clerk STRING,
o_shippriority BIGINT,
o_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';


CREATE TABLE lineitem (
l_orderkey BIGINT,
l_partkey BIGINT,
l_suppkey BIGINT,
l_linenuber BIGINT,
l_quantity DECIMAL,
l_extendedprice DECIMAL,
l_discount DECIMAL,
l_tax DECIMAL,
l_returnflag STRING,
l_linestatus STRING,
l_shipdate DATE,
l_commitdate DATE,
l_receiptdate DATE,
l_shipinstruct STRING,
l_shipmode STRING,
l_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';


CREATE TABLE nation (
n_nationkey BIGINT,
n_name STRING,
n_regionkey BIGINT,
n_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';


CREATE TABLE region (
r_regionkey BIGINT,
r_name STRING,
r_comment STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';



LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/part.tbl' OVERWRITE INTO TABLE part;
LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/supplier.tbl' OVERWRITE INTO TABLE supplier;
LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/partsupp.tbl' OVERWRITE INTO TABLE partsupp;
LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/customer.tbl' OVERWRITE INTO TABLE customer;
LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/orders.tbl' OVERWRITE INTO TABLE orders;
LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/lineitem.tbl' OVERWRITE INTO TABLE lineitem;
LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/nation.tbl' OVERWRITE INTO TABLE nation;
LOAD DATA LOCAL INPATH '/home/hadoop/dataset/tpch/region.tbl' OVERWRITE INTO TABLE region;
