#!/bin/bash
cd /home/ubuntu/Udemy-section5/
npm install
npm run build
chmod 744 push_docker_image.sh
/home/ubuntu/Udemy-section5/push_docker_image.sh
