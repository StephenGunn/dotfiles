# GPU Passthrough Setup - Progress

## Hardware Evolution

| Phase | GPU | Status | Notes |
|-------|-----|--------|-------|
| Initial | NVIDIA GT 710 | ❌ Abandoned | Lacks DirectX 12 support |
| Current | NVIDIA GT 1030 | ✅ Working | DirectX 12, GPU passthrough with Looking Glass |

---

## Current System State

| Item | Status | Details |
|------|--------|---------|
| IOMMU | ✅ Working | 59 groups detected |
| VFIO Module | ✅ Loaded | In initramfs |
| GT 1030 Passthrough | ✅ Working | vfio-pci driver bound, EDID plug on HDMI |
| GRUB | ✅ Functional | Catppuccin theme |
| fstab | ✅ Clean | UUID-based, btrfs |
| EFI Boot Order | ✅ Correct | UEFI OS → Windows |
| Looking Glass | ✅ Working | B7, headless via EDID plug |
| VM (win11) | ✅ Working | Windows 10 Home (Build 26200), Q35/OVMF |

### GPU Inventory
```
03:00.0 - AMD RX 7900 XTX        [1002:744c] - Host GPU (amdgpu driver)
12:00.0 - NVIDIA GT 1030 GP108   [10de:1d01] - VM passthrough GPU (vfio-pci driver)
12:00.1 - NVIDIA GT 1030 Audio   [10de:0fb8] - VM passthrough audio (vfio-pci driver)
7c:00.0 - AMD Raphael iGPU       [1002:164e] - Backup/fallback
```

---

## Problem: GRUB Rendering on Wrong GPU

GRUB was displaying on the GT 710 instead of the RX 7900 XT. This happens because:

1. **UEFI GOP (Graphics Output Protocol)** initializes GPUs in a specific order
2. The BIOS "Primary Display Output" setting controls which GPU gets GOP
3. PCIe slot enumeration order can also affect this

### Solution
Configure BIOS to use AMD GPU (or iGPU) as primary display output before installing GT 1030.

---

## GT 1030 Installation Plan

### Step 1: BIOS Configuration (Before Installing Card)

Enter BIOS and configure:

| Setting | Value | Notes |
|---------|-------|-------|
| Primary Display Output | PCIe Slot 1 / AMD GPU | Where RX 7900 is located |
| Alternative | Integrated Graphics | Uses Raphael iGPU as primary |
| CSM | Disabled | Ensure pure UEFI boot |

The RX 7900 is at PCIe address `03:00.0` (typically slot 1).

### Step 2: Physical Installation

1. **Power off** completely (flip PSU switch)
2. **Remove GT 710** from the PCIe slot
3. **Install GT 1030** in the same slot
4. **Attach HDMI EDID plug** to GT 1030's HDMI port
   - This emulates a connected display
   - Prevents GPU from entering low-power/error state
   - Allows passthrough without a real cable
5. **Connect monitor** to RX 7900 XT only

### Step 3: First Boot - Get Device IDs

After booting, identify the GT 1030:

```bash
# Find the new NVIDIA GPU
lspci -nn | grep -i nvidia

# Expected output (GT 1030 GP108):
# XX:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP108 [GeForce GT 1030] [10de:1d01]
# XX:00.1 Audio device [0403]: NVIDIA Corporation GP108 High Definition Audio Controller [10de:0fb8]
```

**Common GT 1030 Device IDs:**
- GPU: `10de:1d01` (GP108)
- Audio: `10de:0fb8`

Note: Some GT 1030 variants (DDR4 vs GDDR5) may have different IDs.

### Step 4: Update VFIO Configuration

Edit `/etc/modprobe.d/vfio.conf`:

```bash
sudo nano /etc/modprobe.d/vfio.conf
```

Replace contents with (adjust IDs if different):

```
options vfio-pci ids=10de:1d01,10de:0fb8
softdep nouveau pre: vfio-pci
softdep nvidia pre: vfio-pci
```

### Step 5: Regenerate Initramfs

```bash
sudo mkinitcpio -P
```

### Step 6: Reboot and Verify

```bash
sudo reboot

# After reboot, verify GT 1030 is using vfio-pci
lspci -nnk | grep -A3 "NVIDIA"

# Should show:
# Kernel driver in use: vfio-pci
```

### Step 7: Update VM Configuration

In virt-manager, update the PCI passthrough devices:
1. Remove old GT 710 devices
2. Add new GT 1030 GPU (XX:00.0)
3. Add new GT 1030 Audio (XX:00.1)

