/*************  ✨ Codeium Command 🌟  *************/
# Install Vault using the official HashiCorp APT repository
# The first two lines download the HashiCorp GPG key and add it to the
# system keyring, and the third line adds the repository to the sources
# list.
```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

# Start a Vault server in development mode
# This is a simple way to get started with Vault, but it's not suitable for
# production use.
vault server -dev

# Print out some information about the running Vault server
# API Address:  http://127.0.0.1:8200
# Storage: inmem
# Unseal Key: <key>
# Root Token: <token>
API Address:  http://127.0.0.1:8200

# Set the VAULT_ADDR environment variable so that the Vault client will
# talk to the server we just started.
Storage: inmem

Unseal Key: <key>

Root Token: <token>

export VAULT_ADDR='http://127.0.0.1:8200'

# Set the VAULT_TOKEN environment variable so that the Vault client will
# authenticate with the root token.
export VAULT_TOKEN="<token>"

# Check the status of the Vault server
vault status

# Enable the KV v2 secrets engine at the "test" path
vault secrets enable -path=test kv

# Put a secret in the KV store
vault kv put test/path color=blue

# Get the secret from the KV store
vault kv get test/path

# Get the secret from the KV store in JSON format
vault kv get  -format=json test/path

# Delete the secret from the KV store
vault kv delete test/path

# List all of the enabled secrets engines
vault secrets list

# Enable the AWS secrets engine at the "aws" path
vault secrets enable -path=aws aws

# List all of the enabled secrets engines
vault secrets list

# Disable the AWS secrets engine
vault secrets disable aws

# Configure the AWS secrets engine
vault write aws/config/root \
    access_key=<access_key> \
    secret_key=<secret> \
    region=us-east-1

# Define a role for the AWS secrets engine

vault write aws/roles/my-ec2-role \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF

# Read the role
vault read aws/roles/my-ec2-role

# Revoke a lease
Key                Value
---                -----
lease_id           aws/creds/my-ec2-role/mMUA17vlEwKMW14wLwclnx0G
lease_duration     768h
lease_renewable    true
access_key         <access_key>
secret_key         <secret>
session_token      <nil>


vault lease revoke aws/creds/my-ec2-role/mMUA17vlEwKMW14wLwclnx0G

# Write a policy
vault policy write my-policy -<<EOF
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
EOF

# List all of the enabled secrets engines
vault secrets list

# Read the policy
vault policy read my-policy

# Delete the policy
vault policy delete my-policy

# Create a token with the my-policy policy
export VAULT_TOKEN="$(vault token create -field token -policy=my-policy)"

# Put a secret in the KV store
vault kv put -mount=secret creds password="my-long-password"

# Put a secret in the KV store
vault kv put -mount=secret foo color=red

# List all of the enabled auth methods
vault auth list

# Enable the approle auth method
vault auth enable approle

# Write a role for the approle auth method
vault write auth/approle/role/my-role \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=my-policy

# Get the role ID
	
export ROLE_ID="$(vault read -field=role_id auth/approle/role/my-role/role-id)"

# Get the secret ID
export SECRET_ID="$(vault write -f -field=secret_id auth/approle/role/my-role/secret-id)"

# Login with the role and secret ID
vault write auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID"

# Create a token
vault token create

# Login with the token
vault login
```
/******  92fb6c23-2859-46b2-aa27-c8b4f8a68baa  *******/