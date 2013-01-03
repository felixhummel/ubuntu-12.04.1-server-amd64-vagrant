#!/bin/bash

set -e

BOXNAME=`perl -ne 'chomp and print' BOXNAME`

vagrant package --base $BOXNAME

