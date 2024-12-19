#!/bin/bash

#Importation des fonctions de tests
source utils.sh

#Fonction pour ajouter un adhérent
ajout_adherent() {
    local nom="$1"
    local prenom="$2"
    local ville="$3"

    local numero_adherent
    local dernier_numero_adherent

    local chemin_fichier_membres="membres.csv"


    #Vérification des arguments
    if est_entier_positif "$nom" || est_entier_positif "$prenom" || est_entier_positif "$ville"; then
        echo "Erreur : Les arguments nom, prenom et ville doivent être des chaînes de caractères." >&2
        exit 1
    fi


    #Vérification de l'existence du fichier membres.CSV
    if [ ! -f $chemin_fichier_membres ]; then
        echo "Erreur : Le fichier $chemin_fichier_membres n'existe pas." >&2
        exit 1
    fi


    #Vérification que la personne n'est pas déjà inscrite
    while IFS=',' read -r numero fichier_nom fichier_prenom fichier_ville; do
        if [[ "$fichier_nom" == "$nom" && "$fichier_prenom" == "$prenom" && "$fichier_ville" == "$ville" ]]; then
            echo "Erreur : $nom $prenom est déjà inscrit à la bibliothèque."
            exit 2
        fi
    done < "$chemin_fichier_membres"

    #Récupération du dernier numéro d'adhérent
    dernier_numero_adherent=$(tail -n 1 $chemin_fichier_membres | cut -d ',' -f 1)

    #Vérification de l'existence du dernier numéro d'adhérent
    if [ -z "$dernier_numero_adherent" ]; then
        dernier_numero_adherent=0
    fi

    #Calcul du numéro d'adhérent
    numero_adherent=$((dernier_numero_adherent + 1))

    #Affichage des informations
    echo "Ajout de l'adhérent :"
    echo "Numéro d'adhérent : $numero_adherent"
    echo "Nom : $nom"
    echo "Prénom : $prenom"
    echo "Ville : $ville"

    # Ajout dans un fichier CSV
    echo "$((dernier_numero_adherent + 1)),$nom,$prenom,$ville" >> $chemin_fichier_membres
    echo "Adhérent ajouté avec succès dans $chemin_fichier_membres."
}





# Fonction pour ajouter un livre
ajout_livre() {
    local nombre_exemplaires="$1"
    local titre="$2"
    local auteur="$3"

    local numero_livre
    local dernier_numero_livre

    local chemain_fichier_livres="livres.csv"
    local chemain_fichier_exemplaires="exemplaires.csv"


    #Vérification des arguments
    if ! est_entier_positif "$nombre_exemplaires"; then
        echo "Erreur : Le nombre d'exemplaires doit être un entier positif." >&2
        exit 1
    fi


    #Vérification de l'existence du fichier livres.CSV
    if [ ! -f $chemain_fichier_livres ]; then
        echo "Erreur : Le fichier $chemain_fichier_livres n'existe pas." >&2
        exit 1
    fi

    #Vérification de l'existence du fichier exemplaires.CSV
    if [ ! -f $chemain_fichier_exemplaires ]; then
        echo "Erreur : Le fichier $chemain_fichier_exemplaires n'existe pas." >&2
        exit 1
    fi

    #Conversion du titre et de l'auteur en minuscules, suppression des espaces et des caractères spéciaux
    titre=$(echo "$titre" | tr '[:upper:]' '[:lower:]' | tr -d "'" | tr ' ' '_')
    auteur=$(echo "$auteur" | tr '[:upper:]' '[:lower:]' | tr -d "'" | tr ' ' '_')



    #Vérification que le livre n'est pas déjà inscrit
    while IFS=',' read -r numero fichier_titre fichier_auteur; do
        if [[ "$fichier_titre" == "$titre" && "$fichier_auteur" == "$auteur" ]]; then
            echo "Erreur : Le livre $titre de $auteur est déjà inscrit à la bibliothèque."
            exit 2
        fi
    done < "$chemain_fichier_livres"

    #Récupération du dernier numéro de livre
    dernier_numero_livre=$(tail -n 1 $chemain_fichier_livres | cut -d ',' -f 1)

    #Vérification de l'existence du dernier numéro de livre
    if [ -z "$dernier_numero_livre" ]; then
        dernier_numero_livre=0
    fi

    #Calcul du numéro de livre
    numero_livre=$((dernier_numero_livre + 1))

    #Affichage des informations
    echo "Ajout du livre :"
    echo "Nombre d'exemplaires : $nombre_exemplaires"
    echo "Titre : $titre"
    echo "Auteur : $auteur"

    # Ajout dans un fichier CSV
    echo "$numero_livre,$titre,$auteur" >> $chemain_fichier_livres
    echo "Livre ajouté avec succès dans $chemain_fichier_livres."


    # Ajout des exemplaires dans un fichier CSV
    for i in $(seq 1 $nombre_exemplaires); do
        echo "$numero_livre,$i,oui" >> $chemain_fichier_exemplaires
    done
    echo "Exemplaires ajoutés avec succès dans $chemain_fichier_exemplaires."
}






# Vérification de l'usage correct
if [ $# -eq 0 ]; then
    echo "Usage : $0 [-a nom prenom ville] [-l nombre_exemplaire titre auteur]" >&2
    exit 1
fi

# Boucle pour traiter les options
while getopts "a:l:" opt; do
    case $opt in
        a) 
            # Vérification qu'il y a exactement 3 arguments après -a
            if [ $# -lt $((OPTIND + 1)) ]; then
                echo "Erreur : L'option -a nécessite exactement 3 arguments : nom, prenom et ville." >&2
                exit 1
            fi

            # Appel de la fonction avec les arguments
            ajout_adherent "${@:$OPTIND-1:1}" "${@:$OPTIND:1}" "${@:$OPTIND+1:1}"

            # Ajustement d'OPTIND pour sauter les arguments déjà traités
            OPTIND=$((OPTIND + 3))
            ;;
        l)
            # Vérification qu'il y a exactement 3 arguments après -l

            if [ $# -lt $((OPTIND + 1)) ]; then
                echo "Erreur : L'option -l nécessite exactement 3 arguments : nombre_exemplaires, titre et auteur." >&2
                exit 1
            fi

            # Appel de la fonction avec les arguments
            ajout_livre "${@:$OPTIND-1:1}" "${@:$OPTIND:1}" "${@:$OPTIND+1:1}"

            # Ajustement d'OPTIND pour sauter les arguments déjà traités
            OPTIND=$((OPTIND + 3))
            ;;
        \?)
            echo "Option invalide : -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "L'option -$OPTARG requiert des arguments." >&2
            exit 1
            ;;
    esac
done