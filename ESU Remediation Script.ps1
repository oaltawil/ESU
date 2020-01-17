<#
    This script code is provided "as is", with no guarantee or warranty concerning
    the usability or impact on systems and may be used, distributed, and
    modified in any way provided the parties agree and acknowledge that 
    Microsoft or Microsoft Partners have neither accountability nor 
    responsibility for results produced by use of this script.
	
    Microsoft will not provide any support through any means.
#>

# This script is based on the Activate-Product.ps1 script, which is part of the ActivateWs solution developed by Daniel Dorner: https://gallery.technet.microsoft.com/ActivationWs-An-Extended-be597449

# Instructions on ESU:  https://techcommunity.microsoft.com/t5/Windows-IT-Pro-Blog/How-to-get-Extended-Security-Updates-for-eligible-Windows/ba-p/917807

# Get OS version & role information
$OS = Get-WmiObject Win32_OperatingSystem
<# 
    Values for $OS.ProductType:

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

$partialProductKey = $ESUKEY.Substring($ESUKEY.Length - 5)

# Verify the ESU key license status
$licensingProduct = Get-WmiObject -Query ('SELECT LicenseStatus FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)
if ($licensingProduct.LicenseStatus -eq 1)
{
    Write-Host "Product key $ESUKEY is already activated."
    Exit
}


try 
{
    # Install the ESU key
    $licensingService = Get-WmiObject -Query 'SELECT Version FROM SoftwareLicensingService'
    $licensingService.InstallProductKey($ESUKEY) | Out-Null
    $licensingService.RefreshLicenseStatus() | Out-Null

} 
catch 
{
    Write-Host "[Error] Failed to install product key $ESUKey."
    Exit
}


try 
{
    # Get the licensing information
    $licensingProduct = Get-WmiObject -Query ('SELECT Name, ID FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)

    if(!$licensingProduct) 
    {
        Write-Host "[Error] No licensing information for product key $ESUKey was found."
        Exit
    }

    $licenseName = $licensingProduct.Name                       # Name
    $ActivationId = $licensingProduct.ID                        # Activation ID
    
    Write-Host "Name                : $licenseName"
    Write-Host "Activation ID       : $ActivationId"

} 
catch 
{
    Write-Host "[Error] Failed to retrieve the licensing information for product key $ESUKEY."
    Exit
}


try 
{
    # Activate the ESU key
    $licensingProduct.Activate() | Out-Null
    $licensingService.RefreshLicenseStatus() | Out-Null

    # Check if the activation was successful
    $licensingProduct = Get-WmiObject -Query ('SELECT LicenseStatus, LicenseStatusReason FROM SoftwareLicensingProduct where PartialProductKey = "{0}"' -f $partialProductKey)
    
    if ($licensingProduct.LicenseStatus -ne 1)
    {
        Write-Host "[Error] Product activation for $ESUKEY failed ($($licensingProduct.LicenseStatusReason))."
        Exit
    }
    
    Write-Host "Product key $ESUKEY activated successfully."
}
catch 
{
    Write-Host "[Error] Failed to activate the product. Product key $ESUKey was not activated."
}
