Testing the HTTPS webserver locally requires generating a server key and
self-signed certificate.

```
openssl genrsa -out server.key 2048
openssl req -new -x509 -sha256 -key server.key -out server.crt -days 3650
```

The certificate generation command (the second line) will require you to enter
various metadata about your identity.

These files must live in the `lunar-rocks/go/` directory in your local working
tree of the project repository