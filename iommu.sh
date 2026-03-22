#!/bin/bash
for g in /sys/kernel/iommu_groups/*/devices/*; do
  group=$(basename $(dirname $(dirname $g)))
  device=$(lspci -nns ${g##*/})
  echo "Group $group: $device"
done | grep -i nvidia
