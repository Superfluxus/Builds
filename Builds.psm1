### Exit Function ###
function areyousure
{
    $areyousure = read-host "Are you sure you want to exit? (Y/N)"  
           if ($areyousure -eq "y"){complete}  
           if ($areyousure -eq "n"){Builds}  
           else {write-host -foregroundcolor red "Invalid Selection"   
                 areyousure  
                }  
} 


### Builds ###
 function Builds
 {
      Do
    {  

        Write-Host "Checking to see if Powershell session is elevated...."
        $ElevationCheck = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
        start-sleep -Seconds 1
        Write-Host "Elevation status = $ElevationCheck"
        if($ElevationCheck -eq "True"){write-host -ForegroundColor Green Session elevation confirmed}else{write-host -ForegroundColor Red "Powershell session is not elevated, please restart your Powershell instance as an Administrator"
    start-sleep -seconds 3
exit}
start-sleep -seconds 1
        Clear-Host
        Write-Host "-------------------------------------------------------------------------------------------"
        Write-Host "-" -f yellow -nonewline
        Write-Host $moduleversion -f yellow -nonewline
        Write-Host "-" -f yellow
        Write-Host "-------------------------------------------------------------------------------------------" 
        Write-Host "------------------------------------------------------------------------------------------"  
        Write-Host -ForegroundColor Cyan "   PLEASE EXIT MODULE WITH 'COMPLETE' FUNCTION  "
        Write-Host "------------------------------------------------------------------------------------------" 
        Write-Host -ForegroundColor Red " DNS entires, credentials and other customer specific variables were"
        Write-Host -ForegroundColor Red " all correct at time of writing {Redacted}. If any changes are made"
        Write-Host -ForegroundColor Red " please update the source code, or contact {Redacted}"
        Write-Host "------------------------------------------------------------------------------------------"  
        Write-Host "   Please enter the name of the client you are building a machine for  "
        Write-Host "------------------------------------------------------------------------------------------" 
        Write-Host "   Type QUIT to exit this function  "     
        Write-Host "-------------------------------------------------------------------------------------------"  
        Write-Host "-------------------------------------------------------------------------------------------" 
        $answer = read-host "Please enter the name of the client you are buliding a machine for"
        if ($answer -eq “Customer Name Goes Here”){$DNS = DNS IP of for primary DC to domain join
        $DomainUser = Domain\DomainAdmin
        $DomainPassword = DomainAdminPW
        $DomainName = FQDN
        $LocalAdmin = LocalAdminAccount
        VALID 
    }
        if ($answer -eq "QUIT"){areyousure}
        else {write-host "Potential Syntax issue, would you like to see a syntax list of the names we were expecting?"}
        $DisplayList = Read-host "Y/N"
        if ($DisplayList -eq "Y"){DisplayList}
        if ($DisplayList -eq "N"){Builds}
        else {write-host -foregroundcolor Red "Invalid Selection, please select Y or N"
    Builds}
        }until ($answer -ne "")
    }

### Checks for AV/RMM directories ### 
function VALID
{ Do
       {
           if($AntiVirusStatus -eq "False"){Write-Host -ForegroundColor Red "$Answer is not configured for AntiVirus deployment. Please manually deploy alternative Anti-Virus. AntiVirus checks will be set to True to continue with module..."
           Start-Sleep -Seconds 2
        $AntiVirusCheck = "True"}
        $HalfPath = Join-Path -path "\\CompanyDirectory-build-hv\CompanyDirectory\buildsmodule\" -ChildPath $answer
        Write-Host "Checking if RMM & AntiVirus are already installed...."
        start-sleep -seconds 2
        $RMMCheck = Test-Path -path "C:\Windows\RMM"
        Write-Host "RMM deployment = $RMMCheck"
        $AntiVirusCheck = Test-Path -path "C:\programdata\AntiVirus"
        Write-Host "AntiVirus deployment = $AntiVirusCheck"
        if($RMMCheck -eq "True" -and $AntiVirusCheck -eq "True"){$finalcheck = "True"}else{Write-Host "Beginning fresh deployment..."}
        if($FinalCheck -eq "True"){Write-Host -ForegroundColor Red "AntiVirus and RMM already exist, redirecting..."
    ExtraFiles}
Write-Host "You have chosen $answer, is this correct?"

$Confirmation = read-host Y/N?
if ($Confirmation -eq "Y"){DownloadFiles}
if ($Confirmation -eq "N"){Builds}
else {write-host -ForegroundColor red "Invalid Selection" 
VALID
       }
    }until ($Confirmation -ne "")
}

