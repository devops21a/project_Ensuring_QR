# project_Ensuring Quality Releases [![Build Status](https://dev.azure.com/devops21a/proj-ensuring-QR/_apis/build/status/proj-ensuring-QR-CI?branchName=main)](https://dev.azure.com/devops21a/proj-ensuring-QR/_build/latest?definitionId=8&branchName=main)
Udacity project to ensure the quality releases 

## Introduction
In this project, you will create an environment, delivery of a software, the automated testing of the software and the performance monitoring of the environment under different conditions.

## Getting Started
Befor you even get ready to build the code:
1. Be familiar with these tools:
   * Azure DevOps
   * Selenium
   * Terraform
   * JMeter
   * Postman
2. Create a GitHub repository
3. Create a disposable Outlook account
4. Create a free Azure Account
5. Install Azure CLI or use cloud shell
6. Use your favorite IDE or a text editor
7. Make a plan
8. Read the project several times

## Dependencies
To do before you run the code:

1. Install Terraform
2. Install JMeter
3. Install Postman
4. Install Python
5. Install Selenium

## Instructions
After you have collected your dependencies, the first thing you will do is to start with Terraform.

  **1. Terraform**
  
  - After creation of the GitHub repository, you have to add an SSH key (with SSH key, no more supplying username and personal access token to each visit) to connect to it. 
    - using: ````ssh-keygen -t rsa -b 4096 -C your-email-address ````
    - copy the key and into your GItHub, make a new SSH key
    - so ````git clone````
  - Create a resource group: ````az group create --location your-location --name nameoftheresourcegroup````
  - Run the shell-script: ````configure_storage_account.sh```` from your command line. Use the project group created before.
  - To list the account access keys (````access_key````), run:
  
    ````az storage account keys list --resource-group nameoftheresourcegroup --account-name nameofthestorageaccount````
  - Create a Service principal and the client secret for Terraform, run:
  
    ````az adsp create-for-rbac --role="Contributor" --scopes="/subscriptions/your-subscription-ID"````
  - Create a __terraform__ folder and inside another folder named __environments__, to store the different configurations of modules according to the environments you use.
  - Create another folder __project__ as a subfolder to environments to stimulate a type of environment.
     See the directory tree:
    ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/terraform_tree.png)
