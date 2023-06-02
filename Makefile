all:
	echo "Please specify action!"

setup_vm: requirements_vm.txt
	@if [ "$(shell whoami)" != "root" ]; then \
		echo "Please run make setup_vm as sudo!"; \
		exit 1; \
	fi

	apt-get install -y python3-dev python3-pip supervisor nginx
	systemctl enable supervisor.service
	systemctl restart supervisor.service
	python3 -m pip install -r requirements_vm.txt
	python3 manage.py collectstatic --no-input
	python3 deployments/scripts/render_supervisor_conf.py

	ln -s "$(shell pwd)/deployments/uwsgi-supervisor.conf" \
		/etc/supervisor/conf.d/uwsgi-supervisor.conf
	supervisorctl update
	supervisorctl status

clean_vm:
	@if [ "$(shell whoami)" != "root" ]; then \
		echo "Please run make clean_vm as sudo!"; \
		exit 1; \
	fi
	@if [ -f "/etc/supervisor/conf.d/uwsgi-supervisor.conf" ]; then \
		echo "Remove /etc/supervisor/conf.d/uwsgi-supervisor.conf..."; \
		rm "/etc/supervisor/conf.d/uwsgi-supervisor.conf"; \
	fi
	echo "$(shell pwd)/deployments/uwsgi-supervisor.conf"
	ls "$(shell pwd)/deployments/uwsgi-supervisor.conf"
	@if [ -f "$(shell pwd)/deployments/uwsgi-supervisor.conf" ]; then \
	echo "$(shell pwd)/deployments/uwsgi-supervisor.conf..."; \
		rm "$(shell pwd)/deployments/uwsgi-supervisor.conf"; \
	fi
	supervisorctl update
	supervisorctl status
	rm -r static/
	

setup_dev: requirements_dev.txt
	@if [ ! -d "venv" ]; then \
		virtualenv venv; \
	fi
	venv/bin/pip install -r requirements_dev.txt
	@echo ""
	@echo "The venv set up complete. Before running any Django command, please activate venv."
	@echo "You know how!"
