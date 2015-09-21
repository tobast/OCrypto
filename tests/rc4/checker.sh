#!/bin/bash

nofail=true
for data in testdir/*.data; do 
	base=${data%.data}
	./IMPL_REF "${base}.key" "${data}" "${base}.ref.out"
	./IMPL_OCRYPTO "${base}.key" "${data}" "${base}.ocr.out"

	diff ${base}.{ref,ocr}.out > /dev/null
	if (( $? != 0 )); then
		echo "ERROR: Outputs for ${base} differs."
		nofail=false
	else
		rm ${base}.*.out
	fi
done

$nofail && echo "All tests passed."
