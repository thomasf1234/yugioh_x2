#!/bin/bash

#as postgres user
for file in db/seeds/*.sql;
do
  psql -d yugioh_x2_development -f "${file}"
done
