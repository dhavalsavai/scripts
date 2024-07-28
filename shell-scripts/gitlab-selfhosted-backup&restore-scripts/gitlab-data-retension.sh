#!/bin/bash

# Define the directory to search
backup_directory="/var/opt/gitlab/backups/"

# Find and delete files older than 16 days with .tar extension
find "$backup_directory" -name "*.tar" -type f -mtime +16 -delete