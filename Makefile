all:
	echo "Please specify action!"


prepare_vm: requirements_vm.txt
	@if [ "$(shell whoami)" != "root" ]; then \
		echo "Please run make prepare_vm as sudo!"; \
		exit 1; \
	fi

	apt-get install -y python3-dev python3-pip supervisor nginx
	systemctl enable supervisor.service
	systemctl restart supervisor.service


config_vm:
	@if [ "$(shell whoami)" == "root" ]; then \
		echo "Please do not run 'make config_vm' as root!"; \
		exit 1; \
	fi
	echo "My user: $(shell whoami); my group: $(shell groups | awk '{print $$1}')"
	whoami > deployments/user.tmp
	groups | awk '{print $$1}' > deployments/group.tmp
	python3 -m pip install -r requirements_vm.txt
	python3 manage.py collectstatic --no-input
	python3 deployments/scripts/render_supervisor_conf.py


deploy_vm:
	@if [ ! -f "deployments/user.tmp" ]; then \
		echo "Please run 'sudo make prepare_vm' and 'make config_vm' (without sudo privilege) first!"; \
		exit 1; \
	fi
	@if [ "$(shell whoami)" != "root" ]; then \
		echo "Please run make prepare_vm as sudo!"; \
		exit 1; \
	fi
	usermod -a -G $(shell cat deployments/user.tmp) www-data

	rm -f "/etc/supervisor/conf.d/uwsgi-supervisor.conf"
	ln -s "$(shell pwd)/deployments/uwsgi-supervisor.conf" \
		/etc/supervisor/conf.d/uwsgi-supervisor.conf

	rm -f "/etc/nginx/sites-enabled/uwsgi-nginx.conf"
	ln -s "$(shell pwd)/deployments/uwsgi-nginx.conf" \
		/etc/nginx/sites-enabled/uwsgi-nginx.conf

	rm -f "/etc/nginx/sites-enabled/default"
	
	supervisorctl update
	supervisorctl status

	nginx -t
	nginx -s reload


clean_vm:
	@if [ "$(shell whoami)" != "root" ]; then \
		echo "Please run make clean_vm as sudo!"; \
		exit 1; \
	fi
	rm -f "/etc/supervisor/conf.d/uwsgi-supervisor.conf"
	rm -f "/etc/nginx/sites-enabled/uwsgi-nginx.conf"
	rm -f "deployments/uwsgi-supervisor.conf"
	rm -f "deployments/uwsgi-nginx.conf"
	rm -rf static/
	supervisorctl update
	supervisorctl status
	
	@if [ -f deployments/user.tmp ]; then \
		rm deployments/user.tmp; \
	fi
	@if [ -f deployments/group.tmp ]; then \
		rm deployments/group.tmp; \
	fi
	

setup_dev: requirements_dev.txt
	@if [ ! -d "venv" ]; then \
		virtualenv venv; \
	fi
	venv/bin/pip install -r requirements_dev.txt
	@echo ""
	@echo "The venv set up complete. Before running any Django command, please activate venv."
	@echo "You know how!"
