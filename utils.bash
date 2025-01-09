est_entier_positif() {
    local entier="$1"
    if [[ "$entier" =~ ^[0-9]+$ ]]; then
        return 0 #C'est un entier positif
    else
        return 1 #Ce n'est pas un entier positif
    fi
}

convert_text() {
    local text="$1"
    echo "$text" | tr '[:upper:]' '[:lower:]' | tr -d "'" | tr ' ' '_'
}