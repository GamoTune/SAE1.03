#!/bin/bash

# Importation des fonctions de test
source utils.sh


# Vérification du nombre d'arguments
if [ $# -ne 4 ]; then
    echo "Usage : $0 jour mois année heures:minutes:secondes" >&2
    exit 4
fi

# Vérification du type des arguments
if ! est_entier_positif "$1" || ! est_entier_positif "$2" || ! est_entier_positif "$3"; then
    echo "Erreur : Les arguments jour, mois et année doivent être des entiers positifs." >&2
    exit 4
fi

if [ wc -m "$4" -ne 8 ]; then
    echo "Erreur : L'argument heures:minutes:secondes doit être au format HH:MM:SS." >&2
    exit 4
fi

if [ wc -m "$1" -ne 2 ] || [ wc -m "$2" -ne 2 ] || [ wc -m "$3" -ne 4]; then
    echo "Erreur : Les arguments jour, mois et année doivent être au format JJ, MM et AAAA." >&2
    exit 4
fi


# Déclaration des variables (après controle des arguments)
jour="$1"
mois="$2"
annee="$3"
heure= cut -d ':' -f 1 "$4"
minute= cut -d ':' -f 2 "$4"
seconde= cut -d ':' -f 3 "$4"

if ! est_entier_positif "$heure" || ! est_entier_positif "$minute" || ! est_entier_positif "$seconde"; then
    echo "Erreur : Les arguments heures, minutes et secondes doivent être des entiers positifs." >&2
    exit 4
fi

if [ "$heure" -ge 24 ] || [ "$minute" -ge 60 ] || [ "$seconde" -ge 60 ]; then
    echo "Erreur : Les arguments heures, minutes et secondes doivent être inférieurs à 24, 60 et 60 respectivement." >&2
    exit 4
fi

dateActuelle=$(date '+%Y-%m-%d %H:%M:%S') # Date actuelle au format AAAA-MM-JJ HH:MM:SS
dateSaisie="$annee-$mois-$jour $heure:$minute:$seconde" # Date saisie au format AAAA-MM-JJ HH:MM:SS

jourActuel= cut -d '-' -f 3 "$dateActuelle"
moisActuel= cut -d '-' -f 2 "$dateActuelle"
anneeActuelle= cut -d '-' -f 1 "$dateActuelle"


# Vérification de la validité de la date saisie
if [ date -d "$dateSaisie" 2>/dev/null ]; then
    echo "Erreur : La date saisie est invalide." >&2
    exit 4
fi

# Si la date saisie est postérieure ou égale à la date actuelle
if [ ]


# Si la date saisie est antérieure à la date actuelle de plus d'un an
