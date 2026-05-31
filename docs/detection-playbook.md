# Detection Playbook — External DMA

## Tier 1 — Inventory (daily / on boot)

- Enumerate PCIe endpoints with bus mastering (`scripts/enum-pcie-devices.ps1`)
- Hash driver catalog for DMA-capable devices
- Alert on **new** endpoint after baseline

## Tier 2 — Policy

- Deny unauthorized TB/USB4 devices in competitive environments
- Require signed firmware versions for approved hardware
- Pre-match hardware attestation (photo + PCI ID list + driver hash)

## Tier 3 — Telemetry correlation

When game integrity flags fire, correlate:

| Field | Source |
|-------|--------|
| New driver load | ETW `Microsoft-Windows-Kernel-PnP` |
| PCIe surprise removal/add | System log |
| Process handle anomalies | AC internal (not in this repo) |

## Synthetic IOC examples (lab)

```json
{
  "signal": "unknown_pcie_vendor",
  "vendor_id": "0x10EE",
  "device_id": "0x7024",
  "note": "Replace with your lab FPGA IDs — not game-specific"
}
```

## What NOT to rely on alone

- Usermode hooks
- Kernel callbacks without IOMMU enforcement
- "No suspicious drivers" — firmware DMA may not load a traditional `.sys` in the expected path
