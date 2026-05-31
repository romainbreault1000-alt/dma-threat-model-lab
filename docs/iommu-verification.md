# IOMMU / VT-d Verification Guide

## Firmware checklist

- [ ] Intel VT-d / AMD IOMMU **Enabled**
- [ ] Above 4G decoding enabled (many boards)
- [ ] Latest BIOS/UEFI — note version string in lab log

## Windows verification

Run as Administrator:

```powershell
.\scripts\check-iommu-status.ps1
```

Expected healthy indicators:
- `Hypervisor/IOMMU` present in msinfo32 (platform dependent)
- Device Manager → no unknown DMA endpoints after clean install

## Linux quick check (optional lab host)

```bash
dmesg | grep -i iommu
find /sys/kernel/iommu_groups/ -type l
```

Empty or sparse `iommu_groups` on a DMA-capable lab box = research signal.

## Common gaps (consumer)

| Gap | Impact |
|-----|--------|
| Remapping disabled per root port | Device behind port may DMA freely |
| Hot-plug Thunderbolt without authorization | New bus master at runtime |
| Legacy USB controllers | Platform-specific bypass folklore — verify, don't assume |

## Remediation priority

1. Enable + verify IOMMU in firmware **and** OS
2. Device allowlist for tournament / high-trust LAN
3. Kernel DMA protection (Windows 1803+ features) — document build-specific behavior
4. Physical slot control for esports events
