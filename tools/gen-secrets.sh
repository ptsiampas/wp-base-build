#!/bin/bash
for x in laserkraft-msql-root laserkraft-wp-user laserkraft-wp-user-pass; 
do 
 openssl rand -base64 20 | docker secret create ${x} -; 
done

