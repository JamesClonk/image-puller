#!/bin/sh

for image in $(cat /app/images.dat); do
	echo "pulling ${image} ..."
	if [[ $(echo "${image}" | grep sha256) ]]; then
		image_base=$(echo "${image}" | sed 's/\(.*\)@sha256:.*/\1/g')
		crane ls ${image_base}
		images=$(crane ls ${image_base})
		for image in $images; do
			echo "${image_base}:${image}"
			crane pull "${image_base}:${image}" tmp.tgz && rm -f tmp.tgz
		done
	else
		crane ls $(echo "${image}" | sed 's/:.*//g')
		crane pull ${image} tmp.tgz && rm -f tmp.tgz

	fi
	echo "none"
done
