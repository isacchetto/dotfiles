#! /bin/env bash

# Scarica l'ultima versione
wget https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
tar -xvf stow-latest.tar.gz && rm "$_"
# Configura per installare nella tua home
cd stow-* || exit
./configure --prefix="$HOME"/.local
# Compila e installa
make && make install
