#!/bin/bash

echo "Doing post install steps"
./post_install.sh

export CXX=/usr/local/bin/gxx-wrapper

echo "Launching app"
conda run -n trellis python app.py

echo "Something went wrong and it exited?"