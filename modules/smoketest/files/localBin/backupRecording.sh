#! /bin/bash

cp /opt/glassfish3/glassfish/domains/bne3/logs/server.log com.bmw.bne3.client.uitests/screenshots/
cp /tmp/smokeTestVideo.mkv com.bmw.bne3.client.uitests/screenshots/
rm -f /opt/glassfish3/glassfish/domains/bne3/logs/server.log
exit 0
