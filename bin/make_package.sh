#!/bin/bash

set -e

boxname=$(bin/boxname.sh)

vagrant package --base $boxname --output $boxname.box

