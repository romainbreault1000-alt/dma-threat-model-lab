# DMA Threat Model

## Trust boundaries

```
[Game Process] <--hooks-- [Anti-Cheat UM/KM]
       ^
       | syscalls only
       |
[Kernel] ----callbacks----> [Monitor]
       ^
       | NO callback for external DMA
       |
[PCIe Device / FPGA] ----bus master----> [Physical RAM]
```

Software anti-tamper observes:
- Usermode API (`ReadProcessMemory`, `OpenProcess`)
- Kernel callbacks (ObRegisterCallbacks, PsSetCreateProcessNotifyRoutine)
- Driver load / image integrity

Software anti-tamper **does not** observe:
- Memory reads issued by external bus masters when IOMMU remapping is absent or misconfigured

## Attacker capabilities (lab model)

| Capability | Requires |
|------------|----------|
| Physical R/W to arbitrary pages | Bus mastering + broken/missing IOMMU |
| Sub-10ms read latency | FPGA firmware tuned for TLP batching |
| Invisibility to syscall hooks | No usermode API on hot path |

## Defender assumptions to challenge

1. **"Hooks cover memory access"** — false for DMA paths
2. **"IOMMU enabled in BIOS = safe"** — verify OS remapping tables
3. **"USB devices aren't a threat"** — USB4 / TB tunneling expands surface

## Measurement methodology

1. Baseline machine with IOMMU on/off — diff PCIe config space
2. Inventory `Get-PnpDevice` DMA-capable endpoints
3. Lab-only latency: DMA read vs `ReadProcessMemory` (synthetic buffer, not live games)
4. Document firmware version + motherboard AGESA/ME version

See [detection-playbook.md](detection-playbook.md) for operational signals.
