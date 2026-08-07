# Gaming laptop-specific packages (titan - HP OMEN MAX 16)
# AMD Ryzen AI 9 HX 375 + NVIDIA RTX 5080

# === NVIDIA GPU ===
# RTX 5080 is Blackwell (GB203) - ONLY the open kernel modules support it.
# Use the -dkms variant: this box has both `linux` and `linux-zen` installed,
# and plain nvidia-open builds against `linux` only (booting zen would fail).
# nouveau cannot drive this card at all and hangs at boot.
# Run scripts/setup_nvidia.sh - it handles multilib, early KMS and the UKI.
dkms
nvidia-open-dkms
nvidia-utils
lib32-nvidia-utils
nvidia-settings
cuda

# === Laptop Power ===
AUR:auto-cpufreq
