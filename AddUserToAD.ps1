<#
    Author:     n4t5ru
    Email:      hello@nasru.me
    Version:    1.0
    Created:    20/06/2022
#> 

#Notice for user regarding the Usernames
Write-Host "Important Notice. Please note that Username Will be created using the values entered as follows: " -ForegroundColor Green
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

#username is created as such
$username = $firstname+'.'+$lastname

#Admin inputs for the extra details of the user
$department = Read-Host -Prompt "Enter Department"
$email = Read-Host -Prompt "Enter Email Address: "
$designation = Read-Host -Prompt "Enter Designation: "

if ($initials -eq "Y"){
    New-ADUser -Name $username `
        -AccountPassword (Read-Host -AsSecureString "AccountPassword") `
        -Givenname $firstname `
        -Initials $middlename `
        -Surname $lastname `
        -Title $designation `
        -EmailAddress $email `
        -Department $department `
        -SamAccountName $username `
        -UserPrincipalName $username `
        -ChangePasswordAtLogon $true `
        -Enabled $true
}
else {
    New-ADUser -Name $username `
        -AccountPassword (Read-Host -AsSecureString "AccountPassword") `
        -Givenname $firstname `
        -Surname $lastname `
        -Title $designation `
        -EmailAddress $email `
        -Department $department `
        -SamAccountName $username `
        -UserPrincipalName $username `
        -ChangePasswordAtLogon $true `
        -Enabled $true
}