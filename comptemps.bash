#!/bin/bash

# Importation des fonctions de test
source utils.bash

verification_date(){
    # Vérification du nombre d'arguments
    if [ $# -ne 4 ]; then
        echo "Usage : $0 jourEmprunt moisEmprunt année 'date complète (ex: \"21 12 2024 15:30:45\")'" >&2
        exit 4
    fi

    # Vérification du type des arguments jourEmprunt, moisEmprunt, année
    if ! est_entier_positif "$1" || ! est_entier_positif "$2" || ! est_entier_positif "$3"; then
        echo "Erreur : Les arguments jourEmprunt, moisEmprunt et année doivent être des entiers positifs." >&2
        exit 4
    fi

    # Vérification de la validité de la première date (jourEmprunt/moisEmprunt/année)
    if ! date -d "$3-$2-$1" &>/dev/null; then
        echo "Erreur : La date (jourEmprunt/moisEmprunt/année) n'est pas valide." >&2
        exit 4
    fi

    # Vérification de la date complète
    DATE_COMPLETE="$4"
    if ! date -d "$(echo "$DATE_COMPLETE" | awk '{print $3"-"$2"-"$1 " " $4}')" &>/dev/null; then
        echo "Erreur : La date complète doit être valide et au format 'jourEmprunt moisEmprunt année heures:minutes:secondes'." >&2
        exit 4
    fi

    # Date d'emprunt (passée en argument)
    dateEmp=$(date -d "$3-$2-$1" +%Y%m%d)
    
    dateActu=$(date -d "$(echo "$DATE_COMPLETE" | awk '{print $3"-"$2"-"$1 " " $4}')")

    # Extraction des années et des moisEmprunt pour les calculs
    anneeActuel=$(date -d "$dateActu" "+%Y")
    anneeEmprunt=$(date -d "$dateEmp" "+%Y")
    moisActuel=$(date -d "$dateActu" "+%m")
    moisEmprunt=$(date -d "$dateEmp" "+%m")
    jourActuel=$(date -d "$dateActu" "+%d")
    jourEmprunt=$(date -d "$dateEmp" "+%d")


    # Si la date est la même que la date courante
    if [[ $jourEmprunt -eq $jourActuel && $moisEmprunt -eq $moisActuel && $anneeEmprunt -eq $anneeActuel ]]; then
        # echo "La date saisie est la même que la date courante"
        exit 0
    fi

    # Si la date est postérieure à la date courante
    if [ $anneeEmprunt -gt $anneeActuel ] || [ $anneeEmprunt -eq $anneeActuel -a $moisEmprunt -gt $moisActuel ] || [ $anneeEmprunt -eq $anneeActuel -a $moisEmprunt -eq $moisActuel -a $jourEmprunt -gt $jourActuel ]; then 
        # echo "La date saisie est postérieure à la date courante"
        exit 0
    fi

    # Si la date est antérieure à la date courante de plus d'un an
    if [ $anneeEmprunt -lt $anneeActuel ] && { [ $jourEmprunt -gt $jourActuel ] || [ $moisEmprunt -gt $moisActuel ]; }; then 
        # echo "La date saisie est antérieure à la date courante de plus d'un an"
        exit 1
    fi

    # Si la date est antérieure à la date courante de plus d'un moisEmprunt mais moins d'un an
    if [[ $anneeEmprunt -eq $anneeActuel && $moisEmprunt -gt $moisActuel ]] || [[ $anneeEmprunt -eq $anneeActuel && $moisEmprunt -eq $moisActuel && $jourEmprunt -gt $jourActuel ]]; then
        # echo "La date saisie est antérieure de plus de 1 moisEmprunt mais moins d'un an"
        exit 2
    fi

    # Si la date est antérieure à la date courante de moins d'un moisEmprunt
    if [[ $anneeEmprunt -eq $anneeActuel && $moisEmprunt -lt $moisActuel ]] || [[ $anneeEmprunt -eq $anneeActuel && $moisEmprunt -eq $moisActuel && $jourEmprunt -lt $jourActuel ]]; then 
        # echo "la date saisie est antérieure à la date courante de moins d'un moisEmprunt"
        exit 3
    fi

}