    param(
        [Parameter(Mandatory=$true)][string]$Application_Key = $( Read-Host "Application Key, please"), 
        [Parameter(Mandatory=$true)][string]$Application_Secret = $( Read-Host "Application Secret, please")
    )

###########################################################################

    function Install_ovh_api{
        $url = "https://www.github.com/ghoz/ps-ovhapi/archive/master.zip"
        $output = "ps-ovhapi.zip"
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $output
        $ovh_apiPath = "$pwd\$output"
        $ovh_apiPath
        expand-archive -path $ovh_apiPath -destinationpath "$pwd\ovh_api" -Force
        Import-Module -Name "$pwd\ovh_api\ps-ovhapi-master\ovh-api.psm1"
    }

###########################################################################

$modules = (Get-Module).name
$ovh_api = $false

foreach($module in $modules){
    if($module -eq "ovh-api"){
    $module
        $ovh_api = $true
        }
    }
if(!$ovh_api){
    Install_ovh_api
    }


##############################################################################################

    Write-Host "Application Key: $Application_Key"
    Write-Host "Application Secret: $Application_Secret"
    Connect-OvhApi -ak $Application_Key -as $Application_Secret -ck '<fake ck>'

    $cre = Get-OvhApiCredential
    $cre
    $ck = $cre[1]
    Start-Sleep -Seconds 10

    $web = New-Object -com InternetExplorer.Application
    $web.visible=$true
    $url = $cre[0]
    $web.navigate($url)
    Start-Sleep -Seconds 5

##############################################################################################

$outp = "Application Key: $Application_Key `n Application Secret: $Application_Secret `n Consumer Key: $ck"
Start-Sleep -Seconds 15
Out-File -FilePath ovh_api_info.txt -InputObject $outp
