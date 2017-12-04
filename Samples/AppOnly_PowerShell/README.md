# Authenticating App-Only Token in PowerShell

## Samples for SharePoint Saturday Detroit 2017

## Register the application

1. Sign into the [Application Registration Portal](https://apps.dev.microsoft.com/) using either your personal or work or school account.
2. Choose **Add an app**.
3. Enter a name for the app, and choose **Create application**. 
   The registration page displays, listing the properties of your app.
4. Copy the Application Id. This is the unique identifier for your app. 
5. Under **Application Secrets**, choose **Generate New Password**. Copy the password from the **New password generated** dialog.
   You'll use the application ID and password (secret) to configure the sample app in the next section. 
6. Add the **Sites.Read.All** under the **Application Permissions** in the **Microsoft Graph Permissions** section.
7. Under **Platforms**, choose **Add Platform**.
8. Choose **Web**.
9. Make sure the **Allow Implicit Flow** check box is selected, and enter *http://localhost:4200/* as the Redirect URI. 
   The **Allow Implicit Flow** option enables the hybrid flow. During authentication, this enables the app to receive both sign-in info (the id_token) and artifacts (in this case, an authorization code) that the app can use to obtain an access token.
10. Choose **Save**.

## How to run this sample

1. Download or clone this repository

2. Open the **demo.ps1** in **PowerShell ISE** or **Visual Studio Code**.

3. Replace the **$clientId**, **$secret**, and **$tenantId** placeholder values with the application ID, password, and your you copied during app registration.

4. Since this will require Admin Consent, in your web browser, as the admin account, go to https://login.microsoftonline.com/common/adminconsent?client_id=$($clientId)&state=demo&redirect_uri=$($redirecturi)  *replace the  **redirecturi** and **clientId** with the values for the app.* Once signed in, click **Accept** button to *authorize* the application.

5. Press F5 to run the sample.
