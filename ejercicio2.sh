#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Uso: $0 <comando_a_ejecutar>"
	exit 1
fi

$@ &
PID=$!
echo "Proceso iniciado con PID $PID"

LOG="reporte_proceso.log"
echo "Tiempo,CPU,MEM" > "$LOG"

while ps -p $PID > /dev/null; do
	TIEMPO=$(date +%H:%M:%S)
	CPU=$(ps -p  $PID -o %cpu --no-headers)
	MEM=$(ps -p  $PID -o %mem --no-headers)
	echo "$TIEMPO,$CPU,$MEM" >> "$LOG"
	sleep 1
done

GNUPLOT_SCRIPT="grafica.gnuplot"

echo "set datafile separator ','" > "$GNUPLOT_SCRIPT"
echo "set terminal png" >> "$GNUPLOT_SCRIPT"
echo "set output 'grafico.png'" >> "$GNUPLOT_SCRIPT"
echo "set title 'Uso de CPU y MEMORIA'" >> "$GNUPLOT_SCRIPT"
echo "set xlabel 'Tiempo'" >> "$GNUPLOT_SCRIPT"
echo "set ylabel '% de uso'" >> "$GNUPLOT_SCRIPT"
echo "set xdata time" >> "$GNUPLOT_SCRIPT"
echo "set timefmt '%H:%M:%S'" >> "$GNUPLOT_SCRIPT"
echo "set format x '%H:%M:%S'" >> "$GNUPLOT_SCRIPT"
echo "plot 'reporte_proceso.log' using 1:2 with lines title 'CPU', '' using 1:3 with lines title 'MEM'" >> "$GNUPLOT_SCRIPT"
gnuplot "$GNUPLOT_SCRIPT"
