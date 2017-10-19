

all:
	@echo "all command possible commands:"

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

installrpi: init_git_submodules rpi build_grafana-plugin
	cd submodules/LuftdatenBoxStarter; docker-compose build LuftdatenBoxStarterRaspberryPi; cd ../..
	cd arm32v7; docker-compose up -d
	
install: init_git_submodules x86_64 build_grafana-plugin
	cd submodules/LuftdatenBoxStarter; docker-compose build LuftdatenBoxStarter; cd ../..
	cd amd64; docker-compose up -d

