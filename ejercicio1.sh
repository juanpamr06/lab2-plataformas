#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Este script debe ejecutarse como root."
	exit 1
fi

if [ $# -ne 3 ]; then
	echo "Uso: $0 <usuario> <grupo> <ruta_al_archivo>"
	exit 1
fi

USUARIO=$1
GRUPO=$2
ARCHIVO=$3

if [ ! -f "$ARCHIVO" ]; then
	echo "El archivo $ARCHIVO no existe."
	exit 1
else
	echo "El archivo $ARCHIVO si existe."
fi

if grep -q  "^$GRUPO:" /etc/group; then
	echo "El grupo '$GRUPO' ya existe."
else
	echo "Creando el grupo '$GRUPO'..."
	addgroup "$GRUPO"
fi

if id "$USUARIO" &>/dev/null; then
	echo "El usuario '$USUARIO' ya existe."
else
	echo "Creando el usuario '$USUARIO'..."
        adduser "$USUARIO"
        echo "Agregando el usuario '$USUARIO' al grupo '$GRUPO'..."
        usermod -aG "$GRUPO" "$USUARIO"
fi

chown "$USUARIO":"$GRUPO" "$ARCHIVO"
echo "Se cambio la propiedad del archivo a $USUARIO:$GRUPO"
chmod 740 "$ARCHIVO"
echo "Se cambiaron los permisos del archivo."

