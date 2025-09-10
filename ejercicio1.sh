#!/bin/bash

usuario=$1
grupo=$2
ruta=$3

usuario_root() {
	[ "$USER" == "root" ]
}


ruta_existe() {
	[ -e $ruta ]
}

grupo_existe() {
	getent group $grupo > /dev/null
}

usuario_existe() {
	getent passwd $usuario > /dev/null
}

if [ $# != 3 ]; then
	echo "Error: debe ingresar un usuario, grupo y ruta"
	exit 1
fi

if ! usuario_root; then
	echo "Error: usuario inválido, inicie el programa en root"
	exit 1
fi


if ! ruta_existe; then
        echo "Error: La ruta ingresada no existe"
        exit 1
fi

if grupo_existe; then 
	echo "Grupo $grupo existe"
	echo " "
else
	echo "Grupo $grupo no existe"
	echo "Creando grupo $grupo..."
	addgroup $grupo
	echo "Grupo $grupo creado"
	echo " "
fi

if usuario_existe; then
	echo "Usuario $usuario existe"
	echo "Agregando $usuario al grupo $grupo..."
	usermod -a -G $grupo $usuario
	echo "Usuario $usuario agregado al grupo $grupo"
else
	echo "Usuario $usuario no existe"
	echo "Creando usuario $usuario..."
	adduser $usuario
	echo "Usuario $usuario creado"
	echo " "
	echo "Agregando $usuario al grupo $grupo..."
	usermod -a -G $grupo $usuario
	echo "Usuario $usuario agregado al grupo $grupo"

fi