# Downloads AntiVirus and RMM
function DownloadFiles
{
Do
    {
Write-Host "Mapping drive..."
        net use \\CompanyDirectory-build-hv\CompanyDirectory\buildsmodule PASSWORD /USER:"CompanyDirectory\administrator"
$HalfPath = Join-Path -path "\\CompanyDirectory-build-hv\CompanyDirectory\buildsmodule\" -ChildPath $answer

#Verify/Create C:\COMPANYDIRECTORY Folder

Write-Host "Checking if COMPANYDIRECTORY Directory exists"

if(-not (Test-Path "C:\COMPANYDIRECTORY")){new-item -ItemType directory -path c:\CompanyDirectory}

if(-not (Test-Path "c:\windows\RMM")){Write-Host "Deploying RMM Agent..."

Copy-Item "$HalfPath\agentinstall.msi" -Destination "C:\COMPANYDIRECTORY\AgentInstall.msi"

Write-Host "Installing..."

Start-Process msiexec.exe -Wait -ArgumentList '/I C:\COMPANYDIRECTORY\AgentInstall.msi /quiet /qn'

Write-Host "RMM deployment finished"}else{Write-host "RMM already exists"}

if($AntiVirusCheck -eq "True"){Write-Host "AntiVirus Check = $AntiVirusCheck, skipping deployment..."}
elseif(-not (Test-Path "C:\ProgramData\AntiVirus")){new-item -ItemType directory -path c:\CompanyDirectory\AntiVirus

Write-Host "Deploying AntiVirus..."

Copy-Item -Path "\\CompanyDirectory-build-hv\CompanyDirectory\buildsmodule\AntiVirus\AntiVirussetup.exe" -Destination "C:\COMPANYDIRECTORY\AntiVirus\AntiVirusSetup.exe"

Copy-Item "$HalfPath\AntiVirus.bat" -Destination "C:\COMPANYDIRECTORY\AntiVirus\AntiVirus.bat"

cmd.exe /c 'C:\COMPANYDIRECTORY\AntiVirus\AntiVirus.bat'

Write-Host "Success!"}else{Write-host "AntiVirus already exists"}


# Verification check

$RMMCheck = Test-Path -path "C:\Windows\RMM"
if ($RMMCheck -eq "True"){Write-Host -foregroundcolor Green "RMM Deployed Successfully"}
else{Write-Host "RMM not fully deployed yet, waiting..."
start-sleep -seconds 15
Write-Host "Is RMM installed? - $RMMCheck"
if ($RMMCheck -eq "True"){Write-Host -ForegroundColor Green "RMM Deployed Successfully"}
else{
Write-Host "RMM failed to deploy"}
}

$AntiVirusCheck = Test-Path -path "C:\ProgramData\AntiVirus"
if ($AntiVirusStatus = "False"){Write-Host "This Customer is not configured for AntiVirus deployment"
Start-Sleep -Seconds 2
ExtraFiles}
if ($AntiVirusCheck -eq "True"){Write-Host "AntiVirus Deployed Successfully"}
elseif($AntiVirusStatus -ne "False"){Write-Host "AntiVirus not fully deployed yet, waiting..."
Start-Sleep -seconds 10
Write-Host "Is AntiVirus installed? - $AntiVirusCheck"
if ($AntiVirusCheck -eq "True"){Write-Host "AntiVirus Deployed Successfully"
else{Write-Host "AntiVirus failed to deploy"}}
    Until($RMMcheck -eq "True")
}

Write-Host "AntiVirus health check, deployment = $AntiVirusCheck"
Write-Host "RMM health check, deployment = $RMMCheck"

if($RMMCheck -eq "True" -and $AntiVirusCheck -eq "True" ){$FinalCheck = "True"
Write-Host -ForegroundColor Green "Success! Both packages successfully deployed"
ExtraFiles}
else{Write-Host -ForegroundColor red "Error
Both packages are not installed
AntiVirus = $AntiVirusCheck
RMM = $RMMCheck"} 

if($RMMCheck -eq "True" -and $AntiVirusCheck -eq "True"){$FinalCheck = "True"}
    }until($Finalcheck -eq "True")
}

#Redirection Menu for software download
function ExtraFiles
{
    Do
    {
Write-Host "Would you like to install any other files?"
$Advance = Read-Host "Yes\Quit\Contents"
if($Advance -eq "Yes"){DownloadFilesMISC}
if ($Advance -eq "Quit"){areyousure}
if($Advance -eq "Contents"){ContentsPage}
else{write-host -ForegroundColor Red "Invalid Selection"
ExtraFiles
}

    }
    until($Advance -ne "")
}

#Check Misc directory in customer folder for additional software
function DownloadFilesMISC
{Do
    {

Write-Host -ForegroundColor Red "We found these other files that may be applicable"
Write-Host -ForegroundColor Cyan "Please be aware that AgentInstall.msi is for RMM and AntiVirus.bat is ANTIVIRUS; these may have already been ran"

Get-childitem -path "$HalfPath"

$Installer = Read-Host "Type the filename of the installer you would like to run"

Write-host "Installing $Installer ..."

&$HalfPath\$Installer /qn /q

Write-Host "Deployment finished"

Write-Host "Would you like to install any other files?"

$MiscFilesAnswer = Read-Host "(Yes/Domain/Quit)"

if($MiscFilesAnswer -eq "Yes"){DownloadFilesMISC}
if ($MiscFilesAnswer -eq "Quit"){areyousure}
if ($MiscFilesAnswer -eq "Domain"){DomainJoin}
}
    
until($MiscFilesAnswer -ne "")
    
}


# Attempt to domain join with pre specified credentials
function DomainJoin
{
    Do
    {
    
    write-host "Beginning Domain Join"
    if($Answer -eq "SpecialCustomer1"){

        Write-Host "Build is for $Answer, please ensure you are plugged into their network port before continuing Domain Join"
        $CurrentIP = Test-Connection -ComputerName (hostname) -Count 1 | select -ExpandProperty ipv4address
        $Currentip = $CurrentIP.IPaddresstostring
        if($currentip -like "InternalNetworkRange.*"){Write-Host "Current IP address is $CurrentIP, this seems to be an internal build room IP."
    Write-Host "Please wait until you have gotten a new a new DHCP lease from $answer"
}

        Write-Host "This machine's current IP address is $CurrentIP"
        Read-host "Press Enter key to continue"
        $SecurePassword = ConvertTo-SecureString $DomainPassword -AsPlainText -Force
        $DomainCredential = New-Object System.Management.Automation.PSCredential ($DomainUser, $SecurePassword)
        
        Add-Computer -DomainName FQDN -Credential $DomainCredential}
        elseif($Answer -eq "SpecialCustomer2"){
            Write-Host "Build is for $Answer, please ensure you plugged into their network port before continuing Domain Join"
            $CurrentIP = Test-Connection -ComputerName (hostname) -Count 1 | select -ExpandProperty ipv4address
            $Currentip = $CurrentIP.IPaddresstostring
            if($currentip -like "InternalIPAddress.*"){Write-Host "Current IP address is $CurrentIP, this seems to be an internal build room IP."
        Write-Host "Please wait until you have gotten a new a new DHCP lease from $answer"
    }
    
            Read-host "Press Enter key to continue"

            $SecurePassword = ConvertTo-SecureString $DomainPassword -AsPlainText -Force
        $DomainCredential = New-Object System.Management.Automation.PSCredential ($DomainUser, $SecurePassword)
        
        Add-Computer -DomainName FQDN -Credential $DomainCredential            
        }
        else{ Write-Host "Build is not SpecialCustomer1 or SpecialCustomer2, manually changing DNS..."
    $adapter = Get-NetAdapter | Select -expand name
ForEach ($adapters in $adapter)
{
netsh interface ipv4 add dnsservers name=$adapters address=$DNS index=1
}
    $SecurePassword = ConvertTo-SecureString $DomainPassword -AsPlainText -Force
 $DomainCredential = New-Object System.Management.Automation.PSCredential ($DomainUser, $SecurePassword)
    add-computer –domainname $domainname -Credential $DomainCredential}
    if ((gwmi win32_computersystem).partofdomain -eq $true) {$DomainJoinStatus = "True"}
$Check = Read-Host "Domain Join Success = $DomainJoinStatus! Where would you like to go now?
1) Retry Domain Join
2) Download more software
3) Complete build
4) Set local admin password
"
if($Check -eq "1"){DomainJoinExplicit}
if($Check -eq "2"){DownloadFilesMISC}
if($Check -eq "3"){Complete}
if($check -eq "4"){SetLocalAdminPassword}
else{Write-Host "Invalid Selection, please try again"
start-sleep -Seconds 2
$Check = Read-Host "Domain Join Success = $DomainJoinStatus! Where would you like to go now?
1) Retry Domain Join
2) Download more software
3) Complete build
4) Set local admin password
"
if($Check -eq "1"){DomainJoinExplicit}
if($Check -eq "2"){DownloadFilesMISC}
if($Check -eq "3"){Complete}
if($check -eq "4"){SetLocalAdminPassword}
else{ContentsPage}
}

    }until($DomainJoinStatus = "True")

