
## enter your Registered Application's ID, Secret, Redirect URL, and use your tneant ID in place of the COMMON. 
$clientId = 'f56826f7-40dd-4a5b-b7df-54f4ba271e5a';
$secret = 'egemORBN311%=omoDXV75|~';
$redirecturi = "http://localhost:4200";
$tenantId = '1f8ecb0c-9942-490f-8e72-ddead5d7d98e';
<#
# 
    $admin_consent_uri = 
    "https://login.microsoftonline.com/common/adminconsent?
        client_id=$($clientId)&state=demo
        &redirect_uri=$($redirecturi)";

1. 
GET 
    https://login.microsoftonline.com/{tenant}/adminconsent
    ?client_id=6731de76-14a6-49ae-97bc-6eba6914391e
    &state=12345
    &redirect_uri=http://localhost/myapp/permissions

2.
GET 
    http://localhost/myapp/permissions
    ?tenant=a8990e1f-ff32-408a-9f8e-78d3b9139b95&state=state=12345
    &admin_consent=True

3.
POST 
    /{tenant}/oauth2/v2.0/token HTTP/1.1
    Host: login.microsoftonline.com
    Content-Type: application/x-www-form-urlencoded

    client_id={CLIENT ID from the Applicaiton Registration}
    &scope=https%3A%2F%2Fgraph.microsoft.com%2F.default
    &client_secret=qWgdYAmab0YSkuL1qKv5bPX
    &grant_type=client_credentials
#>
<#
    @clientid = the client id for the registered application
    @secret =  the secret for the application
    @redirecturi = the redirect URI for the application
    @tenantId = The location of the registered Tenant ID (Common or name.onmicrosoft.com or GUID)
    #>

function Get-AccessToken(){
    [CmdletBinding(DefaultParameterSetName = "AppOnly")]
    param(
        [parameter(Position = 0,
            Mandatory = $true,
            ParameterSetName = "AppOnly")]
        [string]$clientId,

        [parameter(Position = 1,
            Mandatory = $true,
            ParameterSetName = "AppOnly")]
        [string]$secret,
 
        [parameter(Position = 2,
            ParameterSetName = "AppOnly",
            Mandatory = $true)]
        [string]$redirecturi,

        [parameter(Position = 3,
            ParameterSetName = "AppOnly",
            Mandatory = $false)]
        [string]$tenantId
    );

    $secretEncoded = [System.Web.HttpUtility]::UrlEncode($secret)
    $token_uri = "https://login.microsoftonline.com/$($tenantId)/oauth2/v2.0/token";
    $body = "client_id=$($clientId)&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&client_secret=$($secretencoded)&grant_type=client_credentials";

    $contentType=  "application/x-www-form-urlencoded";

    $token=  Invoke-RestMethod -method GET -Uri $token_uri -body $body -contenttype $contentType 
    return $token;
}

$token = Get-AccessToken -clientId $clientId -secret $secret -redirecturi $redirecturi -tenant $tenantId

$header = @{"Authorization" = "bearer $($token.access_token)"};
$SPUrlCall = "https://graph.microsoft.com/beta/sites";

$spr = invoke-restmethod -Method GET -headers $header -uri "$($SPUrlCall)/root";
$sites = invoke-restmethod -Method GET -headers $header -uri "$($SPUrlCall)?select=siteCollection,webUrl&filter=siteCollection/root%20ne%20null";

Write-Host "The Root Site Found is: "
$spr
Write-Host "--------------------------------"
Write-Host "All Sites found are: "
Write-Host "------------------------------------"
$sites.value