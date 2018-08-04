#!/usr/bin/env python3

from setuptools import setup, find_packages

with open("README.rst") as readme_file:
    readme = readme_file.read()

with open("HISTORY.rst") as history_file:
    history = history_file.read()

requirements = []
dependency_links = []
extra_requirements = {}
# requirements = [
#     "attrs==18.1.0",
#     "blinker==1.4.0",
#     "click==6.7",
#     "huepy==0.9.6",
#     "Logbook==1.2.1",
#     # Can use marshmallow or the toasted flavour as you like ;-)
#     # "marshmallow==2.14.0",
#     "toastedmarshmallow==0.2.6",
#     "pendulum==1.3.1",
#     "PyNaCl==1.2.0",
#     "simplejson==3.10.0",
#     "python-decouple==3.1",
#     "trio==0.4.0",
#     "python-interface==1.4.0",
#     "async_generator >= 1.9",
#     "raven==6.8.0",
#     'contextvars==2.1;python_version<"3.7"',
# ]
# dependency_links = [
#     # need to use --process-dependency-links option for this
#     "git+https://github.com/fusepy/fusepy.git#egg=fusepy-3.0.0"
# ]

# extra_requirements = {
#     "drive": ["pydrive==1.3.1"],
#     "dropbox": ["dropbox==7.2.1"],
#     "fuse": ["fusepy==3.0.0"],
#     "postgresql": ["asyncpg==0.15.0", "trio-asyncio==0.7.0"],
#     "s3": ["boto3==1.4.4", "botocore==1.5.46"],
#     "openstack": ["python-swiftclient==3.5.0", "pbr==4.0.2", "futures==3.1.1"],
# }
# requirements += extra_requirements['postgresql']
# requirements += extra_requirements['fuse']

setup(
    name="parsec-cloud",
    version="0.6.0",
    description="Secure cloud framework",
    long_description=readme + "\n\n" + history,
    author="Scille SAS",
    author_email="contact@scille.fr",
    url="https://github.com/Scille/parsec-cloud",
    packages=find_packages(),
    package_data={"parsec": ["resources"]},
    package_dir={"parsec": "parsec"},
    include_package_data=True,
    install_requires=requirements,
    dependency_links=dependency_links,
    extras_require=extra_requirements,
    entry_points={"console_scripts": ["parsec = parsec.cli:cli"]},
    license="GPLv3",
    zip_safe=False,
    keywords="parsec",
    classifiers=[
        "Development Status :: 2 - Pre-Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)",
        "Natural Language :: English",
        "Programming Language :: Python :: 3.5",
    ],
)