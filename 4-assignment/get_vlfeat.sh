#!/usr/bin/env bash

if [ -d "vlfeat-0.9.20" ]; then
	echo 'VLFeat already present'
else
	wget http://www.vlfeat.org/download/vlfeat-0.9.20-bin.tar.gz
	tar xzvf vlfeat-0.9.20-bin.tar.gz
	rm vlfeat-0.9.20-bin.tar.gz
fi
