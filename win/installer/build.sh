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

VERSION=0.2.1

RAC=$(git rev-parse --show-toplevel)

# Aller à la racine du dépôt
cd $RAC || exit 1

mkdir build
cd build || exit 1
wget https://github.com/Dwight-Studio/JArmEmu/releases/download/v0.2.1/JArmEmu-${VERSION}.zip
unzip JArmEmu-${VERSION}.zip

sudo systemctl start docker
sudo docker run --rm -i -v "$RAC:/jarmemu" amake/innosetup /V Z:/jarmemu/installer/jarmemu.iss

cd $RAC || exit 1
rm -rf build