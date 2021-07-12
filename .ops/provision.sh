#!/usr/bin/env bash

# https://docs.vmware.com/en/vCloud-Availability-for-vCloud-Director/2.0/com.vmware.vcavcd.install.config.doc/GUID-8C344104-47E5-46A3-95C7-B11845C6907A.html

cd $(dirname "${BASH_SOURCE[0]}") || exit

cd certs && rm *

set -x

DOMAIN=${DOMAIN_NAME:-rabbitmq.local}

# shellcheck disable=SC2086
keytool -genkeypair \
  -keystore rootca.jks \
  -storepass vmware \
  -keyalg RSA \
  -validity 365 \
  -keypass vmware \
  -alias ${DOMAIN} \
  -dname "CN=${DOMAIN},OU=Test, O=Corp, L=Palo Alto S=CA C=US" \
  -ext san=dns:${DOMAIN}

# shellcheck disable=SC2086
keytool -importkeystore -srckeystore rootca.jks \
  -destkeystore foo.p12 -deststoretype pkcs12 \
  -srcstorepass vmware -deststorepass vmware \
  -alias ${DOMAIN}

openssl pkcs12 -in foo.p12 \
  -out foo.pem -passin pass:vmware \
  -passout pass:vmware

sed -n '/-----BEGIN ENCRYPTED PRIVATE KEY-----/,/-----END ENCRYPTED PRIVATE KEY-----/p' \
  foo.pem >enc.pem

openssl rsa -in enc.pem \
  -out unenc.pem -passin pass:vmware

sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' \
  foo.pem >cert.pem
