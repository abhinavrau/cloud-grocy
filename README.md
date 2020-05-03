![Logo of the project](images/cloud-grocy-logo.png)

# cloud-grocy
> Get your [grocy](https://grocy.info) server running securely in the cloud for free!

Opinionated script to deploy and run [grocy](https://grocy.info) (ERP beyond your fridge) on AWS secured with TLS  with automated backups.

## Features
* Installs and runs [grocy](https://grocy.info) server and [barcode buddy](https://github.com/Forceu/barcodebuddy) on a single AWS EC2 t2.micro instance (free tier i.e. free for one year with a new AWS account).
* Enable HTTPS only access with free [LetsEncrypt](https://letsencrypt.org/) Certificates with auto renewal.
* Register host with DNS. Supports [DuckDNS](https://duckdns.org), a free DNS provider
* Backup grocy database to DropBox daily (because sh*t happens). I chose Dropbox since it is free, versions files and has a easy to use tools.


## Why?

- Cloud based makes it accessible without worrying about home router firewalls and babysitting a server.
- Sleep easy knowing backups are also happening.
- Upgrades are relatively painless.
- If something goes bad, just delete the server and recreate it!
- Learn something new.
 
## Installing / Getting started

### Prerequisites:
* Git cli
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and authenticated to an AWS account with the right permissions to create EC2 instances. [Video Tutorial](https://www.youtube.com/watch?v=FOK5BPy30HQ)
* [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html) installed
* Registered [DuckDNS](htts://duckdns.org) domain names for grocy and barcode buddy. [DuckDNS](https://duckdns.org) is a free service that allows creation of a domain names for free in the duckdns.org top level domain. Use it to register domains for our servers. It will generate a token which you will need for installation.
* Dropbox account required to enable backups. It is recommended to use a separate dropbox account (i.e. not your personal account) to store the backup, since dropbox credentials are copied to the AWS EC2 instance. 

### Preparing
Run the following commands from a command prompt. 

```shell
git clone https://github.com/abhinavrau/cloud-grocy.git
cd cloud-grocy/aws
terraform init
terraform plan -out=plan
```

At this step, you will be prompted to enter:

* Domain name for the grocy site you want (without the duckdns.org suffix) that you registered with [DuckDNS](htts://duckdns.org). 
* Domain name for the barcode buddy site (without the duckdns.org suffix) that you registered with [DuckDNS](htts://duckdns.org). 
* DuckDNS token for your domain created in the previous step.  

### Install!

```shell 
terraform apply "plan"
```

This will do the following:

1. Create a VPC, subnet, firewall rules, and a t2.micro EC2 instance running Ubuntu 18.04 with a public IP address.
1. Install Docker and docker-compose.
1. Register the Public IP address of the EC2 instance with DuckDNS for both the domain names specified earlier.
1. Run [grocy](https://grocy.info) and [barcode buddy](https://barcodebuddy-documentation.readthedocs.io/en/latest/index.html) as docker containers.
1. Generate free TLS certificates using LetsEncrypt with auto renewal using  [docker-compose-letsencrypt-nginx-proxy-companion](https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion)

On completion, the script will output:
* The URL of the grocy server
* The URL of barcode buddy server
* The public IP address of the EC2 t2.micro instance running grocy and barcode buddy.
* The SSH private key for the EC2 t2.micro instance. 

Your Grocy server with barcode buddy on the cloud is ready! (It may a take a couple of minutes to register the LetsEncrypt certificates.)

**IMPORTANT:** 
- Navigate to the URLs and login and change the admin password!
- Please save the SSH Key private securely in a password manager. You will need it to take backups and restoring.
- Do not delete the terraform.state files that get created.  
 
## Backups

In order to do scheduled backups to dropbox, you have to:

* Pre-configure the [dropbox cli](https://github.com/dropbox/dbxcli) (dbxcli) prior to running the `terraform apply` command. 
* Uncomment the `"sudo ./schedule-backup.sh"` line in the [aws/servers.tf](aws/servers.tf) file before running `terraform plan`. Or Run the same command after installation finishes by [SSH into the server](#SSH-access).
* Backups will be taken once a day
* Backups will be stored in directory called grocy_backup on Dropbox

## Restoring from Backups

There is a script `restore-from-backup.sh` that can restore the latest backup from dropbox.

- Login to the AWS instance [using SSH](#SSH-access). From here run:
```shell 
./restore-from-backup.sh
```

## Upgrading 

To upgrade to a new cloud-grocy release:

### Take a backup of the current database

- [SSH to the server](#SSH-access)
- Take the backup to dropbox by running:

```shell 
./grocy-backup.sh
```

### Update your local copy of cloud-grocy
- From the base cloud-grocy directory run:

```shell 
git pull
```
### Upgrade by running terraform

```shell 
terraform plan -out=plan
terraform apply "plan"
```

**IMPORTANT:** This will destroy the old EC2 instance and create a new one with the updated servers, so it is important to take backup.

### Restore the backup
See  [Restoring from Backups](#Restoring-from-Backups) section mentioned previously. 

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

## SSH access

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

## Project Goals 

* Install and run grocy on the cloud with minimal effort.

* Low cost (Preferably free)

* Automated backups

* Secure

* Make grocy upgrades painless
    
## Contributing

If you'd like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome.

## Links

- grocy (ERP for your fridge) : https://grocy.info
- Projects that helped and inspire this project:
  - docker-compose-letsencrypt-nginx-proxy-companion: https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
  - grocy-docker: https://github.com/grocy/grocy-docker
  - barcode buddy: https://barcodebuddy-documentation.readthedocs.io/en/latest/index.html
  - install-docker.sh gist: https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b
  
- Repository: https://github.com/abhinavrau/cloud-grocy/
- Issue tracker: https://github.com/abhinavrau/cloud-grocy/issues

  - In case of sensitive bugs like security vulnerabilities, please contact
    abhinav dot rau @ gmail directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!


## Licensing
The code in this project is licensed under MIT license.
