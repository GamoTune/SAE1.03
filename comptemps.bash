#!/bin/bash

# Importation des fonctions de test
source utils.bash

# Vérification du nombre d'arguments
if [ $# -ne 4 ]; then
    echo "Usage : $0 jour mois année 'date complète (ex: \"21 12 2024 15:30:45\")'" >&2
    exit 4
fi

# Vérification du type des arguments jour, mois, année
if ! est_entier_positif "$1" || ! est_entier_positif "$2" || ! est_entier_positif "$3"; then
    echo "Erreur : Les arguments jour, mois et année doivent être des entiers positifs." >&2
    exit 4
fi

# Vérification de la validité de la première date (jour/mois/année)
if ! date -d "$3/$2/$1" &>/dev/null; then
    echo "Erreur : La date (jour/mois/année) n'est pas valide." >&2
    exit 4
fi

# Vérification de la date complète
if ! date -d "$(echo "$DATE_COMPLETE" | awk '{print $3"-"$2"-"$1 " " $4}')" &>/dev/null; then
    echo "Erreur : La date complète doit être valide et au format 'jour mois année heures:minutes:secondes'." >&2
    exit 4
fi



# Déclaration des variables (après controle des arguments)
jour="$1"
mois="$2"
annee="$3"
# Décomposition de la date complète
jourActuel=$(echo "$4" | cut -d ' ' -f 1)
moisActuel=$(echo "$4" | cut -d ' ' -f 2)
anneeActuelle=$(echo "$4" | cut -d ' ' -f 3)


# Si la date saisie est postérieure ou égale à la date actuelle
if [ "$annee" -gt "$anneeActuelle" ] || ([ "$annee" -eq "$anneeActuelle" ] && [ "$mois" -gt "$moisActuel" ]) || ([ "$annee" -eq "$anneeActuelle" ] && [ "$mois" -eq "$moisActuel" ] && [ "$jour" -gt "$jourActuel" ]); then
    exit 0

elif [ "$annee" -eq "$anneeActuelle" ] && [ "$mois" -eq "$moisActuel" ] && [ "$jour" -eq "$jourActuel" ]; then
    exit 0
fi

# Si la date saisie est antérieure à la date courante de plus d'un an
if [ "$annee" -lt "$((anneeActuelle - 1))" ] || ([ "$annee" -eq "$((anneeActuelle - 1))" ] && [ "$mois" -lt "$moisActuel" ]) || ([ "$annee" -eq "$((anneeActuelle - 1))" ] && [ "$mois" -eq "$moisActuel" ] && [ "$jour" -lt "$jourActuel" ]); then
    exit 1
fi


# Si la date saisie est antérieure à la date courante de plus d'un mois et moins d'un an
if [ "$annee" -eq "$anneeActuelle" ] && [ "$mois" -lt "$moisActuel" ] && [ "$mois" -ge "$((moisActuel - 12))" ]; then
    echo "La date saisie est antérieure à la date courante de plus d'un mois et moins d'un an."
    exit 2
fi
