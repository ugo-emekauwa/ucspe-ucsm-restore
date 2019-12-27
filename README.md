# Cisco UCSPE Restart and Restore
The Microsoft PowerShell script named **ucspe-ucsm-restore.ps1** provided in this repository enables automating the restart of a Cisco UCS Platform Emulator (UCSPE) and then restoring the UCS Manager configuration. This can be useful for scenarios that require resetting the Cisco UCSPE to a known good state after being used for testing, training, demonstrations or development on UCS Manager.


## Prerequisites:
1. Microsoft Windows PowerShell 5 or above.<br/>
`Note:` Earlier versions of PowerShell may be supported if the Cisco UCS PowerTool Suite is pre-installed.
2. A running Cisco UCSPE virtual machine accessible over your network. More information and downloads for the Cisco UCSPE can be found [here](https://community.cisco.com/t5/unified-computing-system/ucs-platform-emulator-downloads/ta-p/3648177).
3. A saved UCS Manager configuration backup file from the targeted UCSPE in an accessible storage location.
4. [_Optional_] The Cisco UCS PowerTool Suite, available [here](https://software.cisco.com/download/home/286305108/type/284574017/release).<br/>
`Note:` If the Cisco UCS PowerTool Suite is not pre-installed, the Cisco.UCSManager PowerShell module will be automatically installed when running the **ucspe-ucsm-restore.ps1** script. 


## Getting Started:
1. Please ensure that the above prerequisites have been met.
2. Download the **ucspe-ucsm-restore.ps1** file from this repository here on GitHub.
3. Document the IP address of the targeted Cisco UCSPE.
4. Document the storage location of the UCS Manager configuration backup file.


## How to Use:
To perform an automated restart and UCS Manager configuration restore on a targeted UCSPE, here is an example of command usage for the **ucspe-ucsm-restore.ps1** script using the mandatory parameters:
```powershell
ucspe-ucsm-restore.ps1 -IP 192.168.1.7 -User admin -Password Cisco123 -BackupPath "C:\Backups\UCS-Config-Backup.xml"
```

The **ucspe-ucsm-restore.ps1** script will also accept positional arguments for the mandatory parameters. Here is an example:
```powershell
ucspe-ucsm-restore.ps1 192.168.1.7 admin Cisco123 "C:\Backups\UCS-Config-Backup.xml"
```

## Parameters:
### `-IP`
The -IP parameter is mandatory and specifies the IP address of the targeted UCSPE VM. A resolvable hostname for the targeted UCSPE will also be accepted for the value.

### `-User`
The -User parameter is mandatory and specifies the username of the credentials that will be used to log into UCS Manager.

### `-Password`
The -Password parameter is mandatory and specifies the password of the credentials that will be used to log into UCS Manager.

### `-BackupPath`
The -BackupPath parameter is mandatory and specifies the saved storage location of the UCS Manager configuration backup file.

### `-MinutesToWait`
The -MinutesToWait parameter is optional and specifies the number of minutes to wait for the UCSPE to restart before attempting to restore the UCS Manager configuration backup. The default setting is 4 minutes. Depending the version and resources (CPU, memory) allocated to the targeted UCSPE VM, the time needed to wait for the UCSPE to fully restart may more or less than the default 4 minutes. If this is the case, the -MinutesToWait parameter can be added to the **ucspe-ucsm-restore.ps1** script. Here is an example in which the wait time has been adjusted to 10 minutes:
```powershell
ucspe-ucsm-restore.ps1 -IP 192.168.1.7 -User admin -Password Cisco123 -BackupPath "C:\Backups\UCS-Config-Backup.xml" -MinutesToWait 10
```


## Notes and Caveats:
In some instances, a 503 error may be received when the UCS Manager configuration backup restore is attempted. This is an intermittent bug with the UCSPE and can be overcome by re-running the **ucspe-ucsm-restore.ps1** script.


## Use Cases:
A modified version of the script in this repository is a part of the automation used to support and enable the following Cisco Data Center product demonstrations on Cisco dCloud:

1. _Cisco UCS Management with Intersight v1_
2. _Cisco UCS Central 2.0 v1_
3. _Cisco UCS Central 2.0 Lab v1_
4. _Cisco UCS Programmability and Automation Lab v1_

Cisco dCloud is available at [https://dcloud.cisco.com](https://dcloud.cisco.com), where product demonstrations and labs can be found in the Catalog.


## Author:
Ugo Emekauwa


## Contact Information:
uemekauw@cisco.com or uemekauwa@gmail.com
