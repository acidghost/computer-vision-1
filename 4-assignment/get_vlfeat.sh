#!/usr/bin/env bash

vlf_version=vlfeat-0.9.20

if [ -d "$vlf_version" ]; then
	echo 'VLFeat already present'
else
	wget "http://www.vlfeat.org/download/"${vlf_version}"-bin.tar.gz"
	tar xzvf ${vlf_version}"-bin.tar.gz"
	rm ${vlf_version}"-bin.tar.gz"
fi
