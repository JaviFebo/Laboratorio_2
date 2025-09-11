#!/bin/bash

directorio="/home/javier-b/Laboratorios/Archivos"
archivo_log="log_notify.txt"

#Función que monitorea la creación, eliminación y modificación de archivos en el directorio indicado
monitorear() {
	inotifywait -m -q -e create,delete,modify "$directorio"
}

#Función que añade la fecha y hora a cada línea que se le pasa
registrar_tiempo() {
	while read -r evento; do
    		fecha=$(date '+%Y-%m-%d %H:%M:%S')
    		echo "$evento" | awk -v d="$fecha" '{ print d, $0 }'
	done
}

monitorear | registrar_tiempo >> "$archivo_log" #Se pasa el mensaje de monitoreo a la función de registro de tiempo y se concatena en el archivo de log
