#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Enumerates PnP devices that may participate in DMA (research inventory only).
.NOTES
  Read-only. Does not modify system state. Lab / baseline use.
#>

$ErrorActionPreference = 'Stop'
$timestamp = Get-Date -Format 'o'
$hostId = $env:COMPUTERNAME

$dmaKeywords = @('PCI', 'Thunderbolt', 'USB4', 'NVMe', 'Network', 'Display', 'Xilinx', 'Altera', 'Intel')

$devices = Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue |
    Where-Object {
        $n = $_.FriendlyName
        if (-not $n) { return $false }
        $dmaKeywords | Where-Object { $n -match $_ }
    } |
    Select-Object FriendlyName, InstanceId, Class, Status

$outDir = Join-Path $PSScriptRoot '..' 'out'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$report = [ordered]@{
    timestamp = $timestamp
    host_id   = $hostId
    count     = @($devices).Count
    devices   = @($devices)
}

$path = Join-Path $outDir "pcie-inventory-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
$report | ConvertTo-Json -Depth 5 | Set-Content -Path $path -Encoding UTF8

Write-Host "[+] Wrote $path"
Write-Host "[+] Devices matched: $($report.count)"
$devices | Format-Table -AutoSize