---

## GRUB Configuration

Current `/etc/default/grub` kernel parameters:

```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet pcie_acs_override=downstream,multifunction"
```

### Optional: Explicit IOMMU Parameters

IOMMU is working without explicit params (modern AMD default), but for documentation purposes you could add:

```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet amd_iommu=on iommu=pt pcie_acs_override=downstream,multifunction"
```

If changed, regenerate GRUB:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Completed Steps (Historical)

### Phase 1: Verify Virtualization ✅
- [x] SVM (AMD-V) enabled - confirmed 32 threads
- [x] IOMMU active - 59 groups found
- [x] GT 710 was isolated in Group 24

### Phase 2: Install Virtualization Stack ✅
- [x] Installed: `qemu-full libvirt virt-manager dnsmasq edk2-ovmf swtpm`
- [x] Enabled: `libvirtd.service virtlogd.service`
- [x] User groups: `libvirt, kvm`

### Phase 3: Configure VFIO ✅
- [x] Created `/etc/modprobe.d/vfio.conf`
- [x] Updated `/etc/mkinitcpio.conf` with VFIO modules
- [x] Regenerated initramfs

### Phase 4: Install Looking Glass ✅
- [x] Client installed at `/usr/bin/looking-glass-client`

### Phase 5: Create Shared Memory ✅
- [x] Created `/etc/tmpfiles.d/10-looking-glass.conf`
- [x] Verified `/dev/shm/looking-glass` (stephen:kvm 0660)

---

## Completed: VM Setup & Looking Glass (2026-03-28)

### Phase 6: Create Windows VM ✅
- [x] Downloaded Windows 11 ISO (CCCOMA_X64FRE_EN-US_DV9)
- [x] Downloaded VirtIO drivers ISO (virtio-win-0.1.285)
- [x] Created VM `win11` with Q35 chipset + OVMF UEFI (Secure Boot)
- [x] 16GB RAM, 12 vCPUs (6 cores, 2 threads), host-passthrough CPU
- [x] Added GT 1030 GPU (bus 0x12 slot 0x00 func 0x0) as PCI passthrough
- [x] Added GT 1030 Audio (bus 0x12 slot 0x00 func 0x1) as PCI passthrough
- [x] Added Looking Glass shared memory (64MB ivshmem-plain) to VM XML
- [x] TPM 2.0 emulated (for Windows 11)

### Phase 7: Install Looking Glass Host ✅
- [x] Installed Looking Glass Host B7 in Windows
- [x] Registered as Windows service: `looking-glass-host.exe InstallService` (admin CMD)
- [x] Service starts at boot before login — login screen visible via Looking Glass

### Phase 8: Guest Drivers & Tools ✅
- [x] Installed NVIDIA drivers for GT 1030 in Windows
- [x] Installed QEMU Guest Agent (`qemu-ga-x86_64.msi` from VirtIO CD)
- [x] Installed VirtIO drivers (custom install — **only Vioinput + Vioserial**)
  - ⚠️ Do NOT install full `virtio-win-guest-tools` — it installs QXL display driver which breaks mouse
  - ⚠️ Do NOT install Balloon, Network, Pvpanic, Fwcfg, Qemupciserial, Viorng, Vioscsi, Viostor, Viofs, Viogpudo, Viomem
- [x] Installed SPICE vdagent (standalone `.msi` from spice-space.org) — enables clipboard sharing
  - ⚠️ Do NOT install full `spice-guest-tools` bundle — also breaks mouse/display

