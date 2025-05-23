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
## 0. File structure
- .github/workflows/auto_git_release.yml
- assets/inputs/
     - nt/
     - kln/
     - hki/
- hk_eod_parser/
     - nt_eod_parser/
          - logs/
          - __init__.py
          - nt_eod_parser.py
     - kln_eod_parser/
          - logs/
          - __init__.py
          - kln_eod_parser.py
     - hki_eod_parser/
          - logs/
          - __init__.py
          - hki_eod_parser.py
     - helper/
          - kln_mapping/
               - kln_mapping.csv
          - __init__.py
     - utils/
          - create_logger.py
          - create_new_folder.py
          - mapping_file_filter.py
          - self_defined_classes.py
          - timing.py
          - __init__.py
     - __init__.py
     - __main__.py
     - hk_parser.py
- tests/
     - integration_test/
          - __init__.py
          - base.py
          - test_parser.py
     - resources/
     - utils/
     - __init__.py
- .gitignore
- Jenkinsfile.asia
- README.md
- poetry.lock
- pyproject.toml
- tox.ini
- upload.json

```bash
.
├── .github
│   └── workflows
│       └── auto_git_release.yml
├── assets
│   └── inputs
│       ├── nt
│       ├── kln
│       └── hki
├── hk_eod_parser
│   ├── nt_eod_parser
│   │   ├── logs
│   │   ├── __init__.py
│   │   └── nt_eod_parser.py
│   ├── kln_eod_parser
│   │   ├── logs
│   │   ├── __init__.py
│   │   └── kln_eod_parser.py
│   ├── hki_eod_parser
│   │   ├── logs
│   │   ├── __init__.py
│   │   └── hki_eod_parser.py
│   ├── helper
│   │   ├── kln_mapping
│   │   │   └── kln_mapping.csv
│   │   └── __init__.py
│   ├── utils
│   │   ├── create_logger.py
│   │   ├── create_new_folder.py
│   │   ├── mapping_file_filter.py
│   │   ├── self_defined_classes.py
│   │   ├── timing.py
│   │   └── __init__.py
│   ├── __init__.py
│   ├── __main__.py
│   └── hk_parser.py
├── tests
│   ├── integration_test
│   │   ├── __init__.py
│   │   ├── base.py
│   │   └── test_parser.py
│   ├── resources
│   ├── utils
│   └── __init__.py
├── .gitignore
├── Jenkinsfile.asia
├── README.md
├── poetry.lock
├── pyproject.toml
├── tox.ini
└── upload.json

```

## 1. `__main__.py`

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
     args_parser.add_argument("-map","--mapping_file_path" help="Mapping file",required=True)   
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
     else:
          logging = create_logger("Incorrect-Parser-logs",args["log_file_name"],"ERROR")
          logging.error(f"Input Market : {args["market"]} is not supported. Existing HK EOD Parser.")
          return


     parser.run()

if __name__ == __main__:
     main()

```

## 2. Base Class for HK (Parent to NT, KLN, HKI) = hk_parser.py
```python
from datetime import datetime
from datetime import timedelta #offsetting days
import pytz #timezone stuff
from abc import ABC, abstractmethod

class HkParser(ABC):
     def __init__(self, marketID:str, outputName:str, inputPath:str, outputPath:str, logging):
          self.marketID = marketID
          self.inputPath = inputPath
          self.outputPath = outputPath
          self.outputName = outputName
          self._logger = logging

     def _time_since_epoc(self, date:str, hour:str, mins:str, secs:str, milisecs:str) -> int:
          time = f'{hour}:{mins}:{secs}.{milisecs}'
          dt = (datetime.strptime(date + time, "%Y%m%d %H:%M:%s.%f")- timedelta(hours=1)).astimezone(pytz.timezone("Asia/Tokyo"))
          return int(dt.timestamp()*1,000,000)
     
     @abstractmethod
     def parse_and_output():
          pass

     def run(self):
          self.parse_and_output()
```


## 3. Base Class for test

## 4. tox.ini

## 5. `pyproject.toml`

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

## 6. `create_logger.py`

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

## 7. upload.json

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

## 8. Jenkinsfile.asia

```groovy
#!/usr/bin/env groovy

@Library('jenkins-libs') _

pipline{
     agent{ node {label "build_el69" } }
     options{
          buildDiscarder(logRotator(numToKeepStr:"20", artifactNumToKeepStr: "20"))
     }
     stages{
          stage("Checkout"){
               steps{
                    script{
                         utils.checkout_project()
                    }
               }
          }
          stage("Test"){
               steps{
                    script{
                         utils.with_jfrog_credentials{ sh("tox run") }
                    }
               }
          }
          stage("Build and publish"){
               when { buildingTag() }
               steps{
                    script{
                         utils.with_jfrog_credentials{ sh("tox run -e build")}
                         utils.jf_retry("rt upload --detailed-summary --spec upload.json")
                    }
               }
          }
     }
}
```

## hk_eod_parser/utils

### 9. self_defined_classes.py

```python
from dataclasses import dataclass
import pandas as pd
import logging

@dataclass
class Dataframe:
     df: pd.DataFrame

class Logging:
     logger: logging
```

### 10. mapping_file_filter.py

```python
import re
import csv
import logging

def mapping_file_filter(map_path:str) -> str | list:
     mappingList = None
     if map_path.split("/")[-1].split(".")[-1] == "txt":
          logging.info("Parsing with txt mapping file")
          with open(f"{map_path}", "r", encoding="utf-8") as _mapping:
               mappingList = re.split("\n|,", (_mapping.read()))
     if map_path.split("/")[-1].split(".")[-1] == "csv":
          logging.info("Parsing with csv mapping file")
          mappingList = []
          with open(map_path) as _mapping:
               mappingList.append(row[0])
               mappingList.append(row[1])
     return mappingList
```

### 11. create_new_folder.py

```python
import os

def create_new_folder(path):
     if not os.path.exists(path):
          os.makedirs(path)
```

### 12. create_logger.py

```python
import logging
from datetime import datetime
import os

# This is not the best design, need some refactoring here

def create_logger(default_market_log_starter:str, log_custom_name:str, log_custom_level:str="INFO"):
     if log_custom_name is None:
          default_log_directory = os

```