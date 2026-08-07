# Core packages - installed on all machines
# Format: one package per line, # for comments
# Prefix with AUR: for AUR packages

# === Shell & Terminal ===
fish
fisher
starship
tmux
neovim
fzf
zoxide
eza
tree
lsd

# === File Management ===
yazi
thunar
tumbler
ffmpegthumbnailer
gvfs
gvfs-smb
gvfs-nfs
unzip
unrar
xarchiver
thunar-archive-plugin
ark
imv
chafa
ueberzugpp

# === System Tools ===
htop
btop
fastfetch
stow
tealdeer
inotify-tools
jq
wget
man-db
dos2unix
usbutils
smartmontools
gparted
lshw
traceroute

# === Development ===
git
git-filter-repo
lazygit
lazydocker
ripgrep
fd
base
base-devel
python
python-pip
python-pipx
python-pynvim
direnv
stylua
luarocks
rustup
ruby
opam
docker
docker-compose
podman-compose
mkcert
vim

# === Hyprland Core ===
hyprland
hypridle
hyprlock
hyprcursor
hyprgraphics
rofi
dunst
libnotify
brightnessctl
awww
grim
slurp
wf-recorder
wtype
wev

# === Wayland/XDG ===
xdg-desktop-portal-hyprland
xdg-utils
qt5-wayland
qt6-wayland
egl-wayland

# === Clipboard ===
wl-clipboard
cliphist
AUR:rofi-emoji

# === Audio/Video ===
pipewire
pipewire-alsa
pipewire-jack
pipewire-pulse
libpulse
wireplumber
mpv
gst-libav
gst-plugin-pipewire
gst-plugins-bad

# === Networking ===
networkmanager
network-manager-applet
iwd
wireless_tools
bluez
bluez-utils
bluez-tools
bluetui
tailscale
openbsd-netcat
dnsmasq

# === System Services ===
sddm
upower
power-profiles-daemon
hyprpolkitagent

# === Boot & Kernel ===
linux
linux-zen
linux-firmware
linux-headers
linux-zen-headers
grub
grub-btrfs
os-prober
efibootmgr
btrfs-progs
snap-pac

# === Fonts ===
noto-fonts
noto-fonts-cjk
noto-fonts-emoji
noto-fonts-extra
ttf-nerd-fonts-symbols
ttf-jetbrains-mono-nerd

# === Theming ===
kvantum
imagemagick
dart-sass
AUR:matugen-bin
AUR:catppuccin-gtk-theme-mocha
AUR:kvantum-theme-catppuccin-git
AUR:bibata-cursor-theme-bin
AUR:python-pywal16
# .config/dunst/dunstrc asks for the Papirus-Dark icon theme; without this
# dunst logs "Could not find theme Papirus-Dark" and notifications lose icons.
papirus-icon-theme

# === Browsers ===
firefox
AUR:waterfox-bin

# === Core Apps ===
AUR:1password
AUR:1password-cli
AUR:ghostty-git

# === Panel/Bar Utilities ===
# quickshell is the bar. autostart.conf runs `exec-once = quickshell` on every
# host and theme-switch generates .config/quickshell/Colors.qml, so it is
# required everywhere -- it was previously listed only in jovian.md, which left
# every other machine with no bar at all. In extra/, not the AUR.
quickshell
AUR:hyprpicker

# === Backups ===
borg
btrbk
timeshift
syncthing
AUR:pika-backup

# === AUR Helper ===
yay

# === Dev Tools (CLI) ===
AUR:claude-code
AUR:sentry-cli

# === Gestures ===
AUR:libinput-gestures
