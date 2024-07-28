#!/bin/bash

# Define the directory to search
backup_directory="/etc/gitlab/config_backup/"

# Find and delete files older than 16 days with .tar extension
find "$backup_directory" -name "*.tar" -type f -mtime +16 -delete