#DomainJoinCheck
if ((gwmi win32_computersystem).partofdomain -eq $true) {$DomainJoinStatus = "True"
    write-host -ForegroundColor green "Domain Join successful!"
} else {
    write-host -ForegroundColor red "Domain join failure!"
}until($DomainJoinStatus -eq "True")
}

#Attempt to domain join with Explicit credentials
Function DomainJoinExplicit
{
    Do
    {
    
        Write-Host -ForegroundColor Cyan "You are here because the automated Domain Join failed"
        Write-host -ForegroundColor cyan "In this section, you will be prompted for a DNS target, credentials, and the FQDN"
Write-Host "Please enter the DNS address"
$DNSExplicit = Read-Host
Write-Host "Attempting to change primary DNS on network adapter to $DNSExplicit"
        $adapter = Get-NetAdapter | Select -expand name
ForEach ($adapters in $adapter)
{
netsh interface ipv4 add dnsservers name=$adapters address=$DNSExplicit index=1
}
Write-Host "Please enter the FQDN of the domain you are trying to join"
$domainnameExplcit = Read-Host

Write-Host -ForegroundColor cyan "Attempting explicit domain join......"
$ExplciitCreds = Get-Credential
        add-computer –domainname $domainnameExplcit -Credential $ExplciitCreds

        Write-Host "Let's see if that worked any better"
        if ((gwmi win32_computersystem).partofdomain -eq $true) {$DomainJoinStatus = "True"
    write-host -ForegroundColor green "Domain Join successful!"
    Write-Host "Resetting local admin password"
    cmd.exe /c 'net user LocalAdminAccount $LocalAdmin'
    start-sleep -Seconds 2
    ContentsPage
} else {
    write-host -ForegroundColor red "Domain join failure"
}
$Check2 = Read-Host "Domain Join Success = $DomainJoinStatus! Where would you like to go now?
1) Retry Domain Join Explcitly
2) Download more software
3) Complete build
4) Set local admin password
"
if($Check2 -eq "1"){DomainJoinExplicit}
if($Check2 -eq "2"){DownloadFilesMISC}
if($Check2 -eq "3"){Complete}
if($check -eq "4"){SetLocalAdminPassword}
    }
    until($DomainJoinStatus -eq "True")
}

