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

