#!/bin/bash

boxname=`bin/boxname.sh`

VBoxManage unregistervm $boxname --delete


