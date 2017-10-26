
#create passwd file
sudo mosquitto_passwd -c passwd newuser
#mount to /mosquitto/passwd

#/etc/mosquitto/conf.d/default.conf
allow_anonymous false
password_file /etc/mosquitto/passw
listener 1883 localhost

listener 8883
certfile /mosquitto/certs/server.crt
cafile /mosquitto/csr/server.csr
keyfile /mosquitto/private/server.key

listener 9001
protocol websockets
certfile /mosquitto/certs/server.crt
cafile /mosquitto/csr/server.csr
keyfile /mosquitto/private/server.key
