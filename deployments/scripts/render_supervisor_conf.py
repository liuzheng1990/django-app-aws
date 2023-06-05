import os
from jinja2 import Environment, FileSystemLoader


DEPPLOYMENTS_DIRPATH = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        ".."
    )
)
print("Deployments dir: {}".format(DEPPLOYMENTS_DIRPATH))

user_tmp_filepath = os.path.join(
    DEPPLOYMENTS_DIRPATH, "user.tmp"
)

group_tmp_filepath = os.path.join(
    DEPPLOYMENTS_DIRPATH, "group.tmp"
)

if not (os.path.exists(user_tmp_filepath) and os.path.exists(group_tmp_filepath)):
    raise FileNotFoundError("Please run make config_vm first!")


templates = {
    "uwsgi-supervisor.conf": "uwsgi-supervisor.conf.template",
    "uwsgi-nginx.conf": "uwsgi-nginx.conf.template"
}


def get_filepath_in_dep_dir(filename_in_dep_dir):
    return os.path.join(
        DEPPLOYMENTS_DIRPATH, filename_in_dep_dir
    )


def get_cwd():
    return os.path.abspath(
        os.path.join(
            DEPPLOYMENTS_DIRPATH,
            ".."
        )
    )

def get_user():
    with open(user_tmp_filepath, 'r') as fhand:
        return fhand.read().strip()

def get_primary_group():
    with open(group_tmp_filepath, 'r') as fhand:
        return fhand.read().strip()


if __name__ == "__main__":
    env = Environment(
        loader=FileSystemLoader(DEPPLOYMENTS_DIRPATH)
    )
    for output_fn in templates:
        template_fn = templates[output_fn]
        output_filepath = get_filepath_in_dep_dir(output_fn)
        template = env.get_template(template_fn)
        context = {
            "cwd": get_cwd(),
            "user": get_user(),
            "group": get_primary_group()
        }
        output = template.render(context)
        with open(output_filepath, 'w') as fhand:
            fhand.write(output)
