#!/bin/bash

echo 'Test Number #1'
echo '---------------------------'
docker-compose -f docker-compose.yml up

echo 'Test Number #2'
echo '---------------------------'
docker-compose -f docker-stack.yml up