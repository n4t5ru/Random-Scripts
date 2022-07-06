<#
    Author:         n4t5ru
    Email:          hello@nasru.me
    Version:        2.0
    Created:        20/06/2022
    ScriptName:     AddUserToAD
    Description:    Adds user to Local AD and Azure AD using the user input details
#> 

<#
Note:
You will need the following modules to be installed before you can run the AzureAD function
    Microsoft Graph
    AzureAD

You can install the modules using the following commands (Documentation Links provided):
    'Install-Module AzureAD'            https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0
    'Install-Module Microsoft.Graph'    https://docs.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0
#>

#Notice for user regarding the Usernames
Write-Host "Important Notice. Please note that Username Will be created using the values entered as follows: " -ForegroundColor Red
Write-Host "Username will be stored as {FIRSTNAME.LASTNAME} This will be used by the Staff to login." -ForegroundColor Red

Start-Sleep -s 3

#Admin inputs required for the user details
$firstname = Read-Host -Prompt "Enter First name: "
$lastname = Read-Host -Prompt "Enter Last Name: "
$initials = Read-Host -Prompt "Does user have Initials / Middle Name [Y or N]"

#Checks if the user has a middle name / initials
if ($initials -eq "Y"){
    $middlename = Read-Host -Prompt "Enter Middle Name: "
}

#Admin inputs for the extra details of the user
$department = Read-Host -Prompt "Enter Department"
$mobile = Read-Host -Prompt "Mobile Number: "
$designation = Read-Host -Prompt "Enter Designation: "

#Variables that need to be merged or needs extra static parameters
$username = $firstname+'.'+$lastname
$displayname = '"'+$firstname+' '+$lastname+'"'
$emailname = $username+'@sdfc.mv'
$companyname = "SDFC"

# Option to add user to Inhouse AD, AzureAD or Both
$addTo = Read-Host -Prompt "Add User to [I] - InhouseAD [A] - AzureAD [B] - Both: "

if ($addTo -eq 'I'){
    Add-UserToAD
}
if ($addTo -eq 'A'){
    Add-UserToAzure
}
if ($addTo -eq 'B') {
    Add-UserToAD
    Add-UserToAzure
}

#Function which adds the user to normal/inhouse hosted Active directory
function Add-UserToAD {

    if ($initials -eq "Y"){
        New-ADUser -Name $displayname `
            -AccountPassword (Read-Host -AsSecureString "AccountPassword") `
            -Givenname $firstname `
            -Initials $middlename `
            -Surname $lastname `
            -Title $designation `
            -EmailAddress $emailname `
            -Department $department `
            -SamAccountName $username `
            -UserPrincipalName $username `
            -Path "DC=SDFC DC=lan" `
            -ChangePasswordAtLogon $true `
            -Enabled $true
    }
    else {
        New-ADUser -Name $displayname `
            -AccountPassword (Read-Host -AsSecureString "AccountPassword") `
            -Givenname $firstname `
            -Surname $lastname `
            -Title $designation `
            -EmailAddress $emailname `
            -Department $department `
            -SamAccountName $username `
            -UserPrincipalName $username `
            -Path "DC=SDFC DC=lan" `
            -ChangePasswordAtLogon $true `
            -Enabled $true
    }
}

#Function which adds the user to Azure AD
function Add-UserToAzure{
    
    #Will automatically progress if an administrator is logged in
    $credentials = Get-Credential

    Connect-AzureAD -Credential $credentials

    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = "Welcome123"
    $PasswordProfile.ForceChangePasswordNextLogin

    New-AzureADUser -DisplayName $displayname `
        -GivenName $firstname `
        -Surname $lastname `
        -JobTitle $designation `
        -Department $department `
        -Mobile $mobile `
        -CompanyName $companyname `
        -PasswordProfile $PasswordProfile `
        -UserPrincipalName $emailname `
        -AccountEnabled $true `
        -MailNickName $username

    Connect-MgGraph -Credential $credentials

    Set-AzureADUserLicense -ObjectId $emailname `
        -AssignedLicenses 'O365_BUSINESS_PREMIUM'
}