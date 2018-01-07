#!/usr/bin/env bash

USERNAME="shotgun"

## add shotgun
function add_shotgun {
  echo "No, the user shotgun does not exist"
  useradd -m -s /bin/bash -U $USERNAME --groups wheel -u 2000
  cp -pr /home/vagrant/.ssh /home/$USERNAME/
  sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
  echo "%USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME
  echo "User shotgun created."
}

if getent passwd $USERNAME > /dev/null 2>&1; then
  echo "yes the user shotgun exists"
else
  add_shotgun
fi

sudo sh /home/vagrant/script/setup_shotgun.sh
