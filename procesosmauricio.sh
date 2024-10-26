#!/bin/bash

#2-ASIR Mauricio Gustavo Moletta Hernandez
# Función para mostrar el menú principal
mostrar_menu() {
  echo "==============================="
  echo "     Menú de Gestión de Procesos"
  echo "==============================="
  echo "1. Listar todos los procesos activos"
  echo "2. Ejecutamos un proceso sleep en segundo plano (tiempo a elegir)"
  echo "3. Buscar un proceso por nombre"
  echo "4. Mostrar uso de CPU y memoria de un proceso"
  echo "5. Terminar un proceso"
  echo "6. Guardar log de todos los procesos activos"
  echo "7. Salir"
  echo "==============================="
}

# Función para listar todos los procesos activos
listar_procesos() {
clear
  echo "Listando todos los procesos activos..."
  ps -l
}

#Funcion para ejectar un proceso en segundo plano
proceso_sleep() {
clear
 read -p "Introduce el tiempo que quieres que se ejecute sleep: " tiempo_proceso
 echo "ejecutando el proceso '$nombre_proceso1'..."
 sleep $tiempo_proceso &
 jobs -l
}


# Función para buscar un proceso por nombre
# Listamos con ps -l, con grep -w buscamos la palabra exacta que le demos
buscar_proceso() {
clear
  read -p "Introduce el nombre del proceso a buscar: " nombre_proceso
  echo "Buscando procesos con nombre '$nombre_proceso'..."
  resultado=$(ps -l| grep -w "$nombre_proceso")

#verificamos si el resultado esta vacio (es decir si existe ese proceso) de lo contrario enviamos mensaje de error

if [ -z "$resultado" ]; then
	echo "Proceso '$nombre_proceso' no encontrado."
else
	echo "$resultado"
fi
}

# Función para mostrar uso de CPU y memoria de un proceso
mostrar_uso() {
  read -p "Introduce el ID del proceso (PID): " pid
  echo "Mostrando uso de CPU y memoria para el proceso con PID $pid..."
  ps -p $pid -o %cpu,%mem,cmd
}

# Función para terminar un proceso
terminar_proceso() {
  read -p "Introduce el ID del proceso (PID) a terminar: " pid
  echo "Terminando el proceso con PID $pid..."
  kill -9 $pid
}

# Función para guardar log de procesos activos en un archivo
# El ps aux nos enseña los procesos de todos los usuarios, muestra info orientada al usuario con -u y -x los procesos que no estan vinculados al terminal
# Luego basicamente Creamos un archivo unico usando la fecha y hora actual, mensaje de que se guarda, guardamos el resultado del comando ps aux dentro de
# $archivo. este mismo archivo se guarda en donde ejecutemos el script.
guardar_log() {
clear
  archivo="log_procesos_$(date +%d%m%Y_%H%M%S).txt"
  echo "Guardando log de procesos activos en $archivo..."
  ps aux > $archivo
  echo "Log guardado en $archivo"
}

# Bucle principal del menú, tambien hay una verificacion con el if para que si insertamos un valor que no sea entero
# nos muestre de igual forma un mensaje de error (sino el script espera un valor si o si entero y si por ejemplo
# definimos un valor (a,b,c,etc...) se cierra el bucle avisando que debe de ser entero. Con esta verificacion no sucede eso.
opcion=0
while [ "$opcion" -ne 7 ]; do
  mostrar_menu
  read -p "Elige una opción [1-7]: " opcion
  if [[ "$opcion" =~ ^[0-9]+$ ]]; then
case $opcion in
    1) listar_procesos ;;
    2) proceso_sleep ;;
    3) buscar_proceso ;;
    4) mostrar_uso ;;
    5) terminar_proceso ;;
    6) guardar_log ;;
    7) echo "Saliendo del programa..." ;;
    *) echo "Opción no válida, por favor elige una opción del 1 al 7." ;;
  esac
else
	opcion=0
	echo "Error: Por favor introduce un valor numerico válido"
fi
done
