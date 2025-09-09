#!/bin/bash

verificar_usuario_root() {
	if [ "$USER" != "root" ]; then
		echo "Error: usuario inválido, inicie el programa en root"
		exit 1
	fi
}

verificar_usuario_root
