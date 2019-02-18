##Introduction

This is a sample .Net application that demonstrates how a single configuration can be used for deployment in multiple environments.

The application configuration is tokenized with the help of a PowerShell script in the build pipeline with the help of an XML file which stores the XPATH of config elements that need to replaced by a specific token. The output of build is a tokenized configuration, which has "tokens" instead of real values that vary for each environment. These tokens are replaced back with real values for specific environment during release pipeline using standard Replace Tokens task (https://marketplace.visualstudio.com/items?itemName=qetza.replacetokens)


#Build Pipeline:

Standard AzureDevOps build pipeline with following essential steps
1. Nuget Restore
2. Tokenize Config - Powershell from Scripts/tokenize.ps1
3. Build Solution **\*.sln
4. Publish Artifacts.

Source control includes two configuration files (1) Standard .Net application configuration (2) Parameters.xml. The later file stores references of locations/elements in application config that need to be replaced with a token so that later they can be replaced with different values for different environment. The reference of location/element/attribute is expressed in terms of simple XPATH expressions.

This approach allows developers to keep application configuration as they need it to run the application on their development environment, while it also provides tools to define which parts of the configuration will vary for different environment.

For example when a developer needs to add a new AppSetting key-value in the config that is supposed to have different value for Dev, QA and Production environments, she can keep the app.config specific to Dev environment where she frequently needs to run the application. She needs to define a new element in Parameters.xml with XPATH of this appsetting element, 'value' attribute and the token literal that need to replace to value of attribute on the build server.

#Release Pipeline:

Stanadard AzureDevOps Release pipeline with following essential steps
1. Create Azure App Service (Azure Resource Group Deployment)
2. Replace Tokens in **\*.config
3. Deploy Application (Azure App Service Deploy)

The release pipeline also defines variables (tokens) in form of key-value pairs. The Replace Tokens task reads these variables, matches them with tokens in the application config files and replaces them with corresponding value defined for the environment.
