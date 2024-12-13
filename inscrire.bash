#!/bin/bash

# Fichiers de données
MEMBRES_FILE="membres"
LIVRES_FILE="livres"
EXEMPLAIRES_FILE="exemplaires"

# Fonction pour ajouter un nouvel adhérent
ajouter_adherent() {
    local nom="$1"
    local prenom="$2"
    local adresse="$3"

    # Récupérer le dernier numéro de membre
    if [ -s "$MEMBRES_FILE" ]; then
        dernier_num=$(tail -n 1 "$MEMBRES_FILE" | cut -d';' -f1)
    else
        dernier_num=0
    fi

    # Calculer le nouveau numéro
    nouveau_num=$((dernier_num + 1))

    # Ajouter l'adhérent dans le fichier
    echo "$nouveau_num;$nom;$prenom;$adresse" >> "$MEMBRES_FILE"
    echo "Adhérent ajouté : $nouveau_num - $nom $prenom à $adresse"
}

# Fonction pour ajouter un nouveau livre et ses exemplaires
ajouter_livre() {
    local nb_exemplaires="$1"
    local titre="$2"
    local auteur="$3"

    # Récupérer le dernier numéro de livre
    if [ -s "$LIVRES_FILE" ]; then
        dernier_num=$(tail -n 1 "$LIVRES_FILE" | cut -d';' -f1)
    else
        dernier_num=0
    fi

    # Calculer le nouveau numéro
    nouveau_num=$((dernier_num + 1))

    # Ajouter le livre dans le fichier
    echo "$nouveau_num;$titre;$auteur" >> "$LIVRES_FILE"
    echo "Livre ajouté : $nouveau_num - \"$titre\" par $auteur"

    # Ajouter les exemplaires dans le fichier
    for ((i=1; i<=nb_exemplaires; i++)); do
        echo "$nouveau_num;$i;oui" >> "$EXEMPLAIRES_FILE"
    done
    echo "$nb_exemplaires exemplaire(s) ajouté(s) pour le livre \"$titre\"."
}

# Analyse des options
while getopts "a:I:" opt; do
    case $opt in
        a)
            # Ajouter un adhérent
            if [ "$#" -ne 4 ]; then
                echo "Usage : $0 -a <nom> <prenom> <adresse>"
                exit 1
            fi
            ajouter_adherent "$2" "$3" "$4"
            ;;
        l)
            # Ajouter un livre
            if [ "$#" -ne 4 ]; then
                echo "Usage : $0 -l <nombre_exemplaires> <titre> <auteur>"
                exit 1
            fi
            ajouter_livre "$2" "$3" "$4"
            ;;
        *)
            echo "Options invalides. Utilisez -a pour ajouter un adhérent ou -l pour ajouter un livre."
            exit 1
            ;;
    esac
done