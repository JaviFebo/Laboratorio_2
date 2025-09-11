#!/bin/bash

directorio=$1

monitorear() {
	inotifywait -m -q -e create,delete,modify $directorio
}

monitorear
