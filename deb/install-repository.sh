#!/bin/bash

#
#            ____           _       __    __     _____ __            ___
#           / __ \_      __(_)___ _/ /_  / /_   / ___// /___  ______/ (_)___
#          / / / / | /| / / / __ `/ __ \/ __/   \__ \/ __/ / / / __  / / __ \
#         / /_/ /| |/ |/ / / /_/ / / / / /_    ___/ / /_/ /_/ / /_/ / / /_/ /
#        /_____/ |__/|__/_/\__, /_/ /_/\__/   /____/\__/\__,_/\__,_/_/\____/
#                         /____/
#     Copyright (C) 2024 Dwight Studio
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#
# Description: Automates adding the Dwight Studio repository to any APT-based distribution


function main() {

  # Check if root
  if [ "${UID}" != "0" ]; then
    echo -e "[\u274c] You must be root to install the repository."
    exit 1
  fi

  # Installing key
  echo -e "[\u271c] Installing Dwight Studio's PGP key..."
  wget -q -O /etc/apt/trusted.gpg.d/dwightstudio.gpg https://deb.dwightstudio.fr/public.gpg
  echo -e "[\u2714] Done."

  # Get OS informations
  if [ -f /etc/os-release ]; then
    source /etc/os-release
  elif [ -f /usrd/lib/os-release ]; then
    source /usr/lib/os-release
  else
      echo -e "[\u2717] Unable to get OS information."
      exit 1
  fi

  CODENAME="$ID-$VERSION_CODENAME"

  # Writing in files (all)
  echo -e "[\u271c] Installing 'all' branch..."
  echo "deb https://deb.dwightstudio.fr/ all main" > /etc/apt/sources.list.d/dwightstudio-${CODENAME}.list
  echo -e "[\u2714] Done."

  # Writing in files (codename)
  if curl --head --silent --fail https://deb.dwightstudio.fr/dists/$CODENAME 2> /dev/null; then
    echo -e "[\u271c] Installing '$CODENAME' branch..."
    echo "deb https://deb.dwightstudio.fr/ $CODENAME main" >> /etc/apt/sources.list.d/dwightstudio-${CODENAME}.list
    echo -e "[\u2714] Done."
  else
    echo -e "[\u2717] No repository available for $CODENAME. Some packages may be unavailable for your distribution, you can contact us on discord for support."
  fi

  echo -e "[\u2714] Repository successfully installed. You can update the package list with 'sudo apt update'."
}

main
exit 0
