#!/bin/bash

directorio="/home/javier-b/Laboratorios/Archivos"
archivo_log="log_notify.txt"

monitorear() {
	inotifywait -m -q -e create,delete,modify "$directorio"
}

registrar_tiempo() {
	while read -r evento; do
    		fecha=$(date '+%Y-%m-%d %H:%M:%S')
    		echo "$evento" | awk -v d="$fecha" '{ print d, $0 }'
	done
}

monitorear | registrar_tiempo >> "$archivo_log"
