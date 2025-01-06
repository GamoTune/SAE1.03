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
    if ! date -d "$3/$2/$1" &>/dev/null; then
        echo "Erreur : La date (jour/mois/année) n'est pas valide." >&2
        exit 4
    fi

    # Vérification de la date complète
    if ! date -d "$(echo "$DATE_COMPLETE" | awk '{print $3"-"$2"-"$1 " " $4}')" &>/dev/null; then
        echo "Erreur : La date complète doit être valide et au format 'jour mois année heures:minutes:secondes'." >&2
        exit 4
    fi
}

#date du jour
date1=$(date +%Y%m%d)
#date d'emprunt
date2=$(date --date='2023/11/01' +%Y%m%d)
echo $date1
echo $date2

y1=$(date "+%Y" --date=$date1)
y2=$(date "+%Y" --date=$date2)
m1=$(date "+%m" --date=$date1)
m2=$(date "+%m" --date=$date2)

echo $y1 $m1 $d1
echo $y2 $m2 $d2

#calcul de la difference entre la date du jour et la date d'emprunt
# -si la diff est negative, le retour est en retard
# -si la diff est positive, il reste du temps d'emprunt
let diff_y=$(expr "$y1-$y2")

echo $diff_y
echo $diff_m

if [ "$diff_y" -lt 0 ] #negatif, le livre à été emprunté l'année prochaine : erreur dans les dates
then
    exit
elif [ "$diff_y" -gt 0 ] #positif positif, le livre à été emprunté l'an dernier ou encore plus tard)
then
    diff_m=$(( 12-m2+m1+(diff_y-1)*12))
    echo "le livre à été emprumté il y a $diff_m mois"

elif [ "$diff_y" -eq 0 ] #zero, le livre à été emprunté cette année
then
    $diff_m=$m1-$m2
    if [ "$diff_m" -lt 0 ]
    then
        echo "diff_m négatif : le livre à été emprunté le mois prochain : erreur dans les dates"
        exit
    elif [ "$diff_m" -eq 0 ]
    then
        echo "diff_m=0 : livre à été emprunté ce mois ci"
    elif [ "$diff_m" -gt 0 ]
    then
        echo "diff_m positif : livre à été emprunté il y a $diff_m mois"
    fi
fi
