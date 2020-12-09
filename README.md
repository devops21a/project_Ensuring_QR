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
        ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/terra_apply.png)
        
The YAML-file of the pipeline is in my repo __my_azure_pipelines.yml__ ..

  **2. Execution of the tests duites**
    The tests suites will be executed to the Azure Devops, CI/CD pipeline.
   - **1. Using Postman**
     * After installing Postman. You can use the __StarterAPIs.json__ under __postman__-folder in my repo as reference to make a collection and add a CRUD-requests. CRUD (create, read, update and delete), it's a operations done in a data repository (just database and records). 
     * Create a data validation and a regression test suite and publish the results to Azure Pipelines:
       * Export your collection and eventually the environment variables (if your collection uses it) from Postman. My collection (__StarterAPIs.postman_collection.json__ and __StarterAPIs2.postman_collection.json__) and my environment (__Walkthrough_StarterAPIs.postman_environment.json__) are under __postman__-folder.
       
         __StarterAPIs.postman_collection.json__ for ````Get All Employees````, ````Get Employee```` and ````Create Employee```` .
         __StarterAPIs2.postman_collection.json__ for ````Put Employee```` and ````Delete Employee```` .
        
         I had to split the collection in two sub-collections because my Pipeline crashed when I run all together (has a poor network)
    
     * Now, back to your DevOps project to create a pipeline:
       * You create your pipeline like I did previously when I create a pipeline for Terraform. Except that you have to __Add__ a two __command line__ tasks.
         * First task to instal __Newman__ . Newman is a command-line collection runner for Postman, and its help you to test Postman collection directly form the command-line.
         To install Newman, put in the script: ````sudo npm install -g newman````
         * Second task to run the collection:
         In the script: ````newman run StarterAPIs.postman_collection.json -e Walkthrough_StarterAPIs.postman_environment.json --reporters cli,junit --reporter-junit-export result.xml```` . In the command, you are using ````--reporters cli,junit```` means you are specifying the output both as junit and as comman-line interface.
         * Add an __Artifact__ and a __Publish Test Results__ to publish the results.
         * Run your pipeline and after a success, you will find the __result.xml__ under the Artifacts. See my __result.xml__ and __result2.xml__ under postman-folder. Under __Publish Test Results__ there is a link (__Published Test Run__) to see the result usinf JUnit.
         * After testting: __StarterAPIs.postman_collection.json__ , I get these results:
          ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/postman_startapis.png)
          and:
          ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/postman_startapis_chart.png)
          and test results:
          ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/postman_startapis_testResults.png)
         *  testting: __StarterAPIs2.postman_collection.json__ :
          ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/postman_startapis2.png)
          and:
          ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/postman_startapis2_chart.png)
          and the test results:
          ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/postman_startapis2_testResults.png)
          
          The YAML-files for the two sub-collection are in postman-folder.
          
   - **2. Test suite for JMeter**
     * Now, you write a test collection that will run against the AppService you have deployed through terraform. In my case the AppService is __Web-app-proj-QR__
       * Once the VM is deployed through terraform (like you did in the beginning), you need to deploy the fakerestapi to that VM. See the ````deployment: FakeRestAPI```` and task ````AzureWebApp@1```` in ````azure-pipelines.yaml````. The fakerestapi contains a web API, with REST endpoints for managing Activities (GET All Activities, Get Activity by ID, POST Activity, PUT Activity).
       * After running the pipeline (see ````azure-pipelines.yaml````) you should get this:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/deploying_fakerestapi.png)
       
       and your app-service should look like this:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/fakeretapi_appservice.png)
       
       and you can browse all the REST endpoints available in the fakerestapi by visiting your App Service URL on the browser
       
       * Now it is time to add a post-deployment task to your Pipeline that utilizes JMeter to load test to the various API endpoints (eg. /api/Activities). But before that, you have to understand which type of tests. It will be:
         * Stress test: many users (30 users) over short period of time (3 seconds) 
         * Endurance test: constant load over a long period of time (60 seconds)
       * Like you did it before, the pipeline to run JMeter contains in addition to the agent, add the __JMeter tool installer__ after you have instlled the JMeter extension. Name will be "Install JMeter 5.3", the version "5.3". After that add a __command-line__ to run the script:
       ````jmeter -n -t Stress_test.jmx -l result_stress.csv -e -o StressResults```` . 
       
       The **Starter.jmx** file will be generated using the starterAPIs using variables in JMeter GUI.
       Under JMeter-folder you can find the tests, the html-reports and the YAML-file for the stress test. It's the same for the endurannce test, just change the           ````Stress_test.jmx````in the script to the ````Endurance_test.jmx````.
       
       After running the pipeline, you should get this:
       Running Stress test (same for endurance test):
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/jmeter_stress.png)
       
       JMeterstress result:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/jmeter_stress_result.png)
       
       JMeter endurance result:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/jmeter_endurance_result.png)
       
   - **3. Selenium**
     * Create a functional UI test suite that adds all products to a cart and then removes them (https://www.saucedemo.com/). And youu have to include ````print()```` commands through the test so the actions of the testscan be determined. In additional to this, you must show the user name if the logging was successful.
     See the file **login.py** under __selenium__-folder.
     ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/logging_successful.png)
     
     * After that you need to configure the VM deployment:
       * The VM can be added as resource within environment.
       * [Follow the instructions to create an environment in Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/deploy-linux-vm?view=azure-devops&tabs=java)
       * If the registration script shows ````sudo: ./svc.sh: command not found````:
           ````sudo bin/installdependencies.sh````
               ````cd ..````
           ````sudo rm -rf azagent````
       * Run the registration script again.
       * After you have successfully completed all the steps, Update azure-pipelines.yaml with the Environment, and run the pipeline. You can now deploy to the Linux VM. See              ````deployment: VMDeploy```` in **azure-pipelines.yaml**.
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/vmdeploy_response.png)
       
       * After you are done with running all the below mentioned commands in your VM, you need to publish and consume files in pipeline to perform any action on the file.
         See `````task: PublishBuildArtifacts@1```` under `````job: Build```` in **azure-pipelines.yaml**
       * When you are done, connect to your VM ````ssh -i path/to/your/id_rsa admin_user@VM-public-ip-addr```` and run your test suite ````login.py````.
         
         You sholud get the log-file and the messages, like this:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/selenium_test.png)
       
       * And The execution of the test suite by the CI/CD pipeline:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/selenium_test2.png)
       
   - **4. Alert**  
      * you will configure an alert on an Azure AppService. You’ll send some requests to cause the AppService to error, and trigger your alert.
       * Go to your appService in Micorsoft Azure, then look for **Monitoring** in the menu on the left hand side, then **Alerts**, click this.
       * Then make a **new Alert Rule**, check the resource first, then add a **Condition** and choose **HTTP 404**.
       * Set the threshold value to **1**, means whenever you got two HTTP 404 errors, the alert will trigger, then click **done**
       * Now create a new **Action Group** and call it for **email** (means, people who are interested in the alert). Then the **Action name** as HTTP 404 and the **Action Type** to **Email/SMS/Push/Voice** . Then tape your email, clico on ok and ok again.
       * so your alert rule name **HTTP 404 grather than 1**, **severity** to 1.
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/alert_rule.png)
       * Back to your web browser, and create a few errors by givivng the URL of your AppService, and typing ````/feff````or some other random characters
       * And You should get an email (the alert will be triggered), like this:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/received_email_triggered_alert.png)
       
       Metrics:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/metric.png)
       
       Graphs of resource:
       ![alt text](https://github.com/devops21a/project_Ensuring_QR/blob/main/screenshots/graphs_of_resource.png)
  
  
## Output 
See the images


## References:
 * https://azuredevopslabs.com/labs/vstsextend/terraform/ 
 * https://gmusumeci.medium.com/deploying-terraform-infrastructure-using-azure-devops-pipelines-step-by-step-d58b68fc666d
 * https://www.geeksforgeeks.org/logging-in-python/
 * https://linuxhint.com/chrome_selenium_headless_running/
 * https://medium.com/@ganeshsirsi/how-to-configure-postman-newman-api-tests-in-azure-devops-or-tfs-and-publish-html-results-caf60a25c8b9
 * https://learning.postman.com/docs/running-collections/using-newman-cli/command-line-integration-with-newman/
 * https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys
 
       
