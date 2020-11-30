#!/bin/bash

N=$1

cd 2.18.0_rc2/dbgen
./dbgen -s $N

#Move .tbl in data folder
mv part.tbl ../../part.tbl
mv nation.tbl ../../nation.tbl
mv orders.tbl ../../orders.tbl
mv region.tbl ../../region.tbl
mv customer.tbl ../../customer.tbl
mv lineitem.tbl ../../lineitem.tbl
mv partsupp.tbl ../../partsupp.tbl
mv supplier.tbl ../../supplier.tbl
