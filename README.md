![Logo of the project](images/cloud-grocy-logo.png)

# cloud-grocy
> Get your [grocy](https://grocy.info) server running securely in the cloud!

Opinionated script to deploy and run [grocy](https://grocy.info) on AWS (for free/low cost)

## Features

* Deploys to AWS EC2 t2.micro instance (free tier).
* Assign public IP address on port 80 and 443.
* Enable only HTTPS access with LetsEncrypt Certificates.
* Register host with with DNS provider if top level domain is registered with Route53 on the same AWS account.
* Backup grocy database and other context to DropBox daily (because sh*t happens). Dropbox account required to enable backups.

## Installing / Getting started

Prerequisites:
1. Install aws cli authenticated to an AWS account.
2. Install terraform

```shell
git clone https://github.com/abhinavrau/cloud-grocy/
cd cloud-grocy/aws
terraform init
terraform plan 
```

At this step, you will be prompted to enter a top level domain name that is registered with Route53. 

```shell 
terraform apply "plan"
```

This will do the following:

1. Create a VPC, subnet, firewall rules and a t2.micro EC2 instance with a public IP address
2. Install Docker engine and docker-compose
3. Run nginx and grocy as docker containers provided by the [grocy-docker](https://github.com/grocy/grocy-docker) project
4. Register the host in DNS e.g. grocy.mydomain.com ( if mydomain.com is the top level domain that was entered and registered with Route53 ) 

## Backups

* In order to do scheduled backups to dropbox, you have to pre-configure the dropbox cli (dbxcli) prior to running the `terraform apply` command.
* Backups will be taken once a day
* Backups will be stored in directory called grocy_backup on Dropbox


## Developing

TODO

## Configuration

To change the default behaviour, modify the variables.tf file.


## Contributing

If you'd like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome.

## Links

- grocy (ERP for your fridge) : https://grocy.info
- Projects that this project relies on:
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
