#!/bin/bash

proceso=$1

proceso_existe() {
	command -v $proceso >/dev/null
}

if [ $# == 0 ]; then
	echo "Error: ingrese un proceso"
	exit 1
fi

if proceso_existe; then
	$proceso

else
	echo "Error: proceso inválido"
	exit 1
fi
