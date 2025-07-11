#!/bin/bash

source ~/.venv/bin/activate

echo "Doing post install steps"
./post_install.sh

# export CXX=/usr/local/bin/gxx-wrapper

echo "Launching app http://$GRADIO_SERVER_NAME:$GRADIO_SERVER_PORT"
python3 app.py

echo "Something went wrong and it exited?"