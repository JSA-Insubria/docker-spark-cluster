#!/bin/bash

for i in {1..22}; do ./qgen $i > query-$i.sql; done
