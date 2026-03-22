# GPU Passthrough Setup - Progress

## Completed Steps

### Phase 1: Verify Virtualization ✅
- [x] SVM (AMD-V) enabled - confirmed 32 threads reporting
- [x] IOMMU already active - 40 groups found
- [x] GT 710 isolation verified - Group 24 contains only:
  - `12:00.0` GT 710 GPU `[10de:128b]`
  - `12:00.1` GT 710 Audio `[10de:0e0f]`

### Phase 2: Install Virtualization Stack ✅
- [x] Installed packages: `qemu-full libvirt virt-manager dnsmasq edk2-ovmf swtpm`
- [x] Enabled services: `libvirtd.service virtlogd.service`
- [x] Added user to groups: `libvirt, kvm`

### Phase 3: Configure VFIO ✅
- [x] Created `/etc/modprobe.d/vfio.conf`:
  ```
  options vfio-pci ids=10de:128b,10de:0e0f
  softdep nouveau pre: vfio-pci
  ```
- [x] Updated `/etc/mkinitcpio.conf`:
  ```
  MODULES=(vfio_pci vfio vfio_iommu_type1 btrfs)
  ```
- [x] Regenerated initramfs: `sudo mkinitcpio -P`
- [x] **Verified after reboot**: GT 710 using `vfio-pci` driver ✅

### Phase 4: Install Looking Glass ✅
- [x] Looking Glass client installed at `/usr/bin/looking-glass-client`

### Phase 5: Create Shared Memory for Looking Glass ✅
- [x] Created `/etc/tmpfiles.d/10-looking-glass.conf`
- [x] Shared memory exists: `/dev/shm/looking-glass` with correct permissions (stephen:kvm 0660)

---

## Current Phase: Phase 6 - Create Windows VM

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
1. Add Hardware → PCI Host Device
2. Select GT 710 (12:00.0) `[10de:128b]`
3. Add GT 710 Audio (12:00.1) `[10de:0e0f]`

### 6.4 Add Looking Glass Shared Memory to VM XML
Edit VM XML, add inside `<devices>`:
```xml
<shmem name="looking-glass">
  <model type="ivshmem-plain"/>
  <size unit="M">32</size>
</shmem>
```

---

## Next: Phase 7 - Install Looking Glass Host in Windows
Download from https://looking-glass.io/downloads

---

## Quick Reference - Device IDs
- GT 710 GPU: `10de:128b`
- GT 710 Audio: `10de:0e0f`
- IOMMU Group: 24
