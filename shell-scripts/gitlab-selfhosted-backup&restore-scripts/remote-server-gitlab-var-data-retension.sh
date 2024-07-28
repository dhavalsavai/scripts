ssh_command="sshpass -p 'pwd' ssh -p 22 root@1.2.3.4"

# Define the remote script command
remote_script_command="bash -s"

# Define the script content
script_content=$(cat <<'ENDSCRIPT'
#!/bin/bash
find /codelab-backup/varfile -type f -iname '*.tar' -mtime +36 -exec rm {} \;
ENDSCRIPT
)

# Combine everything and execute the command
echo "$script_content" | $ssh_command "$remote_script_command"
