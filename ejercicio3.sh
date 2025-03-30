#!/bin/bash

DIRECTORIO=/home/juanpmr/directorio_monitoreado
LOG=/home/juanpamr/cambios.log

touch "$LOG"

echo "Monitoreando cambios en $DIRECTORIO..."

while true; do
	inotifywait -e create -e modify -e delete --format '%T %w %e %f' --timefmt '%Y-%m-%d %H:%M:%S' "$DIRECTORIO" | while read FECHA RUTA EVENTO ARCHIVO; do
	echo "[$FECHA] Evento: $EVENTO en archivo: $ARCHIVO" >> "$LOG"
   done
done 


