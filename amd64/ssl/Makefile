
clean:
	echo "#!/bin/bash\nSelfSignedRootCAPassword=\"x\"" > sslConfig.sh
	docker-compose down --rmi all
	./removeVolumesForcefully.sh

build:
	docker-compose build

run:
	./configOwnIPAddress.sh
	docker-compose up
