#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# Handle special flags if we're root
if [ $(id -u) == 0 ] ; then
    # Handle username change. Since this is cheap, do this unconditionally
    #usermod -d /home/$NB_USER -l $NB_USER jovyan

    NB_USER=$JPY_USER
    mkdir /home/$JPY_USER
    cp /tmp/dotfiles/.bashrc /home/$JPY_USER
    cp /tmp/dotfiles/.vimrc /home/$JPY_USER
    cp /tmp/dotfiles/.tmux.conf /home/$JPY_USER
    chown -R $JPY_USER:$JPY_USER /home/$JPY_USER
    cd /home/$JPY_USER

    # Exec the command as NB_USER
    echo "Execute the command as $NB_USER"
    exec su $NB_USER -c "env PATH=$PATH $*"
else
  if [[ ! -z "$NB_UID" && "$NB_UID" != "$(id -u)" ]]; then
      echo 'Container must be run as root to set $NB_UID'
  fi
  if [[ ! -z "$NB_GID" && "$NB_GID" != "$(id -g)" ]]; then
      echo 'Container must be run as root to set $NB_GID'
  fi
  if [[ "$GRANT_SUDO" == "1" || "$GRANT_SUDO" == 'yes' ]]; then
      echo 'Container must be run as root to grant sudo permissions'
  fi
    # Exec the command
    echo "Execute the command"
    exec $*
fi
