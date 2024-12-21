#!/bin/bash

# Importation des fonctions de tests
source utils.bash

# Vérification du nombre d'arguments
if [ $# -ne 2 ]; then
    echo "Usage : $0 nom_adhérent titre_livre" >&2
    exit 1
fi

# Variables
chemin_fichier_membres="membres.csv"
chemain_fichier_livres="livres.csv"
chemain_fichier_exemplaires="exemplaires.csv"

adherant_existe=false
livre_existe=false
num_livre=0
exemplaire_disponible=false
num_exemplaire=0

nom_adherent="$1"
titre_livre="$2"

date_emprunt=$(date '+%-d %-m %Y %X')


# Vérification de l'existence du fichier membres.CSV
if [ ! -f $chemin_fichier_membres ]; then
    echo "Erreur : Le fichier $chemin_fichier_membres n'existe pas." >&2
    exit 1
fi

# Vérification de l'existence du fichier livres.CSV
if [ ! -f $chemain_fichier_livres ]; then
    echo "Erreur : Le fichier $chemain_fichier_livres n'existe pas." >&2
    exit 1
fi

# Vérification de l'existence du fichier exemplaires.CSV
if [ ! -f $chemain_fichier_exemplaires ]; then
    echo "Erreur : Le fichier $chemain_fichier_exemplaires n'existe pas." >&2
    exit 1
fi

# Vérification que l'adhérent est inscrit
while IFS=',' read -r numero fichier_nom fichier_prenom fichier_ville; do
    if [[ "$fichier_nom" == "$nom_adherent" ]]; then
        adherant_existe=true
    fi
done < "$chemin_fichier_membres"

if [ "$adherant_existe" = false ]; then
    echo "Erreur : $nom_adherent n'est pas inscrit à la bibliothèque."
    exit 2
fi

# Vérification que le livre existe et récupération du numéro du livre
while IFS=',' read -r numero fichier_titre fichier_auteur; do
    if [[ "$fichier_titre" == "$titre_livre" ]]; then
        livre_existe=true
        num_livre=$numero
    fi
done < "$chemain_fichier_livres"

if [ "$livre_existe" = false ]; then
    echo "Erreur : Le livre $titre_livre n'existe pas dans la bibliothèque."
    exit 2
fi

# Recherche d'un exemplaire disponible
num_exemplaire=$(grep "$num_livre" "$chemain_fichier_exemplaires" | grep "oui" | head -n 1 | cut -d ',' -f 2)
if ! est_entier_positif "$num_exemplaire"; then
    echo "Erreur : Aucun exemplaire disponible pour le livre $titre_livre."
    exit 2
fi

# Emprunt de l'exemplaire
echo "Emprunt de l'exemplaire $num_exemplaire du livre $titre_livre par $nom_adherent le $date_emprunt."

# Mise à jour de l'état de l'exemplaire
sed -i "s/$num_livre,$num_exemplaire,oui/$num_livre,$num_exemplaire,non/" "$chemain_fichier_exemplaires"

# Ajout de l'emprunt dans le fichier emprunts.csv
echo "$num_livre,$num_exemplaire,$nom_adherent,$date_emprunt" >> emprunts.csv

exit 0