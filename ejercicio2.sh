#!/bin/bash

proceso=$@

proceso_existe() {
	command -v $proceso >/dev/null
}

cpu_proceso() {
	ps -o %cpu -p $id_proceso | tail -n +2
}

mem_proceso() {
	ps -o %mem -p $id_proceso | tail -n +2
}

proceso_corriendo() {
	ps -p $id_proceso > /dev/null	
}

graficar_cpu() {
	gnuplot -persist <<-EOF
    		set terminal qt
    		set xdata time
    		set timefmt '%H:%M:%S
    		set format x '%H:%M:%S'
    		plot 'log_cpu.txt' using 1:2 with lines title 'CPU'
	EOF
}

graficar_mem() {
	gnuplot -persist <<-EOF
    		set terminal qt
    		set xdata time
    		set timefmt '%H:%M:%S
    		set format x '%H:%M:%S'
    		plot 'log_mem.txt' using 1:2 with lines title 'MEM'
	EOF

}


if [ $# -eq 0 ]; then
	echo "Error: ingrese un proceso"
	exit 1
fi

if ! proceso_existe; then
	echo "Error: proceso inválido"
	exit 1
fi

$proceso &
id_proceso=$!

> log_cpu.txt
> log_mem.txt

while proceso_corriendo; do
	echo "$(date '+%H:%M:%S') $(cpu_proceso)" >> log_cpu.txt
        echo "$(date '+%H:%M:%S') $(mem_proceso)" >> log_mem.txt
	sleep 1
done

graficar_cpu
graficar_mem