#Set local admin password with pre loaded credentials/Explicit if fails
function SetLocalAdminPassword
{
    Do
    {
        if(!$LocalAdmin){$LocalAdmin = "PASSWORD"}
   $PasswordStatus = net user LocalAdminAccount $LocalAdmin
   net user LocalAdminAccount $LocalAdmin
   Write-Host "Password change result = $PasswordStatus"
    if($PasswordStatus -ne "The command completed successfully."){write-host "Unable to change local admin password"
    write-host "Unable to change password, please ensure your session is elevated"
    write-host "Would you like to try and choose the local admin password yourself (I'll attempt to elevate your session for you)"
    $ElevateMeUpScotty = Read-Host "Y/N"
    if($ElevateMeUpScotty -eq "Y"){Write-Host "Please choose a local admin password"
    $NewLocalAdmin = read-host 
    start-process cmd.exe -verb runas -ArgumentList "net user LocalAdminAccount $newlocaladmin"}
    if($ElevateMeUpScotty -eq "N"){complete}
    }else{write-host -ForegroundColor green "Password successfully changed"
start-sleep -Seconds 2
complete}
    }until($PasswordStatus -eq "The command completed successfully." )
}


#Closing menu
function complete {
    
Do
{ cls
Write-Host "You have chosen to end the build module here"
Write-Host  "Here is a summary of the current machine:"
Write-host -ForegroundColor Cyan "Domain Joined? - $DomainJoinStatus"
Write-host -ForegroundColor Cyan "RMM Installed? - $RMMCheck"
Write-host -ForegroundColor Cyan "AntiVirus Insatlled? - $AntiVirusCheck"

Write-Host "Tidying up files..."

Remove-item -path C:\COMPANYDIRECTORY\AntiVirus\AntiVirus.bat
Remove-item -PATH C:\COMPANYDIRECTORY\AntiVirus\AntiVirussetup.exe
Remove-Item -path c:\CompanyDirectory\agentinstall.msi

start-sleep -Seconds 2

write-host "Please check over any additional software you installed & ensure that the local LOCALADMINACCOUNT account has a password!"
Write-Host "Set local admin password now? (Y/N)"
$Oops = read-host "Y/N"
if($oops -eq "Y"){SetLocalAdminPassword}
if($OOps -eq "N"){
Start-Sleep -seconds 5

Write-Host -ForegroundColor Red "Exiting module..."

Write-Host -ForegroundColor Cyan "Don't forget Windows Updates!"

start-process "ms-settings:windowsupdate"

start-sleep -seconds 3

exit}
}
until($oops -ne "")
}


function ContentsPage
{
    Do
    {Write-Host "Where would you like to go?
    1) Domain Join
    2) Download more software
    3) Complete build
    4) Set local admin password
    "
    $ContentsCheck = Read-Host "1-5"
    if($ContentsCheck -eq "1"){DomainJoin}
    if($ContentsCheck -eq "2"){DownloadFilesMISC}
    if($ContentsCheck -eq "3"){Complete}
    if($ContentsCheck -eq "4"){SetLocalAdminPassword}
}
until($ContentsCheck -NE "")
}

#Display list of accepted customer names to avoid syntax errors
            function DisplayList
            {
            Do
            {
                Clear-Host
            Write-Host "Syntax perfect list of customer names go here"
            
            Write-host "Would you like to try again?"
            $TryAgain = read-host "Y/N?"
            if ($TryAgain -eq "y"){Builds}  
            if ($Tryagain -eq "n"){areyousure}  
            else {write-host -foregroundcolor red "Invalid Selection"
            DisplayList }
         }until ($TryAgain -ne "")
            
           
     }

