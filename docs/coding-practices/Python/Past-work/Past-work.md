---
title: Past Work
layout: default
parent: Python 
grand_parent: Coding Practices
---
# Personal Notes or My Attempts
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
# Setting up config/secret

{:.note}
This file is called `setup_config.py` and it's located in `src/utils/setup_config.py`

```python

import configparser
import os

def set_up_config():
    config = configparser.ConfigParser()
    config_base_path = os.path.abspath(os.getcwd())

    if "abc" == config_base_path.split("/")[-1]:
        rest_of_config_path = "/config/config.ini"
    if "ABC" == config_base_path.split("/")[-1]:
        rest_of_config_path = "/abc/config/config.ini"

    config_result = config.read(f'{config_base_path}{rest_of_config_path}')

    if len(config_result) == 0 :
        raise ImportError('Please put config.ini in the correct location!!')
    return config # This is a MUSTTT

```

To then properly use it in your `main.py`

```python

import utils.setup_config import set_up_config

def main():
    config = set_up_config() # Setup config ini
    secret = set_up_secret() # Setup secret ini

    __version__ = config["APP_NAME"]["version"]

    sub_function(inputDir=config["SENDINGAPI"]["inputDir"])

```

# logging (in python)

```python
import time
import os
from os import path

def get_log_file_name(logDir:str):
    os.makedirs(logDir, exist_ok=True)
    i = 0
    filename = f"{logDir}{time.strftime('%Y-%m-%d')}{str(i)}-LOG.log"
    while path.exists(filename):
        i += 1
        filename = f"{logDir}{time.strftime('%Y-%m-%d')}{str(i)}-LOG.log"
    return filename

```

in `main.py`

```python

from utils.log_generation import get_log_file_name
import logging
import sys


logDir = config["APP_NAME"]["log_dir"]
filename = get_log_file_name(logDir)

logging.basicConfig(filename=filename, level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logging.getLogger().addHandler(logging.StreamHandler())
sys.excepthook = excepthook


logging.info ("DONE!!")

def excepthook(type_, value, traceback):
    logging.getLogger().exception(value)
    sys.__excepthook__(type_, value, traceback)


```



# Tox 

Tox is a venv managing tool that aims to integrate automative and standardize testing  

You can follow this to setup your tox envs

> Note: the `ca-bundle.crt` looks like
> A softlink to the `tls-ca-bundle.pem` !
> AB UniPass Authentications Root CA
> --- Begin Certificate ---
> AB UniPass Root CA, ACCVRAIZ1, AC RAIZ FNMT-RCM, Actalis Auth Root CA, AffirmTrust Networking, Affirmtrust Premium, Amazon Root CA2, Amazon Root CA 3, Atos TrustredRoot 2011, ... emSignECC Root CA - G3

> There's another file called `ca-bundle.trust.crt`

```ini
[tox]
envlist =
    check_format

[testenv]
allowlist_externals = poetry
skip_install = true
deps=
    poetry==1.8.3
    poetry-dynamic-versioning[plugin]==1.2.0
setenv=
    POETRY_CERTIFICATES_ABC_ARTIFACTORY_CERT=/etc/pki/tls/certs/ca-bundle.crt


[testenv:poetry]
commands_pre =
    poetry lock --no-update
    poetry install --no-root
commands=
    poetry {posargs}


[testenv:{format, checkformat}]
commands_pre =
    poetry lock --no-update
    poetry install --no-root --with format
commands=
    format: black . {posargs}
    check_format: black --check --diff --color . {posargs}
    pflake8

[testenv:test]
commands_pre =
    poetry lock --no-update
    poetry install --no-root --with test
setenv =
    {[testenv]setenv}
commands=
    pytest -o log_cli=true -rA


```

# Python tips 

## Finding prime numbers in a list (slow vs quick) [@b001](https://www.youtube.com/shorts/g9fIWtSexLs)
> ### Technique used: filter(), list-comprehension

```python
nums = range(1,1000) # list of nums from 1 - 1000

def is_prime(num):
    for x in range(2,num):
        if (num % x) == 0:
            return False # if not prime
        return True

# Built in python function: filter (def(),list of elements) 
# Means applying the function to each element in the list 
primes_slow = list(filter(is_prime,nums)) # list of filter object 
```
{: .note }

primes_slow returns a 1, which is NOT a prime number
{:.warning}

```python
def is_prime(num):
    for x in range(2,num):
        if (num%x) == 0:
            return False # if not prime
        return True

primes_quick = [x for x in range(2,1000) if is_prime(x)]
```
{:.note}