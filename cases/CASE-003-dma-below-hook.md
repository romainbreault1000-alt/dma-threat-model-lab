# CASE-003 — Below the Hook: DMA Memory Access

**Severity:** HIGH  
**Status:** Published (sanitized)  
**Tags:** `PCIe`, `FPGA`, `IOMMU`, `physical R/W`

## Verdict

Software-only monitoring fails when reads originate from bus-master hardware. IOMMU policy—not hook density—determines whether the path is viable.

## Problem

Kernel object/process callbacks never fire for memory touched via external DMA. Anti-cheat stacks optimized for syscall and callback visibility have a structural blind spot.

## Approach

1. Lab FPGA / research board with owned firmware only
2. Document TLP read path vs `ReadProcessMemory` latency (synthetic target process)
3. Toggle IOMMU — measure capability delta
4. Threat model for tournament LAN (allowlists, slot control)

## Timeline

| Phase | Activity |
|-------|----------|
| RECON | PCIe inventory, firmware flash log |
| DISSECT | BAR map, DMA engine register doc |
| DOCUMENT | This case + detection playbook |
| MITIGATE | VT-d checklist, device attestation |

## Artifacts

- `../schemas/telemetry-event.json` — event shape for inventory tooling
- `../scripts/enum-pcie-devices.ps1` — host enumeration

## Detection points

- New bus master not in hardware baseline
- IOMMU disabled or per-port hole
- TB hot-plug during protected session

## Mitigation

- Enable VT-d / AMD-Vi and **verify** remapping
- Tournament hardware allowlist
- Do not assume hooks equal memory safety
