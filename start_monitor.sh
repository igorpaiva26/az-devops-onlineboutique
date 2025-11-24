#!/bin/bash

SCRIPT="/home/infra/monitor_central.sh"
LOG="/var/log/monitor_central.log"
PIDFILE="/var/run/monitor_central.pid"

# Verificar se já está rodando
if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "Monitor já está rodando (PID: $PID)"
        exit 1
    else
        echo "Removendo PID antigo..."
        rm -f "$PIDFILE"
    fi
fi

# Iniciar o monitor
echo "Iniciando monitor..."
nohup bash "$SCRIPT" > "$LOG" 2>&1 &
PID=$!
echo $PID > "$PIDFILE"

sleep 2

if ps -p $PID > /dev/null 2>&1; then
    echo "✓ Monitor iniciado com sucesso (PID: $PID)"
    echo "  Logs: tail -f $LOG"
else
    echo "✗ Erro ao iniciar monitor"
    rm -f "$PIDFILE"
    exit 1
fi
