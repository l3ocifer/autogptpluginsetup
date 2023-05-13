#!/bin/bash

# Find the Auto-GPT directory under the user's home directory
dir=$(find ~ -type d -name "Auto-GPT" 2>/dev/null)

if [ -z "$dir" ]; then
    echo "Auto-GPT directory not found. Exiting..."
    exit 0
fi

# Switch to the plugins subdirectory
cd "$dir/plugins"

# Check if there are any subdirectories starting with 'Auto'
if [ -z "$(ls -d Auto*/ 2>/dev/null)" ]; then
    echo "No directories starting with 'Auto' found. Exiting..."
    exit 0
fi

# Loop through all subdirectories starting with 'Auto'
for subdir in Auto*/ ; do
    # Check if it's not a zip file
    if [[ ! $subdir == *.zip ]]; then
        # Check if requirements.txt exists
        if [ -f "$subdir/requirements.txt" ]; then
            # Install python requirements
            pip install -r $subdir/requirements.txt
        else
            echo "No requirements.txt in $subdir. Skipping installation."
        fi

        # Zip the directory
        zipname="${subdir%/}.zip"
        zip -r $zipname $subdir

        # Remove the original directory
        rm -rf $subdir
    fi
done
