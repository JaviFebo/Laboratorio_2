#!/bin/bash

usuario=$1
grupo=$2
ruta=$3

#Función que devuelve verdadero si el usuario es root y falso si no lo es
usuario_root() {
	[ "$USER" == "root" ]
}

#Función que devuelve verdadero si la ruta existe y falso si no
ruta_existe() {
	[ -e $ruta ]
}

#Función que devuelve verdadero si el grupo existe y falso si no
grupo_existe() {
	getent group $grupo > /dev/null
}

#Función que devuelve verdadero si el usuario existe y falso si no
usuario_existe() {
	getent passwd $usuario > /dev/null
}

#Función que cambia la pertenencia del archivo con la ruta ingresada al usuario y grupo ingresado
cambiar_pertenencia() {
	    chown $usuario:$grupo $ruta
}

#Función que cambia los permisos del archivo con la ruta ingresada
cambiar_permisos() {
	chmod u=rwx $ruta
	chmod g=r $ruta
	chmod o-rwx $ruta
}

#Si el número de parámetros ingresados es diferente de 3 termina el script
if [ $# != 3 ]; then
	echo "Error: debe ingresar un usuario, grupo y ruta"
	exit 1
fi

#Si el usuario no es root termina el script
if ! usuario_root; then
	echo "Error: usuario inválido, inicie el programa en root"
	exit 1
fi

#Si la ruta no existe termina el script
if ! ruta_existe; then
        echo "Error: La ruta ingresada no existe"
        exit 1
fi

#Si el grupo existe imprime un mensaje indicándolo
if grupo_existe; then 
	echo "Grupo $grupo existe"
	echo " "
#Si el grupo no existe imprime un mensaje indicándolo y lo crea
else
	echo "Grupo $grupo no existe"
	echo "Creando grupo $grupo..."
	addgroup $grupo
	echo "Grupo $grupo creado"
	echo " "
fi

#Si el usuario existe imprime un mensaje indicándolo y lo agrega al grupo
if usuario_existe; then
	echo "Usuario $usuario existe"
	echo "Agregando $usuario al grupo $grupo..."
	usermod -a -G $grupo $usuario
	echo "Usuario $usuario agregado al grupo $grupo"
#Si el usuario no existe imprime un mensaje indicándolo y lo agrega al grupo
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

#Se cambia la pertenencia del archivo
echo " "
echo "Cambiando pertenencia de $ruta al usuario $usuario y al grupo $grupo..."
cambiar_pertenencia
echo "Pertenencia cambiada"

#Se cambian los permisos del archivo
echo " "
echo "Cambiando permisos de $ruta..."
cambiar_permisos
echo "Permisos cambiados"
