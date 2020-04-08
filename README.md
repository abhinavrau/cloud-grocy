![Logo of the project](images/cloud-grocy-logo.png)

# cloud-grocy
> Get your [grocy](https://grocy.info) server running securely in the cloud!

Opinionated script to deploy and run [grocy](https://grocy.info) on AWS (for free/low cost)

## Features

* Deploys to AWS EC2 t2.micro instance (free tier).
* Change default admin password to a more secure one.
* Assign public IP address on port 80 and 443.
* Enable only HTTPS access.

Optional but highly recommended features:

* Register host with with DNS provider if top level domain is registered with Route53 on the same AWS account.
* Providing the top level domain name will also generate LetsEncrypt certificate for the domain so you don't see "This website is not secure" warnings.
* Backup grocy database and other context to DropBox daily (because sh*t happens). Dropbox account required.



## Installing / Getting started

Prerequisites:
1. Install aws cli authenticated to an AWS account.
2. Install terraform

```shell
git clone https://github.com/abhinavrau/cloud-grocy/
terraform init
terraform plan 
```

At this step, you will be prompted to enter a top level domain name that is registered with Route53. 
Can leave empty if you don't have a domain name registered with Route53.

```shell 
terraform apply "plan"
```

This will do the following:

1. Create a VPC, subnet, firewall rules and a t2.micro EC2 instance with a public IP address
2. Install Docker engine and docker-compose
3. Run grocy as docker containers
4. Register the host in DNS e.g. grocy.mydomain.com ( if mydomain.com is the top level domain that was entered and registered with Route53 ) 

#Backup grocy database and deploy folder to Dropbox

If you want to automatically backup 
* It will automatically register to do backups to dropbox if you have configured the dropbox cli (dbxcli) to be registered with your dropbox account.
* Backups will be taken once a day
* Backups will be stored in directory called cloud-grocy-backup on Dropbox

 


### Initial Configuration


## Developing

Here's a brief intro about what a developer must do in order to start developing
the project further:

```shell
git clone https://github.com/your/awesome-project.git
cd awesome-project/
```


## Configuration

To change the default behaviour, modify the variables.tf file. The configurable parameteres are:


#### AWS Region

Example:
```bash
awesome-project "Some other value"  # Prints "You're nailing this readme!"
```

#### Argument 2
Type: `Number|Boolean`  
Default: 100

Copy-paste as many of these as you need.

## Contributing

If you'd like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome.

## Links

- grocy (ERP for your fridge) : https://grocy.info
- Related projects:
  - nginx-certbot: https://github.com/wmnnd/nginx-certbot
  - grocy-docker: https://github.com/grocy/grocy-docker
  - install-docker.sh gist: https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b
  
- Repository: https://github.com/abhinavrau/cloud-grocy/
- Issue tracker: https://github.com/abhinavrau/cloud-grocy/issues
  - In case of sensitive bugs like security vulnerabilities, please contact
    abhinav dot rau @ gmail directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!
- Related projects:
  - nginx-certbot: https://github.com/wmnnd/nginx-certbot
  - grocy-docker: https://github.com/grocy/grocy-docker
  - install-docker.sh gist: https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b
  

## Licensing
The code in this project is licensed under MIT license.
