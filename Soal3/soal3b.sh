#!/bin/bash

bash "/home/kali/Documents/Shift/soal3a.sh"
presentfile=$(date +"%d-%m-%Y")
mkdir "$presentfile"

mv Koleksi_* "./$presentfile/"
mv Foto.log "./$presentfile/"

