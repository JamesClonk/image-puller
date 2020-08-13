#!/bin/sh

for image in $(cat /app/images.dat); do
	echo "pulling ${image} ..."
	crane ls $(echo "${image}" | sed 's/:.*//g')
	crane pull ${image} tmp.tgz && rm -f tmp.tgz
done
