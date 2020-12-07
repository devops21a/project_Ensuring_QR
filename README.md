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
    
  - Deploying Terraform Infrastructure (Terraform resources) using Azure DevOps Pipelines:
    - Log in to your DevOps account and create a new project.
    - Initialize the Azure DevOps Repo to build the pipeline by __import a repository__ under __Repos__
    - Create a new Azure DevOps Build Pipeline
      - Click on Pipelines/pipelines on the left, then __Create Pipeline__. Select __Use the classic editor__
      - Then select the __Azure Repos Git__ option and select your project, repo and the branch, so __continue__
      - In __Select a template__, click on __Empty job__
      - Then click the plus sign (+) and add the __copy files__ task. Set the target folder as __$(build.artifactstagingdirectory)/Terraform__ and the display name as __Copy     Files__
      - Add another job with type __Publish Build Artifacts__ with defaults parameters
      - Now in the __Triggers__ tab, check __Enable continuous integration__ checkbox, and click on __Save & queue__, the __Save and run__. The pipeline is launched, and the status should be __Success__
 - Create an Azure DevOps Release Pipeline using the artifact generate on the build pipeline and a Stage task with these tasks:
   - Terraform installer
   - Terraform CLI (init, validate, plan and apply)
      - Adding the tasks:
        - First __Add an agent job__ (click on the 3 dots on the Build pipeline), so create a Stage task, add tasks to the agent job (search for Terraform). First task goes to “Terraform Installer”, click on __Add__ and it’s the same steps for the other tasks (Remember, to configure Terraform directory in Configuration Directory and the Backend Type), then Save the build pipeline.
        - On the __Pipeline__ menu, then __Release__ option. Click on the __New Pipeline__. In the __Select a template__, choose an __Empty job__ template.
        - Now click on __Add an Artifact__ button. In the page of __Add an artifact__, choose the __Build__ as __Source type__ to use the build pipeline created previously
        - Click on __Add__, then on __the lightning icon__ and enable the __CD trigger__. Rename the pipeline “azure-pipeline-release”, __Save__, then __OK__
        - Next is to configure the Stage, click on __Stage 1__ button to rename it to “Terraform”. Then click on __1job, 0 task__ link to configure the tasks. Click on the Agent job (+) sign and Add these tasks:
          - Terraform Installer
          - Terraform Init. In Terraform Init, set the __Backend Type__ to __self-configured__ (configured when you run ````configure_storage_account.sh````)
          - Terraform validate
          - Terraform plan
          - Terraform apply
          - In Terraform plan and apply, set the Environment Azure Subscription to your Subscription.
        - Click on __Save__, then on __Create release__, and it should show __Terraform Succeeded__ . Means that the resources I need it for the project is created, like the VM and the AppService.
        
        As shown above:
        ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/release_pipeline_succeeded.png)
        ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/deployment_succeeded.png)
        ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/pipeline_deployments.png)
        
The YAML-file of the pipeline is in my repo __my_azure_pipelines.yml__ .

  **2. Execution of the tests duites**
    The tests suites will be executed to the Azure Devops, CI/CD pipeline.
   - **1. Using Postman**
     * After installing Postman. You can use the __StarterAPIs.json__ under __postman__-folder in my repo as reference to make a collection and add a CRUD-requests. CRUD (create, read, update and delete), it's a operations done in a data repository (just database and records). 
     * Create a data validation and a regression test suite and publish the results to Azure Pipelines:
       * Export your collection and eventually the environment variables (if your collection uses it) from Postman. My collection (__StarterAPIs.postman_collection.json__ and __StarterAPIs2.postman_collection.json) and my environment (__Walkthrough_StarterAPIs.postman_environment.json__) are under __postman__-folder.
       __StarterAPIs.postman_collection.json__ for `````Get All Employees````, ````Get Employee```` and ````Create Employee````     
    
     * Now, back to your DevOps project to create a pipeline:
       * You create your pipeline like I did previously when I create a pipeline for Terraform. Except that you have to __Add__ a two __command line__ tasks.
         * First task to instal __Newman__ . Newman is a command-line collection runner for Postman, and its help you to test Postman collection directly form the command-line.
         To install Newman, put in the script: ````sudo npm install -g newman````
         * Second task to run the collection:
         In the script: ````newman run StarterAPIs.postman_collection.json -e Walkthrough_StarterAPIs.postman_environment.json --reporters cli,junit --reporter-junit-export result.xml```` . In the command, you are using ````--reporters cli,junit```` means you are specifying the output both as junit and as comman-line interface.
         * Add an __Artifact__ and a __Publish Test Results__ to publish the results.
         * Run your pipeline and after a success, you will find the __result.xml__ under the Artifacts. See my __result.xml__ under postman-folder. Under __Publish Test Results__ there is a link
         
         
