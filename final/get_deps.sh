#!/usr/bin/env bash

vlf_version=vlfeat-0.9.20
libsvm_version=libsvm-3.21

if [ -d "$vlf_version" ]; then
	echo 'VLFeat already present'
else
	wget "http://www.vlfeat.org/download/"${vlf_version}"-bin.tar.gz"
	tar xzvf ${vlf_version}"-bin.tar.gz"
	rm ${vlf_version}"-bin.tar.gz"
fi

if [ -d "$libsvm_version" ]; then
	echo 'LIBSVM already present'
else
	wget "http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/libsvm.cgi?+http://www.csie.ntu.edu.tw/~cjlin/libsvm+tar.gz"
	tar xzvf ${libsvm_version}".tar.gz"
	rm ${libsvm_version}".tar.gz"
fi

