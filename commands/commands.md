```sh
# Install Vault.
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

# Start a Vault server in development mode.
vault server -dev

# The API address is http://127.0.0.1:8200
# The storage is in memory
# The unseal key is <key>
# The root token is <token>

# Set the address and token environment variables.
export VAULT_ADDR='http://127.0.0.1:8200'

export VAULT_TOKEN="<token>"

# Get the status of the Vault server.
vault status

# Enable the KV secrets engine at the path "test".
vault secrets enable -path=test kv

# Put a secret at the path "test/path" with a value of "color=blue".
vault kv put test/path color=blue

# Get the secret at the path "test/path".
vault kv get test/path

# Get the secret at the path "test/path" in JSON format.
vault kv get -format=json test/path

# Delete the secret at the path "test/path".
vault kv delete test/path

# List all of the secrets engines.
vault secrets list

# Enable the AWS secrets engine at the path "aws".
vault secrets enable -path=aws aws

# List all of the secrets engines.
vault secrets list

# Disable the AWS secrets engine.
vault secrets disable aws

# Configure the AWS secrets engine.
vault write aws/config/root \
    access_key=<access_key> \
    secret_key=<secret> \
    region=us-east-1

# Create a role for the AWS secrets engine.
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

# Get the role for the AWS secrets engine.
vault read aws/roles/my-ec2-role

# Get the lease for the AWS secrets engine.
vault read aws/creds/my-ec2-role

# Revoke the lease for the AWS secrets engine.
vault lease revoke aws/creds/my-ec2-role/mMUA17vlEwKMW14wLwclnx0G

# Create a policy.
vault policy write my-policy -<<EOF
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
EOF

# List all of the policies.
vault policy list

# Read the policy.
vault policy read my-policy

# Delete the policy.
vault policy delete my-policy

# Create a token with the policy.
export VAULT_TOKEN="$(vault token create -field token -policy=my-policy)"

# Put a secret at the path "creds" with a value of "password=my-long-password".
vault kv put -mount=secret creds password="my-long-password"

# Put a secret at the path "foo" with a value of "color=red".
vault kv put -mount=secret foo color=red

# List all of the auth backends.
vault auth list

# Enable the AppRole auth backend.
vault auth enable approle

# Create a role for the AppRole auth backend.
vault write auth/approle/role/my-role \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=my-policy

# Get the role ID for the AppRole auth backend.
export ROLE_ID="$(vault read -field=role_id auth/approle/role/my-role/role-id)"

# Get the secret ID for the AppRole auth backend.
export SECRET_ID="$(vault write -f -field=secret_id auth/approle/role/my-role/secret-id)"

# Log in with the AppRole auth backend.
vault write auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID"

# Create a new token.
vault token create

# Log in with the token.
vault login

# Start the Vault server with the configuration file at config.hcl.
vault server -config=./config.hcl

# Set the address environment variable to the address of the Vault server.
export VAULT_ADDR='http://127.0.0.1:8200'

# Initialize the Vault server with the Shamir's Secret Sharing algorithm.
vault operator init
```