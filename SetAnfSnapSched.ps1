function Set-AnfSnapSched 
{
 <#
.SYNOPSIS
The script automates Azure NetApp Files Snapshot capability
and allows you to create a schedule much like a NetApp Filer does


.DESCRIPTION
Unil Azure NetApp Files (ANF) gets the scheduling built in we need
a script to establish a schedule for ANF Snapshots to be taken at 
regular intervals 

.EXAMPLE
Select-AnfEnv -ResourceGroup ResGroupName -account anfAccountName -pool anfCapacityPoolName -vol anfVolumeName

.PARAMETER ResourceGroup
The Azure Resource Group where the Azure NetApp Files Account resides

.PARAMETER Account
The Azure NetApp Files Storage Account name

.PARAMETER Pool
The Azure NetApp Files Pool name

.PARAMETER Vol
The Azure NetApp Files Volume of which you want to take the snapshot 

.NOTES
This script assumes you have already authenticated to Azure, have Az and Az.NetAppFiles modules
installed already
#>

[CmdletBinding()]
    param (
       [Parameter(Mandatory)]
       [string]$ResourceGroup,

       [Parameter(Mandatory)]
       [string]$AnfAccount,
     
       [Parameter(Mandatory)]
       [string]$AnfPool,

       [Parameter(Mandatory)]
       [string]$AnfVol
    )
   

#Variables
$tmstamp = Get-Date -Format "yyyy-MM-dd-HH_mm_ss"
$rg = Get-AzResourceGroup $ResourceGroup 
$azloc = $rg.Location
$snapname = 'hourly.' + $tmstamp
$snapct = get-anfsnapshot -ResourceGroupName $ResourceGroup -AccountName $AnfAccount -PoolName $AnfPool -VolumeName $AnfVol |Measure-Object -Property SnapshotId
$NumSnap = 6
import-module Az.NetAppFiles

#if hourly snaps are more than 6 bail
if ($snapct.count -lt $NumSnap) {
    New-AzNetAppFilesSnapshot -Name $snapname -ResourceGroupName $ResourceGroup -AccountName $anfAccount -PoolName $AnfPool -VolumeName $AnfVol -Location $azloc
 }

}

   


