#!/usr/bin/env python
# -*- coding: utf-8 -*-


from setuptools import setup


requirements = ["boto3==1.4.4", "botocore==1.5.46", "PyUpdater==2.5.3"]

setup(
    name="parsec-build",
    version="0.5.0",
    description="Secure cloud build framework",
    author="Scille SAS",
    author_email="contact@scille.fr",
    url="https://github.com/Scille/parsec-build",
    py_modules=["s3_uploader"],
    install_requires=requirements,
    provides=["pyupdater.plugins"],
    entry_points={"pyupdater.plugins": ["s3 = s3_uploader:S3Uploader"]},
    license="GPLv3",
    keywords="parsec",
    classifiers=[
        "Development Status :: 2 - Pre-Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)",
        "Natural Language :: English",
        "Programming Language :: Python :: 3.5",
    ],
)
