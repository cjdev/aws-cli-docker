# AWS CLI Docker Container
[![GitHub forks](https://img.shields.io/github/forks/sekka1/aws-cli-docker.svg)](https://github.com/sekka1/aws-cli-docker/network)
[![GitHub stars](https://img.shields.io/github/stars/sekka1/aws-cli-docker.svg)](https://github.com/sekka1/aws-cli-docker/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/sekka1/aws-cli-docker.svg)](https://github.com/sekka1/aws-cli-docker/issues)
[![Twitter](https://img.shields.io/twitter/url/https/github.com/sekka1/aws-cli-docker.svg?style=social)](https://twitter.com/intent/tweet?text=AWS%20CLI%20in%20a%20%40Docker%20container%20%40AWSCLI:&url=https://github.com/sekka1/aws-cli-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/cjengineering/aws-cli-docker.svg)](https://hub.docker.com/r/cjengineering/aws-cli-docker/)
[![Docker Stars](https://img.shields.io/docker/stars/cjengineering/aws-cli-docker.svg)](https://hub.docker.com/r/cjengineering/aws-cli-docker/)

Docker container with the AWS CLI installed.

Using [Alpine linux](https://hub.docker.com/_/alpine/).  The Docker image is 87MB

An automated build of this image is on Docker Hub: https://hub.docker.com/r/cjengineering/aws-cli-docker/

## Getting your AWS Keys:

[http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html#cli-signup](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html#cli-signup)

## Passing your keys into this container via environmental variables:

[http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment)

## Command line options for things like setting the region

[http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-command-line](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-command-line)

## You can run any commands available to the AWS CLI

[http://docs.aws.amazon.com/cli/latest/index.html](http://docs.aws.amazon.com/cli/latest/index.html)

## Example Usage:

### Run the kick-ecs-service:
The following error occurs when you attempt to UPDATE your stack with an image that contains code changes that AWS cannot
detect:
```An error occurred (ValidationError) when calling the UpdateStack operation: No updates are to be performed.```

AWS does not have a good way of detecting changes to images, as a way around this limitation,
you will need to change the version of the taskDefinition each you want to deploy an image with changes
so that we can update the stack successfully. The following accomplishes bumping the taskDefinition version:

    docker container run \
    --env AWS_ACCESS_KEY_ID=<<YOUR_ACCESS_KEY_ID>> \
    --env AWS_SECRET_ACCESS_KEY=<<YOUR_SECRET_ACCESS_KEY>> \
    --env AWS_DEFAULT_REGION=us-east-1 \
    --env CLUSTER_NAME=<<YOUR_CLUSTER_NAME>> \
    --env SERVICE_NAME= <<YOUR_SERVICE_NAME>> \
    --env TASK_DEFINITION_NAME= <<YOUR_TASK_DEFINITION_NAME>> \
    aws-cli-docker kick-ecs-service.sh

### Describe an instance:

    docker run \
    --env AWS_ACCESS_KEY_ID=<<YOUR_ACCESS_KEY>> \
    --env AWS_SECRET_ACCESS_KEY=<<YOUR_SECRET_ACCESS>> \
    --env AWS_DEFAULT_REGION=us-east-1 \
    cjengineering/aws-cli-docker \
    aws ec2 describe-instances --instance-ids i-90949d7a

output:

    {
        "Reservations": [
            {
                "OwnerId": "960288280607",
                "ReservationId": "r-1bb15137",
                "Groups": [],
                "RequesterId": "226008221399",
                "Instances": [
                    {
                        "Monitoring": {
                            "State": "enabled"
                        },
                        "PublicDnsName": null,
    ...
    ...
    }

### Return a list of items in s3 bucket

    docker run \
    --env AWS_ACCESS_KEY_ID=<<YOUR_ACCESS_KEY>> \
    --env AWS_SECRET_ACCESS_KEY=<<YOUR_SECRET_ACCESS>> \
    cjengineering/aws-cli-docker \
    aws s3 ls

output:

    2014-06-03 19:41:30 folder1
    2014-06-06 23:02:29 folder2

### Upload content of your current directory (say it contains two files _test.txt_ and _test2.txt_) to s3 bucket

    docker run \
    --env AWS_ACCESS_KEY_ID=<<YOUR_ACCESS_KEY>> \
    --env AWS_SECRET_ACCESS_KEY=<<YOUR_SECRET_ACCESS>> \
    -v $PWD:/data \
    cjengineering/aws-cli-docker \
    aws s3 sync . s3://mybucket

output:

    (dryrun) upload: test.txt to s3://mybucket/test.txt
    (dryrun) upload: test2.txt to s3://mybucket/test2.txt

doc: http://docs.aws.amazon.com/cli/latest/reference/s3/index.html

### Retrieve a decrypted Windows password by passing in your private key
We will map the private keys that resides on your local system to inside the container

    docker run \
    -v <<LOCATION_TO_YOUR_PRIVATE_KEYy>>:/tmp/key.pem \
    --env AWS_ACCESS_KEY_ID=<<YOUR_ACCESS_KEY>> \
    --env AWS_SECRET_ACCESS_KEY=<<YOUR_SECRET_ACCESS>> \
    --env AWS_DEFAULT_REGION=us-east-1 \
    cjengineering/aws-cli-docker \
    aws ec2 get-password-data --instance-id  <<YOUR_INSTANCE_ID>> --priv-launch-key /tmp/key.pem

Output:

    {
        "InstanceId": "i-90949d7a",
        "Timestamp": "2014-12-11T01:18:27.000Z",
        "PasswordData": "8pa%o?foo"
    }

doc: http://docs.aws.amazon.com/cli/latest/reference/ec2/get-password-data.html

## Example Usage with Docker Compose:

    echo AWS_ACCESS_KEY_ID=ID >> .env
    echo AWS_SECRET_ACCESS_KEY=KEY >> .env
    docker-compose run aws s3 ls
