#!/bin/bash

read -p "Escreva o caminho do diretório que deseja verificar: " dir

if [ ! -d "$dir" ]; then
    echo "Erro: diretório não encontrado."
    exit 1
fi

permissoes=$(ls -l "$dir")

if [ ! -r "$dir" ] || [ ! -w "$dir" ] || [ ! -x "$dir" ]; then
    echo
    echo "[AVISO] Permissões insuficientes"
fi

echo

uso=$(df "$dir" | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$uso" -gt 90 ]; then
    echo "Uso da partição raiz: $uso% — [CRÍTICO]"
elif [ "$uso" -gt 70 ]; then
    echo "Uso da partição raiz: $uso% — [ALERTA]"
else
    echo "Uso da partição raiz: $uso% — [OK]"
fi

echo

lista=$(ps -u $USER --sort=-%mem | head -6 | tail -5)

echo "$lista" | while read linha; do
    pid=$(echo $linha | awk '{print $1}')
    comando=$(echo $linha | awk '{print $NF}')
    echo "PID: $pid  |  Comando: $comando"
done

