#!/bin/bash

#Todos los parámetros del script se guardan como el comando para iniciar el proceso
proceso=$@

#Función que revisa si el proceso existe
proceso_existe() {
	command -v $proceso >/dev/null
}

#Función que imprime el consumo de cpu del proceso
cpu_proceso() {
	ps -o %cpu -p $id_proceso | tail -n +2
}

#Función que imprime el consumo de memoria del proceso
mem_proceso() {
	ps -o %mem -p $id_proceso | tail -n +2
}

#Función que revisa si el proceso sigue corriendo
proceso_corriendo() {
	ps -p $id_proceso > /dev/null	
}

#Función que que grafica los datos de consumo de cpu en el archivo de log
graficar_cpu() {
	gnuplot -persist <<-EOF
    		set terminal qt
    		set xdata time
    		set timefmt '%H:%M:%S
    		set format x '%H:%M:%S'
    		plot 'log_cpu.txt' using 1:2 with lines title 'CPU'
	EOF
}

#Función que grafica los datos de consumo de memoria en el archivo de log
graficar_mem() {
	gnuplot -persist <<-EOF
    		set terminal qt
    		set xdata time
    		set timefmt '%H:%M:%S
    		set format x '%H:%M:%S'
    		plot 'log_mem.txt' using 1:2 with lines title 'MEM'
	EOF

}

#Si no se ingresa ningún parámetro el script termina
if [ $# -eq 0 ]; then
	echo "Error: ingrese un proceso"
	exit 1
fi

#Si el proceso ingresado no existe el script termina
if ! proceso_existe; then
	echo "Error: proceso inválido"
	exit 1
fi

$proceso & #El proceso se inicia en background
id_proceso=$! #Se guarda la id del último proceso en background iniciado

> log_cpu.txt #Se vacía el archivo de log de consumo de cpu
> log_mem.txt #Se vacía el archivo de log de consumo de memoria

#Inicia un while loop que corre mientras el proceso esté activo
while proceso_corriendo; do
	echo "$(date '+%H:%M:%S') $(cpu_proceso)" >> log_cpu.txt #Guarda la hora y el consumo de cpu del proceso en el archivo log_cpu.txt
        echo "$(date '+%H:%M:%S') $(mem_proceso)" >> log_mem.txt #Guarda la hora y el consumo de cpu del proceso en el archivo log_cpu.txt
	sleep 1
done

graficar_cpu
graficar_mem