### Phase 9: Mouse & Input Fixes ✅
- [x] **Removed USB tablet device** from VM XML (`<input type="tablet" bus="usb">`)
  - The tablet sends absolute coordinates that conflict with Looking Glass mouse input
  - Without it, virt-manager Spice viewer traps mouse (can't escape) — this is expected/fine
  - Looking Glass handles all input instead
- [x] Looking Glass client launch flags: `looking-glass-client -S -m 28`
  - `-S` = use SPICE for input (keyboard/mouse)
  - `-m 28` = fixes mouse position snapping on Wayland/Hyprland
- [x] F12 configured as escape key (in `~/.config/looking-glass/client.ini`)

### Phase 10: Headless GPU Display ✅
- [x] Tested HDMI EDID emulator — works but limits resolution/refresh (cheap dongle only advertises basic modes)
- [x] **Better solution**: plug real monitor into GT 1030 HDMI, leave monitor input on Linux/AMD source
  - Monitor advertises full 1440p@165Hz EDID to the GT 1030
  - Windows gets full resolution and refresh rate options
  - Looking Glass captures at native res/refresh
  - No EDID dongle needed

### Phase 11: Remove QXL Virtual Display ✅
- [x] Removed `<video type="qxl">` device from VM XML
- [x] Windows now sees only the GT 1030 — no phantom second monitor
- [x] virt-manager Spice display shows nothing (expected — LG handles everything)
- [x] If LG Host fails to start, no fallback display — re-add QXL block to recover

### What Works Now
- `sudo virsh start win11` → VM boots, LG Host starts as service before login
- `looking-glass-client -S -m 28` → see login screen, full mouse/keyboard, clipboard
- `sudo virsh shutdown win11` → clean shutdown via QEMU Guest Agent
- F12 to release mouse capture from Looking Glass
- Clipboard sharing via SPICE vdagent
- 1440p with full refresh rate options
- Windows runs like a native app in a Hyprland window — "Windows Subsystem for Linux, the hard way"

## TODO

### Scripts & Automation
- [ ] Build `vm.sh` management script (start/stop/status/lg)
- [ ] Hyprland windowrules for Looking Glass on workspace 4
- [ ] Rofi menu for VM management

### Future Improvements
- [ ] Switch disk from SATA to VirtIO (need to install viostor driver in Windows first)
- [ ] Set up VirtIO filesystem (viofs) for shared folders between host and VM
- [ ] Test clipboard persistence across VM reboots
- [ ] Verify LG Host service persists across Windows updates

---

## Quick Reference Commands

```bash
# Check IOMMU groups
for g in /sys/kernel/iommu_groups/*/devices/*; do
  echo "$(basename $(dirname $g)): $(lspci -nns ${g##*/})"
done | sort -V

# Check GPU driver binding
lspci -nnk | grep -A3 "VGA\|3D"

# Verify VFIO
lspci -nnk -s 12:00  # GT 1030

# Looking Glass client (use these flags!)
looking-glass-client -S -m 28          # Windowed (recommended)
looking-glass-client -S -m 28 -F       # Fullscreen

# VM management
sudo virsh list --all
sudo virsh start win11
sudo virsh shutdown win11
sudo virsh edit win11                   # Edit VM XML (must be shut down)

# Looking Glass config
# ~/.config/looking-glass/client.ini
```

---

## Troubleshooting

### GRUB Still Shows on Wrong GPU
- Double-check BIOS "Primary Display Output" setting
- Try setting to "Integrated Graphics" temporarily
- Ensure monitor is connected to correct GPU

### GT 1030 Not Using vfio-pci
- Verify device IDs match in `/etc/modprobe.d/vfio.conf`
- Check `lspci -nn` for exact IDs
- Regenerate initramfs: `sudo mkinitcpio -P`

### No Display After Installing GT 1030
- BIOS might have reset display preference
- Boot blind into BIOS (spam DEL key)
- Connect monitor to different GPU temporarily

### HDMI EDID Plug Not Working
- Some cheap EDID emulators don't work with all GPUs
- Try a different EDID plug
- Alternative: Use a dummy HDMI-to-VGA adapter
- **Best option**: Plug real monitor in, keep input switched to host GPU — gets full EDID with proper resolution/refresh

### Mouse Click Resets Position in Looking Glass
- **Cause**: USB tablet device in VM XML sends absolute coordinates that conflict with LG
- **Fix**: Remove `<input type="tablet" bus="usb">` from VM XML
- Must use `looking-glass-client -S -m 28` flags on Wayland/Hyprland

### Guest Tools Breaking Mouse/Display
- Do NOT install `virtio-win-guest-tools` (full bundle) — installs QXL display driver
- Do NOT install `spice-guest-tools` (full bundle) — same problem
- Instead install individually: Vioinput, Vioserial from the custom installer
- Install SPICE vdagent separately (standalone `.msi` from spice-space.org)

### No Fallback Display After Removing QXL
- If LG Host fails to start, you can't see anything
- Re-add the QXL video block to VM XML: `sudo virsh edit win11`
- Add back: `<video><model type="qxl" ram="65536" vram="65536" vgamem="16384" heads="1" primary="yes"/></video>`

---

## Resources

- [Arch Wiki - PCI passthrough](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- [Looking Glass Documentation](https://looking-glass.io/docs/)
- [VFIO Reddit Community](https://reddit.com/r/VFIO)
- [GT 1030 Passthrough Notes](https://wiki.archlinux.org/title/NVIDIA#GP108_(GeForce_GT_1030))
