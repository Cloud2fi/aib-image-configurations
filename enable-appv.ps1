# Enable App-V and set publishing server address
Import-Module -Name AppvClient -SkipEditionCheck
Enable-Appv
Add-AppvPublishingServer -Name 'appv5.sok.fi' -URL 'http://appv5.sok.fi'
