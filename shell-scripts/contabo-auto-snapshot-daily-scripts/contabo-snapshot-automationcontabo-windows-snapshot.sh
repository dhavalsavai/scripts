CLIENT_ID=client_id_here
CLIENT_SECRET=client_secret_here
API_USER=abc@live.com
API_PASSWORD=api_pwd_here
ACCESS_TOKEN=$(curl -d "client_id=$CLIENT_ID" -d "client_secret=$CLIENT_SECRET" --data-urlencode "username=$API_USER" --data-urlencode "password=$API_PASSWORD" -d 'grant_type=password' 'https:/auth.contabo.com/auth/realms/contabo/protocol/openid-connect/token' | jq -r '.access_token')
echo "List Contabo Snapshot - Running"
response=$(curl -X GET 'https://api.contabo.com/v1/compute/instances/201241570/snapshots' -H 'Content-Type: application/json' -H "Authorization: Bearer ${ACCESS_TOKEN}" -H 'x-request-id: 7b30986a-9611-4c0a-8739-0977f7eaca6d' -H 'x-trace-id: 123213')
snapshotId=$(echo "$response" | jq -r '.data[0].snapshotId')
echo "Snapshot ID: $snapshotId"
echo "Delete Contabo Snapshot - Running" 
curl -X DELETE "https://api.contabo.com/v1/compute/instances/2012/snapshots/$snapshotId" -H 'Content-Type: application/json' -H "Authorization: Bearer ${ACCESS_TOKEN}" -H 'x-request-id: 7b30986a-9611-4c0a-8739-0977f7eaca6d' -H 'x-trace-id: 123213'

echo "Create New Snapshot - Running : "
curl -X POST 'https://api.contabo.com/v1/compute/instances/2012/snapshots' -H 'Content-Type: application/json' -H "Authorization: Bearer ${ACCESS_TOKEN}" -H 'x-request-id: 7b30986a-9611-4c0a-8739-0977f7eaca6d' -H 'x-trace-id: 123213' -d '{"name":"Snapshot-fresh","description":"Daily-Snapshot"}'
