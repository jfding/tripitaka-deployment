#!/bin/bash

# work dir
cd /runtime

# check and prepare python-virtualenv
if [[ ! -d venv ]]; then
  python3 -m venv venv
fi
source /runtime/venv/bin/activate

# install/update modules
pip install -r /code/requirements.txt

# install/update modules
[[ -f /extra_modules/requirements.txt ]] &&  pip install -r /extra_modules/requirements.txt

# run
[[ -z $DEBUG ]] && DEBUG=0
/runtime/venv/bin/python /code/main.py --debug=$DEBUG

