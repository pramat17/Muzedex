#!/bin/bash

# Récupère le nom de la branche sur laquelle la pipeline est executée
branch=$CI_COMMIT_REF_NAME

# Extrait la version du pubspec.yaml
current_version=$(grep -E '^version:' "pubspec.yaml" | awk '{print $2}')

# Sépare les différentes composante de la version
IFS='.' read -r major minor patch_build <<< "${current_version%-*}"
IFS='+' read -r patch build <<< "${patch_build%-*}"

if [[ "$branch" == "main" ]]; then
  major=$((major + 1))
  minor=0
  build=0
elif [[ "$branch" == "dev" ]]; then
  minor=$((minor + 1))
fi

new_version="$major.$minor.$patch+$((build + 1))"

# Mets à jour la version dans le pubspec.yaml
sed -i "s/^version: .*/version: $new_version/" "pubspec.yaml"

# Retourne la version
echo "$new_version"
