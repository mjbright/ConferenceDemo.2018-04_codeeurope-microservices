#!/bin/bash

SERVICE_URL=http://192.168.99.100:31455
VISUALIZER_URL=http://127.0.0.1:8002

#sed -e "s/SERVICE_URL/$SERVICE_URL/g" \
    #-e "s/VISUALIZER_URL/$VISUALIZER_URL/g" \
    #demo.html.template > demo.html

sed -e "s-SERVICE_URL-$SERVICE_URL-g" \
    -e "s-VISUALIZER_URL-$VISUALIZER_URL-g" \
    demo.html.template > demo.html

