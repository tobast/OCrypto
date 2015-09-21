#!/bin/bash

# Make ocrypto
echo "########### BUILDING OCRYPTO'S RC4 ###########"
( cd ../../ && obuild configure && obuild build exe-IMPL_RC4_OCRYPTO )
cp ../../IMPL_RC4_OCRYPTO ./IMPL_OCRYPTO

# Make ref
echo "########### BUILDING REFERENCE RC4 ###########"
make -C ref_impl
cp ref_impl/IMPL_REF .

# Generate tests
echo "########## GENERATING KEY/DATA PAIRS #########"
python ./generate_tests.py

# Testing.
echo "########### TESTING IMPLEMENTATIONS ##########"
bash ./checker.sh
