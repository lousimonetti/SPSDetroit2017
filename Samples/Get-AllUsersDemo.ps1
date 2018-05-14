
Import-Module Azure

# This is the ID of your Tenant. You may replace the value with your Tenant Domain
$Global:tenantId = "common"

# You can add or change filters here
$MSGraphURI = "https://graph.microsoft.com/";

# 

#### DO NOT MODIFY BELOW LINES ####
###################################
Function Get-Headers {
    param( $token )

    Return @{
        "Authorization" = ("Bearer {0}" -f $token);
        "Content-Type" = "application/json";
    }
}

#builds the token.
Function Get-AzureAccessToken
{
    $clientId = "1950a258-227b-4e31-a9cf-717495945fc2" # PowerShell clientId
    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    $MSGraphURI = "https://graph.microsoft.com"
    
    $authority = "https://login.microsoftonline.com/$($Global:tenantId)"
    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
    $authResult = $authContext.AcquireToken($MSGraphURI, $clientId, $redirectUri, "Always")
    $token = $authResult.AccessToken
    return $token;
}

# Call Microsoft Graph
$token = Get-AzureAccessToken;
$headers = Get-Headers($token)


if ($token -eq $null) {
    Write-Output "ERROR: Failed to get an Access Token"
    exit
}

# gets all users
Function Get-AllUsers{
    param(
        # Filter Enabled Users only
        [Parameter(Mandatory=$false,
                   Position=0,
                   ParameterSetName="Graph",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Filter Enabled Users only")]
        [bool]
        $EnabledOnly
    )

    # only get users whose accounts are currently enabled in Azure AD. 
    if($EnabledOnly) {
        $usersV1 = invoke-restmethod -Method get -Uri "$($MSGraphURI)/v1.0/users?`$filter=accountEnabled eq true" -Headers $headers
        #$usersBeta = invoke-restmethod -Method get -Uri "$($MSGraphURI)/beta/users" -Headers $headers  
    }
    else{
        $usersV1 = invoke-restmethod -Method get -Uri "$($MSGraphURI)/v1.0/users" -Headers $headers
    }

    $allUsers = @();
    $allUsers = $usersV1.value;
    Do{
        $curr = Invoke-RestMethod -Method get -Uri $usersV1.'@odata.nextLink' -Headers $headers
        $allUsers += $curr.value;
        $usersv1 = $curr;            

    }while($usersV1.'@odata.nextLink');
    return $allUsers;
}


Function Get-MyPrivilegedRoles{

    # playing with PIM - will do more later. 

    
    $a = Invoke-RestMethod -Method Get -Uri "$($MSGraphURI)/beta/privilegedRoleAssignments/my" -Headers $headers
    
    $rs= @();
    $rd  =@();
    $a.value | %{ 
        $value = $_;
        $b = Invoke-RestMethod -Method Get -Uri "$($MSGraphURI)/beta/privilegedRoleAssignments/$($value.id)" -Headers $headers
        $C = Invoke-RestMethod -Method Get -Uri "$($MSGraphURI)/beta/privilegedRoleAssignments/$($value.id)/roleInfo" -Headers $headers
        $rs +=$b
        $rd += $c
        
    }

}

$users = Get-AllUsers -EnabledOnly $true
