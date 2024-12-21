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
if ! date -d "$1/$2/$3" &>/dev/null; then
    echo "Erreur : La date (jour/mois/année) n'est pas valide." >&2
    exit 4
fi

# Vérification de la validité de la deuxième date (date complète)
if ! date -d "$4" &>/dev/null; then
    echo "Erreur : La date complète n'est pas valide. Format attendu : 'jour mois année heures:minutes:secondes'." >&2
    exit 4
fi

echo "Les arguments sont valides."
exit 0