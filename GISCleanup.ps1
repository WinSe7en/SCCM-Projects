Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1' # Import the ConfigurationManager.psd1 module 
Set-Location 'DU1:' # Set the current location to be the site code.

$SiteServer = 'sccm-fs.du.edu'
$SiteCode = 'DU1' 
$CollectionName = 'Non-Persistent VDI'
#$cred = Get-credential 
#Retrieve SCCM collection by name 
$Collection = get-wmiobject -ComputerName $siteServer -NameSpace "ROOT\SMS\site_$SiteCode" -Class SMS_Collection -Credential $cred  | where {$_.Name -eq "$CollectionName"} 
#Retrieve members of collection 
$SMSMemebers = Get-WmiObject -ComputerName $SiteServer -Credential $cred -Namespace  "ROOT\SMS\site_$SiteCode" -Query "SELECT resourceid FROM SMS_FullCollectionMembership WHERE CollectionID='$($Collection.CollectionID)'" | select resourceid

write "There are " $SMSMemebers.Count "objects to delete"
foreach ($SMSMember in $SMSMemebers) {
    Remove-CMResource -ResourceID $SMSMember.resourceid -Force -Verbose
  }