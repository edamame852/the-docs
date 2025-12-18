---
title: AWS 
layout: default
parent: CICD
grand_parent: Coding Practices
has_children: true
---

# AWS Cluster

## Setting up AWS (EC2 instance)
1. Sign in [AWS Console] (https://ap-southeast-2.signin.aws.amazon.com/oauth?client_id=arn%3Aaws%3Asignin%3A%3A%3Aconsole%2Fcanvas&code_challenge=gGu1DVgqrgSSy_zRNOZ1Zb8Ws-Rdy9c7vUInfp4AudA&code_challenge_method=SHA-256&response_type=code&redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Fconsole%2Fhome%3FhashArgs%3D%2523%26isauthcode%3Dtrue%26nc2%3Dh_si%26src%3Dheader-signin%26state%3DhashArgsFromTB_ap-southeast-2_d8d10bc6ff71f544) 

- Note: Account ID = 2131-5779-2220

2. Search up EC2 (Virtual Servers in the Cloud) in the university search bar
3. Launch EC2 instance, click "Launch Instance"
4. Quick Start: Pick "Ubuntu" as the AMI = Amazon Machine Image (AMI)
5. Select `t3.micro` as the Instance type (Free tier eligible) (on-demand ubuntu is 0.0167 USD per hour)
6. Configure ssh keypair:
    - Key pair name: dev01
    - Key pair type: RSA
    - Private key format: .pem (don't use .ppk la)

7. Network Settings
    - SSH: port 22 (allow IP for remote access from anywhere)
    - HTTPS: port 80 (allow IP for remote access from anywhere)
    - HTTP: port 443 (allow IP for remote access from anywhere)


8.    
    - Quick summary: 
        - CreateSecurityGroup
            - 
            ```bash
                aws ec2 create-security-group --group-name 'launch-wizard-1' --description 'launch-wizard-1 created 2025-11-29T14:35:47.187Z' --vpc-id 'vpc-0c539c8b10866e84d' 
            ```
        - AuthorizeSecurityGroupIngress
            - 
            ```bash
                aws ec2 authorize-security-group-ingress --group-id 'sg-preview-1' --ip-permissions '{"IpProtocol":"tcp","FromPort":22,"ToPort":22,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}' '{"IpProtocol":"tcp","FromPort":443,"ToPort":443,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}' '{"IpProtocol":"tcp","FromPort":80,"ToPort":80,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}' 
            ```
        - RunInstances
            - 
            ```bash
                aws ec2 run-instances --image-id 'ami-0b8d527345fdace59' --instance-type 't3.micro' --key-name 'dev01' --block-device-mappings '{"DeviceName":"/dev/sda1","Ebs":{"Encrypted":false,"DeleteOnTermination":true,"Iops":3000,"SnapshotId":"snap-01a53aa4eb0c4589e","VolumeSize":8,"VolumeType":"gp3","Throughput":125}}' --network-interfaces '{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-preview-1"]}' --credit-specification '{"CpuCredits":"unlimited"}' --metadata-options '{"HttpEndpoint":"enabled","HttpPutResponseHopLimit":2,"HttpTokens":"required"}' --private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' --count '1' 
            ```
9. Launch instnace button --> Success: Successfully initiated launch of instance (i-039f8736dffa921f5)

## Setting up SSH access 

1. the .pem private key is added to `the-docs` repo LOCALLY
2. Go back to the Insatnce page and retrive the `Public IPv4 address`
3. Resolve .pem key permission by `chmod 600 dev01.pem`
    - permission originally: `0644`
        - Owner (you) have ability to read + write 
        - Group: read only 
        - others: read only
    - permission now: `0600`: OpenSSH on the server side strictly requires that the private key is not readable or writable by group or others
        - Owner (you) have ability to read + write 
        - Group: NOTHING
        - others: NOTHING
4. Connect via: `ssh -i dev01.pem ubuntu@3.25.177.133`. Done.

## Setting up CICD for EC2 deployment
1. I am NOT using `git clone`...wtf...
2. Instead of using the personal `dev01.pem` key, Create a new deploy key ! 
    -  Do this on your local machine
    ```bash
        ssh-keygen -t ed25519 -C "github-actions-deploy@myproject" -f deploy_key -N ""
    ```
3. Add the public key to your EC2 instance
    - `cat deploy_key.pub | ssh -i dev01.pem ubuntu@3.25.177.133 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod  chmod 600 ~/.ssh/authorized_keys"`
    - I see that `authorized_key` dir in EC2 is already `600`
    - Proof:
        - 
        ```bash
            ubuntu@ip-172-31-24-205:~$ ls -altr ~/.ssh/
            total 12
            drwx------ 2 ubuntu ubuntu 4096 Nov 29 14:54 .
            drwxr-x--- 4 ubuntu ubuntu 4096 Nov 29 18:31 ..
            -rw------- 1 ubuntu ubuntu  500 Nov 29 18:34 authorized_keys
        ```

4. Add the `deploy_key` (the private one) to the Github Organization's secrets

5. Ensure you have ansible installed on your dev machine locally.
    - If not follow these steps:
        - Step 1: Create ansible sub-dirs: `mkdir -p fastapi-deploy/{group_vars,inventory,roles}&&cd fastapi-deploy`
        - Step 2: Install ansible via pip `python3 -m pip install --user ansible`
        - Step 3: Set up the items to be installed onto EC2 using ansible found under the `ansible/` directory

6. Setup your dockerfile

7. setup your main.py for source code

8. setup your requirements.txt

9. And commit the following code to the main branch

    - 
    ```yaml
        name: Deploy FastAPI

        on:
            push:
                branches: [ main, dev ]

        jobs:
            build-and-deploy:
                runs-on: ubuntu-latest
                steps:
                - name: Checkout code
                uses: actions/checkout@v4

                - name: Set up Docker Buildx
                uses: docker/setup-buildx-action@v3

                - name: Write SSH deploy key
                run: |
                    mkdir -p ~/.ssh
                    {% raw %} echo "${{ secrets.DEPLOY_KEY_DEV }}" > ~/.ssh/deploy_key {% endraw %}
                    chmod 600 ~/.ssh/deploy_key
                    {% raw %} echo -e "Host ${{ vars.DEPLOY_HOST_DEV }}\n  HostName ${{ vars.DEPLOY_HOST_DEV }}\n  User ${{ vars.DEPLOY_USER_DEV || 'ubuntu' }}\n  IdentityFile ~/.ssh/deploy_key\n  StrictHostKeyChecking no" >> ~/.ssh/config {% endraw %}

                - name: Currently NOT IN USE - Login to Docker Hub (optional)
                if: env.DOCKERHUB_USERNAME
                uses: docker/login-action@v3
                with:
                    username: {% raw %} ${{ secrets.DOCKERHUB_USERNAME }} {% endraw %}
                    password: {% raw %} ${{ secrets.DOCKERHUB_TOKEN }} {% endraw %}

                - name: Build → Stream → Deploy to EC2 (zero registry, zero downtime)
                env:
                    HOST: {% raw %} ${{ vars.DEPLOY_HOST_DEV }} {% endraw %}
                    USER: {% raw %} ${{ vars.DEPLOY_USER_DEV }} {% endraw %}
                    DEBUG_TOKEN: {% raw %} ${{ secrets.JWT_DEV_TOKEN }} {% endraw %}
                    SUPABASE_URL: {% raw %} ${{ vars.DEV_SUPABASE_URL }} {% endraw %}
                run: |
                    set -euo pipefail

                    echo "Building Docker image..."
                    docker buildx create --use --name mybuilder || true
                    docker buildx build --load --platform linux/amd64 -t myfastapi:latest .

                    echo "Deploying to ${HOST}..."
                    docker save myfastapi:latest | gzip | ssh -i ~/.ssh/deploy_key \
                    -o StrictHostKeyChecking=no \
                    -o ServerAliveInterval=60 \
                    -o LogLevel=ERROR \
                    ${USER}@${HOST} \
                    "gunzip | docker load && \
                    docker rm -f fastapi || true && \
                    docker run -d \
                        --name fastapi \
                        --restart unless-stopped \
                        -p 127.0.0.1:8000:8000 \
                        -e DEBUG_TOKEN='${DEBUG_TOKEN}' \
                        -e SUPABASE_URL='${SUPABASE_URL}' \
                        myfastapi:latest \
                        uvicorn src.main:app --host 0.0.0.0 --port 8000 && \
                    echo 'DEPLOYED SUCCESSFULLY! Open http://${HOST} now' && \
                    echo 'Swagger: http://${HOST}/docs'"

                    echo ""
                    echo "LIVE → http://${HOST}"
                    echo "Docs → http://${HOST}/docs"
    ```


## Set up auth flow with supabase.com
1. Head over to [superbase](https://supabase.com/), signed up with Github Auth --> create new org
2. Password for Supabase --> ******** (for PosgreDB access)
3. Copy down also these 2 vars from the superbase:
    - `anon` key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3Z2pua2p0d2F4Y3NwYWhsa2lrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ0NzE4NDksImV4cCI6MjA4MDA0Nzg0OX0.LDc08qC9o1keOCFKZw0oLkUamblGhCiQgHRGaoFEw30
    - `superbase_url`: 'https://ywgjnkjtwaxcspahlkik.supabase.co'