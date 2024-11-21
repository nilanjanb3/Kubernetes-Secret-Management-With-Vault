1. Secret YAML
filename: secrets.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
data:
  username: YWRtaW4K
  password: YWRtaW4K

```
2. Creating Secret
```sh
$ k apply -f secrets.yaml
```
3. Feeding Secret Into Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    name: nginx
spec:
  containers:
    - name: nginx
      image: nginx
      resources:
        limits:
          memory: "128Mi"
          cpu: "500m"
      ports:
        - containerPort: 80
          name: http
          protocol: TCP
      volumeMounts:
        - mountPath: /usr/credentials
          name: credentials

  volumes:
    - name: credentials
      secret:
        secretName: test-secret

```
4. Verifying
```sh
$ k exec -it nginx -- cat /usr/credentials/username

$ k exec -it nginx -- cat /usr/credentials/password
```