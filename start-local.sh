#!/bin/bash
cd online-boutique-cicd
docker-compose -f docker-compose-test.yml up -d
echo "Online Boutique iniciado em http://localhost:9090"
