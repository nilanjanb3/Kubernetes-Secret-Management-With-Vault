```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

vault server -dev

API Address:  http://127.0.0.1:8200

Storage: inmem

Unseal Key: <key>

Root Token: <token>

export VAULT_ADDR='http://127.0.0.1:8200'

export VAULT_TOKEN="<token>"

vault status

vault secrets enable -path=test kv

vault kv put test/path color=blue

vault kv get test/path

vault kv get  -format=json test/path

vault kv delete test/path

vault secrets list

vault secrets enable -path=aws aws

vault secrets list

vault secrets disable aws

vault write aws/config/root \
    access_key=<access_key> \
    secret_key=<secret> \
    region=us-east-1


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

vault read aws/roles/my-ec2-role

Key                Value
---                -----
lease_id           aws/creds/my-ec2-role/mMUA17vlEwKMW14wLwclnx0G
lease_duration     768h
lease_renewable    true
access_key         <access_key>
secret_key         <secret>
session_token      <nil>


vault lease revoke aws/creds/my-ec2-role/mMUA17vlEwKMW14wLwclnx0G

vault policy write my-policy -<<EOF
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
EOF

vault secrets list

vault policy read my-policy

vault policy delete my-policy

export VAULT_TOKEN="$(vault token create -field token -policy=my-policy)"

vault kv put -mount=secret creds password="my-long-password"

vault kv put -mount=secret foo color=red

vault auth list

vault auth enable approle

vault write auth/approle/role/my-role \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=my-policy
	
export ROLE_ID="$(vault read -field=role_id auth/approle/role/my-role/role-id)"

export SECRET_ID="$(vault write -f -field=secret_id auth/approle/role/my-role/secret-id)"

vault write auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID"

vault token create

vault login
```
