---
title: Logging
layout: default
parent: Python 
grand_parent: Coding Practices
---

# Logging in python

## Version 1: One of the best thus far

- 
    ```python
        import logging
        from logging.handlers import RotatingFileHandler
        import argparse
        import asyncio

        class ABC:
            def __init__(self, logger):
                self.logger = logger
            
            async def run(self):
                self.logger.info("Starting process")

        def setup_logging(log_level:str = "INFO", log_file="./abc.log"):
            logger = logging.getLogger(__name__)
            logger.setLevel(log_level)

            formatter = logging.Formatter(
                "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
                "[File: %(pathname)s, Line: %(lineno)d, Func: %(funcName)s]",
                datefmt="%Y-%m-%d %H:%M:%S",)

            console_handler = logging.StreamHandler()
            console_handler.setLevel(log_level)
            console_handler.setFormatter(formatter)
            logger.addHandler(console_handler)

            file_handler = RotatingFileHandler(log_file, maxBytes=5*1024*1024, backupCount=2)
            file_handler.setLevel(log_level)
            file_handler.setFormatter(formatter)
            logger.addHandler(file_handler)

            return logger


        def main():
            parser = argparse.ArgumentParser(description="ABC process")
            parser.add_argument("--log-level", default="INFO", help="Set the logging level", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"])
            args = parser.parse_args()

            log_level = getattr(logging, args.log_level.upper(), logging.INFO)
            logger = setup_logging(log_level, args.log_file)

            abc = ABC(logger)
            asyncio.run(abc.run())
            
        if __name__ == "__main__":
            main()
    ```