
clean:
	echo "#!/bin/bash\nSelfSignedRootCAPassword=\"x\"" > sslConfig.sh
	docker-compose down --rmi all
	./removeVolumesForcefully.sh

build_rpi:
	docker-compose build

run_rpi:
	./configOwnIPAddress.sh
	docker-compose up
