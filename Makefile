

init_git_submodules :
	git submodule init
	git submodule update --recursive --remote
	git submodule foreach --recursive git checkout master

build: init_git_submodules 
	@echo "building for amd64"
	@echo "building grafana with plugins"
	${MAKE} -C submodules/grafana-plugin-docker build
	@echo "building LuftdatenBoxStarter"
	${MAKE} -C submodules/LuftdatenBoxStarter build
	@echo "building htpasswdUserManagement"
	${MAKE} -C submodules/htpasswdUserManagement build
	@echo "creating self signed csr, crt, key"
	${MAKE} -C amd64/ssl build
	${MAKE} -C amd64/ssl run
	@echo "done"

start:
	@echo "starting"
	cd amd64; docker-compose up -d

stop:
	@echo "stopping"
	cd amd64; docker-compose down

build_rpi: init_git_submodules
	@echo "building for arm32v7"
	@echo "building grafana with plugins"
	${MAKE} -C submodules/grafana-plugin-docker build_rpi
	@echo "building LuftdatenBoxStarter"
	${MAKE} -C submodules/LuftdatenBoxStarter build_rpi
	@echo "building htpasswdUserManagement"
	${MAKE} -C submodules/htpasswdUserManagement build_rpi
	@echo "creating self signed csr, crt, key"
	${MAKE} -C arm32v7/ssl build_rpi
	${MAKE} -C arm32v7/ssl run_rpi
	@echo "done"

start_rpi:
	cd arm32v7; docker-compose up -d

stop_rpi:
	@echo "stopping"
	cd arm32v7; docker-compose down

clean :
	@echo "cleaning everything"
	@echo "stopping all running container"
	docker stop $(docker ps -a -q)
	@echo "remove all container"
	docker rm -f $(docker ps -a -q)
	@echo "remove all images"
	docker rmi -f $(docker images -q)
	@echo "prune all networks"
	echo "y" | docker system prune
	@echo "prune all volumes"
	echo "y" | docker volume prune


