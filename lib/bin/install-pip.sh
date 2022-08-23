#!/bin/bash

virtualenv -p python3 /app/$USER/.env

source /app/$USER/.env/bin/activate

python -m pip install -U pip wheel

python -m pip install -r /app/$USER/requirements/custom.txt
