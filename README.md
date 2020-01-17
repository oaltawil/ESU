# ESU (Extended Support Updates) MAK Product Key Activation for Windows 7 / 2008 / 2008 R2

A solution for detecting, installing, and activating ESU MAK product keys for Windows 7, Windows Server 2008, and Windows Server 2008 R2.

This solution consists of a Configuration Item "ESU - MAK Product Key Installation and Activation - Windows 7, 2008, 2008 R2.cab" which can be imported to System Center Configuration Manager Compliance. Please create a Configuration Baseline containing this Configuration Item to deploy the settings to your Device Collection(s).

Please edit the PowerShell scripts contained in the Configuration Item and replace all instances of "INSERT-ESU-KEY-HERE" with the proper ESU MAK product keys procured by your organization.

This solution requires that the computers have access to the Internet, particularly to the Microsoft Product Activation Services. If your organization uses a proxy server that requires authentication, you can add exclusions for the Microsoft Product Activation URL’s referenced in the following article: https://support.microsoft.com/en-us/help/921471/windows-activation-or-validation-fails-with-error-code-0x8004fe33.

The Detection and Remediation PowerShell scripts contained in the Configuration Item have been included for reference. These script are largely based off the ActivateWs solution developed by Daniel Dorner: https://gallery.technet.microsoft.com/ActivationWs-An-Extended-be597449.
