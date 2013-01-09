#!/bin/bash

BOXNAME=`perl -ne 'chomp and print' BOXNAME`

VBoxManage unregistervm $BOXNAME --delete


