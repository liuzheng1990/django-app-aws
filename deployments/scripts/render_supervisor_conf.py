import os
from jinja2 import Environment, FileSystemLoader


DEPPLOYMENTS_DIRPATH = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        ".."
    )
)
TEMPLATE_FILEPATH = "uwsgi-supervisor.conf.template"
OUTPUT_FILEPATH = os.path.join(
    DEPPLOYMENTS_DIRPATH, "uwsgi-supervisor.conf"
)
print("Deployments dir: {}".format(DEPPLOYMENTS_DIRPATH))


def get_cwd():
    return os.path.abspath(
        os.path.join(
            DEPPLOYMENTS_DIRPATH,
            ".."
        )
    )


if __name__ == "__main__":
    env = Environment(
        loader=FileSystemLoader(DEPPLOYMENTS_DIRPATH)
    )
    template = env.get_template(TEMPLATE_FILEPATH)
    context = {
        "cwd": get_cwd()
    }
    output = template.render(context)
    with open(OUTPUT_FILEPATH, 'w') as fhand:
        fhand.write(output)
