#!/bin/bash

# Importation des fonctions de test
source utils.bash

verification_date(){
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
    if ! date -d "$3-$2-$1" &>/dev/null; then
        echo "Erreur : La date (jour/mois/année) n'est pas valide." >&2
        exit 4
    fi

    # Vérification de la date complète
    DATE_COMPLETE="$4"
    if ! date -d "$(echo "$DATE_COMPLETE" | awk '{print $3"-"$2"-"$1 " " $4}')" &>/dev/null; then
        echo "Erreur : La date complète doit être valide et au format 'jour mois année heures:minutes:secondes'." >&2
        exit 4
    fi

    # Date d'emprunt (passée en argument)
    dateEmp=$(date -d "$3-$2-$1" +%Y%m%d)
    
    dateActu=$(date -d "$(echo "$DATE_COMPLETE" | awk '{print $3"-"$2"-"$1 " " $4}')")

    # Extraction des années et des mois pour les calculs
    anneeActuel=$(date -d "$dateActu" "+%Y")
    anneeEmprunt=$(date -d "$dateEmp" "+%Y")
    moisActuel=$(date -d "$dateActu" "+%m")
    moisEmprunt=$(date -d "$dateEmp" "+%m")

    # Calcul de la différence d'années et de mois
    diff_annee=$((anneeActuel - anneeEmprunt))

    #Teste si la date d'emprunt est dans le futur
    if [ "$diff_annee" -lt 0 ]; then
        exit 0
    
    #Teste si la date d'emprunt est dans le passé
    elif [ "$diff_annee" -gt 0 ]; then
        diff_mois=$(( (12 - moisEmprunt) + moisActuel + (diff_annee - 1) * 12 ))
        # Le livre a été emprunté il y a $diff_mois mois.
        if [ "$diff_mois" -ge 12 ]; then
            # Le livre a été emprunté il y a plus d'un an.
            exit 1
        elif [ "$diff_mois" -gt 1 ]; then
            # Le livre a été emprunté il y plus d'un mois et moins d'un an.
            exit 2
        else
            # Le livre a été emprunté il y a moins d'un mois.
            exit 3

        fi
    else
        diff_mois=$((moisActuel - moisEmprunt))

        #Test si le livre a été emprunté dans le future
        if [ "$diff_mois" -lt 0 ]; then
            exit 0

        #Test si le livre a été emprunté ce mois-ci
        elif [ "$diff_mois" -eq 0 ]; then
            # Le livre a été emprunté il y a moins d'un mois.
            exit 3

        #Test si le livre a été emprunté il y a plus d'un mois
        else
            # Le livre a été emprunté il y a plus d'un mois et moins d'un an.
            exit 2
        fi
    fi
}