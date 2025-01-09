#!/bin/bash

#Importation des fonctions de tests
source utils.bash

if [ $# -ne 2 ]; then
    echo "Usage : $0 nom_adhérent titre_livre" >&2
    exit 1
fi

nom_adherent=$1
titre_livre=$2

fichier_membres="membres.csv"
fichier_emprunts="emprunts.csv"
fichier_livres="livres.csv"
fichier_exemplaires="exemplaires.csv"

adherant_existe=false
livre_existe=false
emprunt_en_cours=false
num_livre=""


# Vérification de l'existence du fichier membres.CSV
if [ ! -f $fichier_membres ]; then
    echo "Erreur : Le fichier $fichier_membres n'existe pas." >&2
    exit 1
fi


# Vérification de l'existence du fichier livres.CSV
if [ ! -f $fichier_livres ]; then
    echo "Erreur : Le fichier $fichier_livres n'existe pas." >&2
    exit 1
fi


# Vérification de l'existence du fichier exemplaires.CSV
if [ ! -f $fichier_exemplaires ]; then
    echo "Erreur : Le fichier $fichier_exemplaires n'existe pas." >&2
    exit 1
fi


# Vérification que l'adhérent est inscrit
while IFS=',' read -r numero nom prenom ville; do
    if [[ "$nom" == "$nom_adherent" ]]; then
        adherant_existe=true
    fi
done < "$fichier_membres"

if [ "$adherant_existe" = false ]; then
    echo "Erreur : $nom_adherent n'est pas inscrit à la bibliothèque."
    exit 2
fi


# Vérification que le livre existe et récupération du numéro du livre
while IFS=',' read -r numero titre auteur; do
    if [[ "$titre" == "$titre_livre" ]]; then
        livre_existe=true
        num_livre=$numero
    fi
done < "$fichier_livres"

if [ "$livre_existe" = false ]; then
    echo "Erreur : Le livre $titre_livre n'existe pas dans la bibliothèque."
    exit 2
fi

# Vérification de l'emprunt en cours
while IFS=',' read -r livre exemplaire adherent date_emprunt; do
    if [[ "$adherent" == "$nom_adherent" && "$livre" == "$num_livre" ]]; then
        emprunt_en_cours=true
        num_exemplaire=$exemplaire
    fi
done < "$fichier_emprunts"

if [ "$emprunt_en_cours" = false ]; then
    echo "Erreur : Aucun emprunt trouvé pour $nom_adherent et le livre $titre_livre."
    exit 3
fi

# Supprimer l'emprunt du fichier emprunts.csv
sed -i "/$num_livre,$num_exemplaire,$nom_adherent/d" "$fichier_emprunts"

# Mettre à jour le fichier exemplaires.csv pour rendre l'exemplaire disponible
sed -i "s/$num_livre,$num_exemplaire,non/$num_livre,$num_exemplaire,oui/" "$fichier_exemplaires"

echo "Le livre $titre_livre (exemplaire $num_exemplaire) a été rendu avec succès par $nom_adherent."