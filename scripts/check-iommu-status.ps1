#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Quick IOMMU / virtualization-related status checks for lab documentation.
#>

Write-Host "`n=== DMA Threat Model Lab — IOMMU Check ===" -ForegroundColor Cyan

# System info snippet
try {
    $cs = Get-CimInstance Win32_ComputerSystem
    Write-Host "Manufacturer: $($cs.Manufacturer)"
    Write-Host "Model:        $($cs.Model)"
} catch {
    Write-Host "Could not read Win32_ComputerSystem"
}

# Hypervisor / device guard hints
$features = @()
if (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host "OS Build:     $($os.BuildNumber)"
}

# Credential Guard / VBS (related hardening surface)
$dg = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard -ErrorAction SilentlyContinue
if ($dg) {
    Write-Host "`nDeviceGuard available: Yes"
    Write-Host "VirtualizationBasedSecurityStatus: $($dg.VirtualizationBasedSecurityStatus)"
} else {
    Write-Host "`nDeviceGuard WMI: unavailable on this SKU"
}

Write-Host "`nManual steps:" -ForegroundColor Yellow
Write-Host "  1. msinfo32 -> confirm BIOS mode + secure boot state"
Write-Host "  2. Firmware -> Intel VT-d / AMD IOMMU enabled"
Write-Host "  3. Run scripts/enum-pcie-devices.ps1 for inventory JSON"
Write-Host ""
