#!/bin/bash

PIDFILE="/var/run/monitor_central.pid"

if [ ! -f "$PIDFILE" ]; then
    echo "Monitor não está rodando (PID file não encontrado)"
    
    # Tentar encontrar processo manualmente
    PID=$(ps aux | grep "monitor_central.sh" | grep -v grep | awk '{print $2}' | head -1)
    if [ -n "$PID" ]; then
        echo "Encontrado processo órfão (PID: $PID), matando..."
        kill $PID 2>/dev/null
        sleep 1
        kill -9 $PID 2>/dev/null
        echo "✓ Processo parado"
    fi
    exit 0
fi

PID=$(cat "$PIDFILE")

if ! ps -p $PID > /dev/null 2>&1; then
    echo "Monitor não está rodando (PID $PID não existe)"
    rm -f "$PIDFILE"
    exit 0
fi

echo "Parando monitor (PID: $PID)..."
kill $PID 2>/dev/null
sleep 2

if ps -p $PID > /dev/null 2>&1; then
    echo "Forçando parada..."
    kill -9 $PID 2>/dev/null
fi

rm -f "$PIDFILE"
echo "✓ Monitor parado"
