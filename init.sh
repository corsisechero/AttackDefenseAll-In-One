#!/bin/bash

echo "Preparazione del laboratorio..."

# Verifica che Docker sia installato
if ! command -v docker &> /dev/null
then
    echo "Docker non trovato, installalo prima di procedere."
    exit 1
fi

# Verifica che Docker Compose sia installato
if ! docker compose version &> /dev/null
then
    echo "Docker Compose non trovato, installalo prima di procedere."
    exit 1
fi

echo "Avvio del laboratorio..."
sudo docker compose up -d

echo "Laboratorio pronto!"
