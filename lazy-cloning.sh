# Function to clone the contents of another person's GitHub repository without replacing existing content
clone_repository_contents() {
    # Get the repository URL as the first argument
    repo_url=$1

    # Clone the repository into a temporary directory
    temp_dir=$(mktemp -d)
    git clone $repo_url $temp_dir

    # Move into the temporary repository directory
    cd $temp_dir

    # Get the name of the root folder in the other person's repository
    root_folder_name=$(basename -s .git $repo_url)

    # Copy the contents of the cloned repository's root folder into the endpoint repository's root folder
    cp -r ./* $OLDPWD/
    cp -r ./.gitignore $OLDPWD/ 2>/dev/null
    cp -r ./.gitattributes $OLDPWD/ 2>/dev/null
    cp -r ./.github $OLDPWD/ 2>/dev/null

    # Move back to the endpoint repository's root folder
    cd $OLDPWD

    # Commit the changes to the endpoint repository
    git add .
    git commit -m "Merge contents of $repo_url into existing repository"
    git push origin main

    # Remove the temporary directory
    rm -rf $temp_dir
}
