#!/bin/bash

# Define the input and output directories
INPUT_DIR="flows/md"
OUTPUT_DIR="resources/finaldocs"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all Markdown files in the input directory
for md_file in "$INPUT_DIR"/*.md; do
    # Get the base name of the Markdown file (without extension)
    base_name=$(basename "$md_file" .md)

    # Convert Markdown to HTML using Pandoc
    pandoc "$md_file" -o "$OUTPUT_DIR/$base_name.html" --base-header-level=1 --standalone

    # Check if the HTML conversion was successful
    if [ $? -eq 0 ]; then
        # Convert HTML to PDF using wkhtmltopdf with local file access
        wkhtmltopdf --enable-local-file-access "$OUTPUT_DIR/$base_name.html" "$OUTPUT_DIR/$base_name.pdf"

        # Check if the PDF conversion was successful
        if [ $? -eq 0 ]; then
            echo "Converted: $md_file to $OUTPUT_DIR/$base_name.pdf"

            # Delete the HTML file after successful PDF conversion
            rm "$OUTPUT_DIR/$base_name.html"
        else
            echo "Failed to convert HTML to PDF for: $md_file"
        fi
    else
        echo "Failed to convert Markdown to HTML for: $md_file"
    fi
done
