#!/bin/bash
# Setup polkit policy for Popsicle USB Flasher so pkexec works

sudo tee /usr/share/polkit-1/actions/com.system76.popsicle.policy > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
  <action id="com.system76.popsicle">
    <description>Run Popsicle USB Flasher</description>
    <message>Authentication is required to flash USB drives</message>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>auth_admin</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">/usr/bin/popsicle-gtk</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>
</policyconfig>
EOF

echo "Polkit policy for Popsicle installed."
