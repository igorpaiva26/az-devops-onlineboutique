#!/bin/bash
cd online-boutique-cicd
docker-compose -f docker-compose-test.yml down
echo "Online Boutique parado"
