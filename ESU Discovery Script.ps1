<#
    This script code is provided "as is", with no guarantee or warranty concerning
    the usability or impact on systems and may be used, distributed, and
    modified in any way provided the parties agree and acknowledge that 
    Microsoft or Microsoft Partners have neither accountability nor 
    responsibility for results produced by use of this script.
	
    Microsoft will not provide any support through any means.
#>

# Instructions on ESU:  https://techcommunity.microsoft.com/t5/Windows-IT-Pro-Blog/How-to-get-Extended-Security-Updates-for-eligible-Windows/ba-p/917807

$strCompliant = "Non-Compliant"

# Get OS version & role information
$OS = Get-WmiObject Win32_OperatingSystem
<# Values for $OS.ProductType:
 (1) Work Station
 (2) Domain Controller
 (3) Server
#>

# Get the ESU Key
If ($OS.Version -like '6.0*' -and (($OS.ProductType -eq 2) -or ($OS.ProductType -eq 3)))
{
    # "Windows Server 2008" 
    $ESUKEY = "<INSERT-ESU-KEY-HERE>"
}

If ($OS.Version -like '6.1*' -and $OS.ProductType -eq 1)
{
    # "Windows 7" 
    $ESUKEY = "<INSERT-ESU-KEY-HERE>"
}
                     
If ($OS.Version -like '6.1*' -and (($OS.ProductType -eq 2) -or ($OS.ProductType -eq 3)))
{
    # "Windows Server 2008 R2"
    $ESUKEY = "<INSERT-ESU-KEY-HERE>"
}

# Verify the ESU key license status
$partialProductKey = $ESUKEY.Substring($ESUKEY.Length - 5)
$licensingProduct = Get-WmiObject -Query ('SELECT LicenseStatus FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)

if ($licensingProduct.LicenseStatus -eq 1)
{
    $strCompliant = "Compliant"
}
              
Write-Host $strCompliant
