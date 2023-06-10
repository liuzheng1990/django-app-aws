# My Example Django App for learning CI/CD# django-app-aws

## List of environment variables to set

```
POSTGRES_DBNAME: postgres
POSTGRES_USERNAME: postgres
POSTGRES_PASSWORD: example
POSTGRES_HOST: db
POSTGRES_PORT: 5432
```

## Deployments

### Deploy a local dev environement

In order to deploy a local dev environement, run `make setup_dev`.
This command will:

1. Create a virtualenv called `venv` in the root directory of the project.
2. `pip` install all dependent Python packages.

This option does not try to run the web application using any web server.


### Deploy to a VM (e.g.: AWS EC2) environment

To deploy this app to a remote VM, run:

```
sudo make prepare_vm        # install dependent softwares/libraries
make config_vm              # do initial configuration
sudo make deploy_vm         # deploy the web server
```

The current web server architecture is the following:

![architecture on VM](readme-architecture.png)

We used `uWSGI` to run the web application. The `uWSGI` command was daemonized by `supervisord`. An `Nginx` server sits in the front, forwarding the HTTP traffic to the web application to the `uWSGI` daemon, and the traffic to the static assets to the Nginx static file service.

Currently, we don't use any network-based database yet. A `sqlite` DB was included in the app. This should be changed in the next steps.