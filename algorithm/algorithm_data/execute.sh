#!/bin/bash
hive -f createtable_loaddata.hql
for i in {1..4}; do hive -f query/query-1.hql; done
