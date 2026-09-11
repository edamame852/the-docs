---
title: k8s - System Design
layout: default
parent: CICD
grand_parent: Coding Practices
has_children: true
---

# Real life scenarios


## DB
1. Updating live app by adding new column w/ 300,000,000 (note: Data is read & written by user 247)
    - Points to note:
        - App cannot afford down time
        - App cannot go offline

    - Absolute wrong ans: Adding new column in one setting (1 dangerous migration)
    - 
    ```
        ALTER TABLE users ADD COLUMN plan text;
        UPDATE users SET plan='free'
    ```
    - Consequences:
        - Lock large number of rows = block traffic to users (they have to wait)


    - Solution: Make column update in different stages:
        - Stage 1: Add new column as NULLABLE (i.e. no default value)
            - In morden DBs, add NULLABLE = meta data change (DB updating own notes on what table looks like) = DB doesn't re-write the 300M rows
            - This operation is done in milliseconds
        - Stage 2: Fill up the empty columns (starting with old rows)? NO ! Not ideal (users are still writing to the table 247, new rows come in without new row info on new column, you will NEVER CATCH UP) 
            - Solution: Fix all the new write first (update application source code logic)
                - Update app src code first (source of collecting new info) and deploy
                - All new entires will contain that column
        - Stage 3: Backfill old rows (IN SMALL BATCHES)
            - Run background job, update every 5000 rows ish, after updating, pause and check DB load + repeat.
            - If load too high, pause and wait for patch processing to cool down 
            - 
            ```
                UPDATE ... LIMIT 5000;
                UPDATE ... LIMIT 5000;

                UPDATE ... LIMIT 5000;

            ```