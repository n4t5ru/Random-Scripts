<#
    Original Author of this project is CaptainQwerty (Original GitHub Link: https://github.com/captainqwerty/AutomatedOutlookSignature)

    Modified By:
        Author:     n4t5ru
        Email:      hello@nasru.me
        Version:    1.0
        Modified:   30/5/2022
#> 

# Getting Active Directory information for current user
$user = (([adsisearcher]"(&(objectCategory=User)(samaccountname=$env:username))").FindOne().Properties)

# If the user is not found in Active Directory exit the script
if(!$user) {
  exit
}

# Create the signatures folder and sets the name of the signature file
$folderlocation = $Env:appdata + '\\Microsoft\\signatures'
$filename = "MainSignature"
$file  = "$folderLocation\\$filename"

# Removes any pre-existing signatures in the folder
Remove-Item $folderlocation\\*.*

# If the folder does not exist create it
if(!(Test-Path -Path $folderlocation )){
    New-Item -ItemType directory -Path $folderlocation
}

# Required fields from AD (DisplayName and Title)
if($user.name.count -gt 0){$displayName = $user.name[0]}
if($user.title.count -gt 0){$jobTitle = $user.title[0]}

# Checks if their is a telephone number assosiated with the AD User
if($user.homephone.count -gt 0){$telephone = $user.homephone[0]}
else{$telephone = '1613'}

# Checks if their is an email assosiated with the AD User
if($user.mail.count -gt 0){$email = $user.mail[0]}
else{$email = 'info@sdfc.mv'}

# Building HTML
$signature = 
@"
    Enter the desiered HTM template.
"@

# Save the HTML to the signature file
$signature | out-file "$file.htm" -encoding ascii

# Setting the regkeys for Outlook 2016
if (test-path "HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\General") 
{
    get-item -path HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\General | new-Itemproperty -name Signatures -value signatures -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\MailSettings | new-Itemproperty -name NewSignature -value $filename -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\16.0\\Common\\MailSettings | new-Itemproperty -name ReplySignature -value $filename -propertytype string -force
    Remove-ItemProperty -Path HKCU:\\Software\\Microsoft\\Office\\16.0\\Outlook\\Setup -Name "First-Run" -ErrorAction silentlycontinue
}

# Setting the regkeys for Outlook 2010 - Thank you AJWhite1970 for the 2010 registry keys
if (test-path "HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\General") 
{
    get-item -path HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\ General | new-Itemproperty -name Signatures -value signatures -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\ MailSettings | new-Itemproperty -name NewSignature -value $filename -propertytype string -force
    get-item -path HKCU:\\Software\\Microsoft\\Office\\14.0\\Common\\ MailSettings | new-Itemproperty -name ReplySignature -value $filename -propertytype string -force
    Remove-ItemProperty -Path HKCU:\\Software\\Microsoft\\Office\\14.0\\Outlook\\Setup -Name "First-Run" -ErrorAction silentlycontinue
}
