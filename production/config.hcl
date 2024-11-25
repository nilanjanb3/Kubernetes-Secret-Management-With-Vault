# This is a Vault configuration file for a production instance.
#
# The `ui` block configures the built-in web server for the Vault UI.
# This is usually disabled in production.
ui            = true

# The `cluster_addr` and `api_addr` blocks configure the addresses
# that Vault binds to for its HTTP (API) and HTTPS (Cluster) servers,
# respectively. The default ports are 8200 and 8201, respectively.
cluster_addr  = "https://127.0.0.1:8201"
api_addr      = "http://127.0.0.1:8200"

# The `disable_mlock` block configures Vault to not use the `mlock(2)`
# system call to lock memory. This is usually disabled in production
# environments since it can cause performance issues.
disable_mlock = true

# The `storage` block configures the storage backend for Vault. The
# `raft` backend is a distributed storage system that stores Vault data
# in a raft cluster.
storage "raft" {
  # The `path` block configures the path where the raft data is stored.
  path = "/vault/data"

  # The `node_id` block configures the unique identifier for the raft
  # node. This is required for Vault to properly communicate with the
  # raft cluster.
  node_id = "node1"
}

# The `listener` block configures the listener for Vault. This is
# the address that Vault will bind to for incoming requests.
listener "tcp" {
  # The `address` block configures the address that Vault binds to.
  address       = "0.0.0.0:8200"

  # The `tls_cert_file` and `tls_key_file` blocks configure the
  # TLS certificate and key, respectively, for the listener. These
  # should point to the full-chain certificate and private key,
  # respectively.
  tls_disable = "true"
  # tls_cert_file = "/path/to/full-chain.pem"
  # tls_key_file  = "/path/to/private-key.pem"
}

# The `telemetry` block configures the telemetry options for Vault.
telemetry {
  # The `statsite_address` block configures the address that Vault will
  # send telemetry data to.
  statsite_address = "127.0.0.1:8125"

  # The `disable_hostname` block configures Vault to not use the hostname
  # in the telemetry output. This is usually disabled in production
  # environments since it can cause performance issues.
  disable_hostname = true
}

