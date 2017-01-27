#!/bin/bash

printf 'HTTP/1.1 200 OK\r\n'
printf 'Server: A shell script less than a dozen lines!\r\n'
printf 'Connection: close\r\n'
printf 'Content-Type: image/jpg\r\n'
printf 'Content-Length: 448166\r\n'
printf '\r\n'
cat /its/pdp10.jpg
sleep 10
exit 0
