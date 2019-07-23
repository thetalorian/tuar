#!/bin/bash
echo "<html><head></head><body>"
echo "<h1>Hello, World!</h1>" > index.html
echo "<p>DB Address: ${db_address}</p>" >> index.html
echo "<p>DB port: ${db_port}</p>" >> index.html
echo "</body></html>" >> index.html
nohup busybox httpd -f -p "${server_port}" &