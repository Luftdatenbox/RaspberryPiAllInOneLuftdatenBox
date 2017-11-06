

init_git_submodules :
	git submodule init
	git submodule update --recursive --remote
	git submodule foreach --recursive git checkout master

build_grafana-plugin :
	${MAKE} -C submodules/grafana-plugin-docker build_grafana_plugin

rpi :
	@echo "settig the environment to Raspberry Pi (arm32v7)"
	${MAKE} -C submodules/grafana-plugin-docker rpi

x86_64 :
	@echo "settig the environment to x86_64 (amd64)"
	${MAKE} -C submodules/grafana-plugin-docker x86_64

installsslrpi: init_git_submodules rpi build_grafana-plugin
	cd submodules/LuftdatenBoxStarter; docker-compose build LuftdatenBoxStarterRaspberryPi; cd ../..
	cd arm32v7; docker-compose up -d
	
installssl: init_git_submodules x86_64 build_grafana-plugin
	cd submodules/LuftdatenBoxStarter; docker-compose build LuftdatenBoxStarter; cd ../..
	@echo "creating self signed csr, crt, key"
	cd amd64/ssl; make clean; make build; make run; cd ../..
	@echo "creating stack"
	cd amd64; docker-compose up -d

clean: SHELL:=/bin/bash
clean :
	@echo "cleaning everything"
	@echo "stopping all running container"
	docker stop $(docker ps -a -q)
	@echo "remove all container"
	docker rm $(docker ps -a -q)
	@echo "remove all images"
	docker rmi -f $(docker images -q)
	@echo "prune all networks"
	echo "y" | docker system prune 
	@echo "prune all volumes"
	echo "y" | docker volume prune 
