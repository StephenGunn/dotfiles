# GPU Passthrough with Looking Glass Setup Plan

## System Overview

| Component | Details |
|-----------|---------|
| CPU | AMD Ryzen 9 7950X3D (AMD-V) |
| Host GPU | AMD RX 7900 XT/XTX (03:00.0) |
| Passthrough GPU | NVIDIA GT 710 (12:00.0) |
| GPU Audio | NVIDIA GK208 Audio (12:00.1) |
| Backup GPU | AMD Raphael iGPU (7c:00.0) |

### Device IDs for Passthrough
- GPU: `10de:128b`
- Audio: `10de:0e0f`

---

## Phase 1: Verify Virtualization Support

### 1.1 Check BIOS/UEFI Settings
- [ ] Enter BIOS (DEL or F2 on boot)
- [ ] Enable **SVM Mode** (AMD's virtualization)
- [ ] Enable **IOMMU** (may be called AMD-Vi)
- [ ] Ensure **Above 4G Decoding** is enabled (for GPU passthrough)
- [ ] Save and reboot

### 1.2 Verify CPU Virtualization
```bash
# Should show "svm" for AMD
grep -E "svm|vmx" /proc/cpuinfo
```

---

## Phase 2: Enable IOMMU

### 2.1 Edit Kernel Parameters
Edit `/etc/default/grub` and add to `GRUB_CMDLINE_LINUX_DEFAULT`:
```
amd_iommu=on iommu=pt
```

Full line should look like:
```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet amd_iommu=on iommu=pt"
```

### 2.2 Regenerate GRUB Config
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 2.3 Reboot and Verify IOMMU
```bash
# After reboot, verify IOMMU is enabled
sudo dmesg | grep -i -e DMAR -e IOMMU

# Should see messages like "AMD-Vi: IOMMU performance counters supported"
```

---

## Phase 3: Check IOMMU Groups

### 3.1 View IOMMU Groups
Run this script to see groupings:
```bash
#!/bin/bash
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done
done
```

### 3.2 Verify GT 710 Isolation
- [ ] GT 710 GPU (12:00.0) should be in its own group OR only with its audio (12:00.1)
- [ ] If grouped with other devices you need, you may need ACS override patch (avoid if possible)

---

## Phase 4: Install Virtualization Stack

### 4.1 Install Packages
```bash
sudo pacman -S qemu-full libvirt virt-manager dnsmasq iptables-nft \
    ovmf swtpm edk2-ovmf
```

### 4.2 Install Looking Glass (AUR)
```bash
yay -S looking-glass
# Or use your preferred AUR helper
```

### 4.3 Enable Services
```bash
sudo systemctl enable --now libvirtd.service
sudo systemctl enable --now virtlogd.service
```

### 4.4 Add User to Groups
```bash
sudo usermod -aG libvirt,kvm $USER
# Log out and back in for group changes
```

---

## Phase 5: Configure VFIO (GPU Isolation)

### 5.1 Create VFIO Config
Create `/etc/modprobe.d/vfio.conf`:
```
options vfio-pci ids=10de:128b,10de:0e0f
softdep nouveau pre: vfio-pci
softdep nvidia pre: vfio-pci
```

### 5.2 Update Initramfs Modules
Edit `/etc/mkinitcpio.conf`:
```
MODULES=(vfio_pci vfio vfio_iommu_type1)
```

### 5.3 Regenerate Initramfs
```bash
sudo mkinitcpio -P
```

### 5.4 Reboot and Verify
```bash
# After reboot, GT 710 should use vfio-pci driver
lspci -nnk -s 12:00.0
# Should show: Kernel driver in use: vfio-pci
```

---

## Phase 6: Create Windows VM

### 6.1 Download Required ISOs
- [ ] Windows 10/11 ISO from Microsoft
- [ ] VirtIO drivers ISO: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/

### 6.2 Create VM in virt-manager
1. Open virt-manager
2. Create new VM → Local install media
3. Select Windows ISO
4. **Important settings:**
   - Chipset: Q35
   - Firmware: UEFI (OVMF)
   - CPU: host-passthrough
   - Add VirtIO disk (for best performance)

### 6.3 Add GPU to VM
In VM settings:
1. Add Hardware → PCI Host Device
2. Select GT 710 (12:00.0)
3. Add GT 710 Audio (12:00.1)

### 6.4 Configure VM XML (if needed)
May need to add to `<features>`:
```xml
<hyperv>
  <vendor_id state="on" value="randomid"/>
</hyperv>
<kvm>
  <hidden state="on"/>
</kvm>
```

---

## Phase 7: Install Looking Glass

### 7.1 Create Shared Memory File
Create `/etc/tmpfiles.d/10-looking-glass.conf`:
```
f /dev/shm/looking-glass 0660 stephen kvm -
```

Apply immediately:
```bash
sudo systemd-tmpfiles --create /etc/tmpfiles.d/10-looking-glass.conf
```

### 7.2 Add Shared Memory to VM
Edit VM XML, add inside `<devices>`:
```xml
<shmem name="looking-glass">
  <model type="ivshmem-plain"/>
  <size unit="M">32</size>
</shmem>
```

### 7.3 Install Looking Glass Host in Windows VM
1. Boot VM
2. Download Looking Glass Host from: https://looking-glass.io/downloads
3. Install in Windows
4. Configure to run at startup

### 7.4 Run Looking Glass Client on Host
```bash
looking-glass-client
```

---

## Phase 8: Optimization (Optional)

### 8.1 CPU Pinning
For best performance, pin VM CPUs to specific cores. Edit VM XML:
```xml
<vcpu placement="static">8</vcpu>
<cputune>
  <vcpupin vcpu="0" cpuset="8"/>
  <vcpupin vcpu="1" cpuset="9"/>
  <!-- etc -->
</cputune>
```

### 8.2 Hugepages
For memory performance:
```bash
# Add to /etc/sysctl.d/hugepages.conf
vm.nr_hugepages = 8192  # Adjust for VM RAM size
```

### 8.3 Audio Passthrough Options
- **HDMI Audio**: Already passed through with GPU
- **PulseAudio/Pipewire**: Use QEMU audio backend
- **Scream**: Low-latency network audio

---

## Troubleshooting

### IOMMU Not Enabling
- Double-check BIOS settings
- Try `amd_iommu=on` without `iommu=pt` first
- Check `dmesg | grep AMD-Vi`

### GPU Still Using nouveau
- Verify vfio.conf has correct IDs
- Check module load order in mkinitcpio
- Try adding `rd.driver.pre=vfio-pci` to kernel params

### VM Won't Start with GPU
- Check IOMMU groups aren't sharing critical devices
- Verify OVMF/UEFI firmware is selected
- Check libvirt logs: `journalctl -u libvirtd`

### Looking Glass Black Screen
- Ensure Looking Glass Host is running in Windows
- Check shared memory size is adequate (32MB usually enough for 1080p)
- Verify permissions on `/dev/shm/looking-glass`

---

## Quick Reference Commands

```bash
# Check IOMMU groups
for g in /sys/kernel/iommu_groups/*/devices/*; do echo "$(basename $(dirname $g)): $(lspci -nns ${g##*/})"; done | sort -V

# Check GPU driver
lspci -nnk -s 12:00.0

# Start VM
virsh start win10

# Looking Glass client
looking-glass-client -F  # Fullscreen
looking-glass-client -s  # Spice integration

# VM console
virsh console win10
```

---

## Resources
- [Arch Wiki - PCI passthrough](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- [Looking Glass Documentation](https://looking-glass.io/docs/)
- [VFIO Reddit Community](https://reddit.com/r/VFIO)
- [Single GPU Passthrough Guide](https://github.com/joeknock90/Single-GPU-Passthrough) (not needed for your setup)
