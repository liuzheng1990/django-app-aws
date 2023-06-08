FROM    python:3.11.4

WORKDIR '/app'
COPY    requirements_base.txt .
COPY    requirements_container.txt .


RUN     python -m pip install -r requirements_container.txt

COPY     . .

CMD     ["/usr/local/bin/uwsgi", \
        "--module=voteapp.wsgi:application", \
        "--http=0.0.0.0:8080"]