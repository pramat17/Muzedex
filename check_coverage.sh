#!/bin/bash

# Vérification des arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <fichier_cobertura.xml> <seuil_en_pourcentage>"
    exit 1
fi

# Récupérer les paramètres
FILE=$1
THRESHOLD=$2

# Vérifier si le fichier existe
if [ ! -f "$FILE" ]; then
    echo "Fichier $FILE introuvable."
    exit 1
fi

# Extraire le taux de couverture des lignes depuis le fichier Cobertura XML
LINE_RATE=$(xmllint --xpath "string(//coverage/@line-rate)" "$FILE" 2>/dev/null)

# Vérifier si la valeur a pu être extraite
if [ -z "$LINE_RATE" ]; then
    echo "Impossible de lire la couverture dans le fichier $FILE."
    exit 1
fi

# Calculer la couverture en pourcentage
COVERAGE=$(echo "scale=2; $LINE_RATE * 100" | bc)

# Comparer la couverture avec le seuil
echo "Coverage: ${COVERAGE}%"
echo "Threshold: ${THRESHOLD}%"

if (( $(echo "$COVERAGE >= $THRESHOLD" | bc -l) )); then
    echo "Coverage is sufficient (${COVERAGE}%)."
    exit 0
else
    echo "Coverage (${COVERAGE}%) is below threshold (${THRESHOLD}%)."
    exit 1
fi
