import os
from setuptools import setup, find_packages

setup(
    name="Makeutil-target-auto",
    version="0.0.1",

    package_dir={"": "src"},
    packages=find_packages(where="src"),

    description="Automatization building apps with help of GNU Make targets",
    long_description='https://github.com/ol1xy/serduk-fossdev/tree/feature/makeutil/makeutil', 
    long_description_content_type='text/markdown',
    author='ol1xy',
    author_email='alekejserduk1@gmail.com',

    licence='GPLv3'

)