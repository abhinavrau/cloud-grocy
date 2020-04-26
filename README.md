![Logo of the project](images/cloud-grocy-logo.png)

# cloud-grocy
> Get your [grocy](https://grocy.info) server running securely in the cloud for free!

Opinionated script to deploy and run [grocy](https://grocy.info) (ERP beyond your fridge) on AWS, [DuckDNS](https://duckdns.org) (free DNS provider) and [LetsEncrypt](https://letsencrypt.org/)

## Features

* Deploys to AWS EC2 t2.micro instance (free tier i.e. free for one year with a new AWS account).
* Enable HTTPS only access with [LetsEncrypt](https://letsencrypt.org/) Certificates with auto renewal.
* Register host with [DuckDNS](https://duckdns.org)
* Backup grocy database to DropBox daily (because sh*t happens). Dropbox account required to enable backups. It is recommended to use a seperate dropbox account (i.e. not your personal account) to store the backup, since dropbox credentials are copied to AWS. 

## Installing / Getting started

Prerequisites:
* Git cli
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and authenticated to an AWS account with the right permissions to create EC2 instances. [Video Tutorial](https://www.youtube.com/watch?v=FOK5BPy30HQ)
* [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html) installed
* Registered [DuckDNS](htts://duckdns.org) domain name. [DuckDNS](https://duckdns.org) is a free service that allows creation of a domain name for free in the duckdns.org top level domain. Use it to register a domain. It will generate a token which you will need for installation.
* Run the following commands from a command prompt. 

```shell
git clone https://github.com/abhinavrau/cloud-grocy.git
cd cloud-grocy/aws
terraform init
terraform plan -out=plan
```

At this step, you will be prompted to enter:

* Domain name (without the duckdns.org suffix) that you registered with [DuckDNS](htts://duckdns.org). 
* DuckDNS token for your domain created in the previous step.  

```shell 
terraform apply "plan"
```

This will do the following:

1. Create a VPC, subnet, firewall rules and a t2.micro EC2 instance running Ubuntu 18.04 with a public IP address
1. Install Docker engine and docker-compose
1. Register the Public IP address of the EC2 instance with DuckDNS.
1. Run nginx and grocy as docker containers provided by the [grocy-docker](https://github.com/grocy/grocy-docker) project
1. Generate free SSL certificates using LetsEncrypt with auto renewal. 

On completion, the script will output:
* The URL of the grocy server
* The public IP address of the EC2 t2.micro instance running grocy.
* The SSH key for the EC2 t2.micro instance

You Grocy server on the cloud is ready! (It may a take a couple of minutes!)

Navigate to the URL and login and change the admin password!

## Backups

In order to do scheduled backups to dropbox, you have to:

* Pre-configure the [dropbox cli](https://github.com/dropbox/dbxcli) (dbxcli) prior to running the `terraform apply` command. 
* Uncomment the `"sudo ./schedule-backup.sh"` line in the aws/servers.tf file before running `terraform plan`. Or Run the same command after the install finishes by ssh into the server.
* Backups will be taken once a day
* Backups will be stored in directory called grocy_backup on Dropbox

## Restoring from Backups

There is a script `restore-from-backup.sh` that can restore the latest backup from dropbox.
To restore after the terraform has successfully completed:
- Login to the AWS instance by running the command from the aws directory
```shell 
../bin/ssh-host.sh
```
This will login you in to the AWS EC2 server. From here run:


## Deleting

If you want to completely destroy all the resources it created on AWS:

```shell 
terraform destroy
```
This will destroy all the resources created on AWS. Please remember to backup!

## Testing

I have personally tested this on my macOS. Testers on Windows and Linux needed!



## Configuration

To change the default behaviour, modify the variables.tf file.

## SSH access the AWS EC2 instance

Make sure you are in the `aws` directory and run:

```shell 
terraform output host_ssh_key > ssh_key.pem
chmod 400 ssh_key.pem
ssh -i ssh_key.pem ubuntu@(terrform output grocy_host)
```

Or 

```shell 
../bin/ssh-host.sh
```

## Developing

TODO

## Project Goals 

* Install and run grocy on the cloud with minimal effort.

* Low cost (Preferably free)

* Automated backups

* Secure

* Make grocy Upgrades painless
    
## Contributing

If you'd like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome.

## Links

- grocy (ERP for your fridge) : https://grocy.info
- Projects that helped and inspire this project:
  - docker-compose-letsencrypt-nginx-proxy-companion: https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
  - grocy-docker: https://github.com/grocy/grocy-docker
  - install-docker.sh gist: https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b
  
- Repository: https://github.com/abhinavrau/cloud-grocy/
- Issue tracker: https://github.com/abhinavrau/cloud-grocy/issues

  - In case of sensitive bugs like security vulnerabilities, please contact
    abhinav dot rau @ gmail directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!


## Licensing
The code in this project is licensed under MIT license.
