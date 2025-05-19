---
title: hk_eod_parser
layout: default
parent: Python 
grand_parent: Coding Practices
---
# Non-SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
0. File structure

1. `__main__.py`

- Enable logging
- Setting app entry point

```python
import argparse

from hk_eod_parser.nt_eod_parser.nt_parser import NtParser
from hk_eod_parser.kln_eod_parser.kln_parser import KlnParser
from hk_eod_parser.hki_eod_parser.hki_parser import HkiParser

from hk_eod_parser.utils.create_logger import create_logger

def main():
     args_parser = argparse.ArgumentParser(
          prog="HK EOD Parser",
          description="HK EOD Parser parses new territories (nt), kowloon (kln) and hk island (hki)",
          epilog="Please contact <support email> for any issues"
     )

     args_parser.add_argument("-i","--input" help="Input file (.zip or csv)",required=True)
     args_parser.add_argument("-oPath", help="Output file path")
     args_parser.add_argument("-oName","--output_name", help="Output file name")
     args_parser.add_argument("-d", "--district",help="district", required=True)

     args_parser.add_argument("--remove_output", default=False, action=argparse.BooleanOptionalAction, help ="User can remove outputs")

     args_parser.add_arugument("--set_log_level", help="Can set log level: INFO, DEBUG. Defaults to INFO")

     args = vars(args_parser.parse_args())

     parser = None

     # New Territories
     if args["market"] == "nt":
          parser = NtParser(
               districtID="",
               inputPath=args["input"],
               outputPath=args["output"],
               outputName=args["output_name"],
               logging=create_logger("New-Territories-logs", args["log_file_name"], args["set_log_level"]),
          )

     # Kowloon
     if args["market"] in ["kln","kowloon","KLN"]:
          parser = KlnParser(
               districtID="",
               inputPath=args["input"],
               outputPath=args["output"],
               outputName=args["output_name"],
               mapPath=args["mapping_file_path"],
               logging=create_logger("Kowloon-logs", args["log_file_name"], args["set_log_level"]),
          )

     # Hong Kong Island
     if args["market"] == "hki":
          parser = HkiParser(
               districtID=None,
               inputPath=args["input"],
               outputPath=args["output"],
               outputName=args["output_name"],
               logging=create_logger("Kowloon-logs", args["log_file_name"], args["set_log_level"]),
          )

     # Handling exception
     if args["market"] not in ["nt","kln","hki"]:
          logging=create_logger("Incorrect-Parser-logs",args["log_file_name"],"ERROR")
          logging.error(f"Input Market : {args["market"]} is not supported. Existing HK EOD Parser.")
          return


     parser.run()

if __name__ == __main__:
     main()

```

2. Base Class for HK (Parent to NT, KLN, HKI)

3. Base Class for test

4. tox.ini

5. pyproject.toml
```
[tool.poetry]
name = "hk_eod_parser"
version = "1.0.0"

description=""
authors=["milton chow <miltonycchow@gmail.com>"]
readme="README.md"
packages = [{include="hk_eod_parser}]

[tool.poetry.scripts]
hk_eod_parser = 'hk_eod_parser.__main__:main'

[tool.poetry.dependencies]
python = "^3.9"
pandas = "^2.1.4"

[[tool.poetry.source]]
name = "cdp-artifactory"
url = "https://cdp-artifactory.hk.world.apple/artifactory/api/pypi/pypi-python-release/simple"
priority = primary

[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.masonry.api"


[tool.poetry.group.format]
optional = true

[tool.poetry.group.format.dependencies]
black = "^24.3.0"
pyproject-flake8 = "^6.1"

[tool.black]
line-length = 160
target-version = ["py39"]

[tool.flake8]
max-line-length = 16000
extend-ignore = ["E203"]
exclude = [".venv*/",".tox/"]

[tool.poetry.group.test]
optional = true

[tool.poetry.group.test.dependencies]
psutil = "^5.9.7"
pytest = "^8.0.0"
pydantic = "^2.6.4"
pydantic-settings = "^2.2.1"

[tool.poetry-dynamic-versioning]
enable = true
pattern = "default-unprefixed"

```

6. create_logger.py

```python

import logging
from datetime import datetime
import os

# Log is default to INFO when unspecified
def create_logger(default_district_log_starter:str, log_custom_name:str,log_custom_level:str="INFO"):

     # If User doesn't provide log name nor path
     if log_custom_name is None:
          default_log_directory = os.path.expanduser("~/logs")
          default_district_log_starter = os.path.join(default_log_directory, default_market_log_starter.split("-")[0])

          if not os.path.exists(default_log_directory): #create ~/logs/ if not exist
               os.mkdir(default_log_directory)
          if not os.path.exists(default_district_log_starter): #create ~/logs/kln/ or ~/logs/hki/
               os.mkdir(default_district_log_starter)
     else: # if user provides log_file_name and path or provides only the log_file_name
          if (len(os.path.split(log_custom_name)[0])==0): # if user provided only log_file_name
               log_file_name = os.path.expanduser(f"{default_log_directory}/{log_custom_name}")
          else:
               log_file_name = log_custom_name  # if user provides full log path
     
     logging.basicConfig(filename=log_file_name, format="[%(asctime)s][%(levelname)s] - %(message)s",filemode="w")
     logger = logging.getLogger()
     logger.setLevel(logging.INFO)

     if log_custom_level == "DEBUG"
          logger.setLevel(logging.DEBUG)
     if log_custom_level == "ERROR"
          logger.setLevel(logging.ERROR)
     
     return logger

```

7. upload.json

```json

{
     "files" : [
          {
               "pattern":"dist/hk_eod_parser-(*).tar.gz",
               "target": "pypi-releases-redist-xxxxxxxx-1234-5678-91011-09xxxxxx/hk_eod_parser/{1}/"

          },
          {
               "pattern":"dist/hk_eod_parser-(*)-*-*-*.whl" ,
               "target": "pypi-releases-redist-xxxxxxxx-1234-5678-91011-09xxxxxx/hk_eod_parser/{1}/"
          }
     ]
}

```

8. Jenkinsfile.asia

```groovy
#!/usr/bin/env groovy

@Library('jenkins-libs') _

pipline{
     agent{}
     options{}
     stages{
          stage("Checkout"){
               steps{
                    script{
                         utils.checkout_project()
                    }
               }
          }
     }
}


```