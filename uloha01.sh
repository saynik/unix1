#!/bin/bash

if [ "$1" == "--help" ]; then
  echo "Použití: uloha01.sh [--typ|--help] [cesta_k_souboru]
  --typ       Skript vypíše typ souboru (soubor, adresar, ...), jehož cestu určuje druhý parametr.
  --help      Skript vypíše návod k použití tohoto programu"
fi


if [ "$1" == "--typ" ] && [ -e "$2" ]; then
echo "$(file -b "$2")" && exit 0
fi


if [ "$1" == "--typ" ] && [ ! -e "$2" ]; then
echo "Chyba" && exit 1
fi
