predefition is a installed docker including docker-compose on a raspberry pi

As long as the Admin Management not works some usefull commands:
sudo apt-get install apache2-utils
sudo su
cd $(docker volume inspect --format '{{ .Mountpoint }}' arm32v7_htpasswdv)
cd admin
https://community.openhab.org/t/using-nginx-reverse-proxy-authentication-and-https/14542/20

htpasswd commands:

Create htpasswd file:
sudo htpasswd -c htpasswd/htpasswd username

Add user:
sudo htpasswd htpasswd/htpasswd username

Delete user:
sudo htpasswd -D htpasswd/htpasswd username

always restart nginx to apply changes:
docker-compose restart Proxy

