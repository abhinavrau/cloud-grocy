![Logo of the project](images/cloud-grocy-logo.png)

# cloud-grocy
> Get your [grocy](https://grocy.info) server running securely in the cloud!

Opinionated script to deploy and run [grocy](https://grocy.info) on AWS (using t2.micro on free tier) and DuckDNS (free DNS provider)

## Features

* Deploys to AWS EC2 t2.micro instance (free tier).
* Enable HTTPS only access with LetsEncrypt Certificates with auto renewal.
* Register host with with [DuckDNS](htts://duckdns.org) , a free DNS service.
* Backup grocy database to DropBox daily (because sh*t happens). Dropbox account required to enable backups.

## Installing / Getting started

Prerequisites:
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and authenticated to an AWS account with the right permissions to create EC2 instances. [Video Tutorial](https://www.youtube.com/watch?v=FOK5BPy30HQ)
* [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html) installed
* Registered [DuckDNS](htts://duckdns.org) domain name. [DuckDNS](htts://duckdns.org) is a free service that allows Create a domain for your grocy server. It will generate a token which you will need in for installation.

```shell
git clone https://github.com/abhinavrau/cloud-grocy/
cd cloud-grocy/aws
terraform init
terraform plan -out=plan
```

At this step, you will be prompted to enter:

* Domain that you registered with [DuckDNS](htts://duckdns.org). 
* DuckDNS token for your domain created in the previous step.   

```shell 
terraform apply "plan"
```

This will do the following:

1. Create a VPC, subnet, firewall rules and a t2.micro EC2 instance with a public IP address
1. Install Docker engine and docker-compose
1. Register the Public IP address of the EC2 instance with DuckDNS.
1. Run nginx and grocy as docker containers provided by the [grocy-docker](https://github.com/grocy/grocy-docker) project
1. Generate free SSL certificates using LetsEncrypt and install it. Also does auto renewal. 

## Backups

* In order to do scheduled backups to dropbox, you have to pre-configure the dropbox cli (dbxcli) prior to running the `terraform apply` command. And uncomment the `"sudo ./schedule-backup.sh"` line in the servers.tf file before running `terraform plan`.
* Backups will be taken once a day
* Backups will be stored in directory called grocy_backup on Dropbox

## Restoring from Backups
* There is a script `restore-from-backup.sh` that can restore the latest backup from dropbox. This has not been tested much, so use with care!
## Developing

TODO

## Configuration

To change the default behaviour, modify the variables.tf file.

## Contributing

If you'd like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome.

## Links

- grocy (ERP for your fridge) : https://grocy.info
- Projects that helped and inspire this project:
  - nginx-certbot: https://github.com/wmnnd/nginx-certbot
  - grocy-docker: https://github.com/grocy/grocy-docker
  - install-docker.sh gist: https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b
  
- Repository: https://github.com/abhinavrau/cloud-grocy/
- Issue tracker: https://github.com/abhinavrau/cloud-grocy/issues

  - In case of sensitive bugs like security vulnerabilities, please contact
    abhinav dot rau @ gmail directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!


## Licensing
The code in this project is licensed under MIT license.
