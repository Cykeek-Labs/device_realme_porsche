#!/bin/bash

# Define an associative array with folder paths as keys and repository URLs as values
declare -A repositories=(
    ["vendor/realme/porsche"]="https://gitea.com/Cykeek/vendor_realme_porsche test"
    ["hardware/oplus"]="https://github.com/Cykeek-Labs/hardware_oplus fourteen"
    ["kernel/realme/sm8350"]="https://github.com/Cykeek-Labs/kernel_realme_sm8350 A14"
    ["vendor/realme/firmware"]="https://gitlab.com/kajirokasuna/proprietary_vendor_realme_firmware.git uvite-porsche"
)

# Initialize an array to store non-existing folders
missing_folders=()

# Loop through each folder path
for folder_path in "${!repositories[@]}"; do
    if [ ! -d "$folder_path" ]; then
        missing_folders+=("$folder_path")
    fi
done

# Check if there are missing folders
if [ ${#missing_folders[@]} -eq 0 ]; then
    echo "All folders exist."
else
    echo "The following folders do not exist:"
    for missing_folder in "${missing_folders[@]}"; do
        echo "  - $missing_folder"
    done

    # Prompt user to download missing repositories
    read -p "Do you want to download repositories in the missing folders? (Y/N): " answer

    # Check user's response
    if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
        # Loop through missing folders and download repositories
        for missing_folder in "${missing_folders[@]}"; do
            repo_info=(${repositories[$missing_folder]})
            repository_url="${repo_info[0]}"
            branch="${repo_info[1]}"

            if [ -n "$repository_url" ]; then
                echo "Downloading repository in $missing_folder with branch $branch..."
                # Add your download commands or script here
                # For example, you can use git clone with specified branch:
                git clone --branch "$branch" "$repository_url" "$missing_folder"
            else
                echo "No repository URL defined for $missing_folder. Skipping download."
            fi
        done
        echo "Download complete."
    else
        echo "No repositories will be downloaded."
    fi
fi
