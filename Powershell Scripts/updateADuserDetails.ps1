<#
    Author:         n4t5ru
    Email:          hello@nasru.me
    Version:        1.0
    Created:        06/07/2022
    ScriptName:     updateADuserDetails
    Description:    Edit users by importing details from CSV
#> 

#Just Fancying things
Write-Host "This is a Normal Message: " -ForegroundColor Red

$staffs = Import-Csv -Path C:\staff_info_2.csv 
#| ft

foreach ($staffs in $staffs) {
    #required variables
    $user = $staffs.user
    $title = $staffs.title
    $department = $staffs.department
    $email = $staffs.email
    $mobile = $staffs.mobile

    Set-ADUser -Identity $user -Title $title -Department $department -EmailAddress $email -MobilePhone $mobile

    Write-Host "Reached: " $user
}