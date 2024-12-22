#!/bin/bash

# Importation des fonctions de test
source utils.bash
source comptemps.bash


# Vérification du nombre d'arguments
if [ $# -ne 0 ]; then
    echo "Usage : $0" >&2
    exit 1
fi

# Déclaration des variables
dateActuelle=$(date '+%-d %-m %Y %X')
chemin_fichier_emprunts="emprunts.csv"

# Parcours du fichier emprunts.csv
while IFS=',' read -r num_membre num_livre num_exemplaire date_emprint
do
    # Vérification que l'emprunt date d'il y a plus d'un mois
    if [ verification_date "$date_emprint" "$dateActuelle" -eq 1 ] || [ verification_date "$date_emprint" "$dateActuelle" -eq 2 ]; then
        echo "$num_membre,$num_livre,$num_exemplaire,$date_emprint"
    fi
done < "$chemin_fichier_emprunts"