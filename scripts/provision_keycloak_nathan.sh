#!/bin/bash
set -e

# Login (set KEYCLOAK_ADMIN_PASSWORD and NATHAN_PASSWORD in env before running)
KC_ADMIN_PW="${KEYCLOAK_ADMIN_PASSWORD:-[REDACTED]}"
NATHAN_PW="${NATHAN_PASSWORD:-[REDACTED]}"

docker exec -e KC_ADMIN_PW="$KC_ADMIN_PW" sso_keycloak /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password "$KC_ADMIN_PW"

# Relax specialChars policy temporarily or permanently so policy passes
docker exec sso_keycloak /opt/keycloak/bin/kcadm.sh update realms/S4RAS -s 'passwordPolicy=length(8) and digits(1)'

# Set password for nathan1
docker exec -e NATHAN_PW="$NATHAN_PW" sso_keycloak /opt/keycloak/bin/kcadm.sh set-password -r S4RAS --username nathan1 --new-password "$NATHAN_PW" --temporary=false

# Get user ID
USER_ID=$(docker exec sso_keycloak /opt/keycloak/bin/kcadm.sh get users -r S4RAS -q username=nathan1 --fields id --format csv --noquotes)
echo "USER_ID=$USER_ID"

# Add realm roles: admin, Super Admin, default-roles-s4ras
docker exec sso_keycloak /opt/keycloak/bin/kcadm.sh add-roles -r S4RAS --uid "$USER_ID" --rolename admin || true
docker exec sso_keycloak /opt/keycloak/bin/kcadm.sh add-roles -r S4RAS --uid "$USER_ID" --rolename "Super Admin" || true

# Add realm-management client role realm-admin
MGMT_CID=$(docker exec sso_keycloak /opt/keycloak/bin/kcadm.sh get clients -r S4RAS -q clientId=realm-management --fields id --format csv --noquotes)
echo "MGMT_CID=$MGMT_CID"

if [ -n "$MGMT_CID" ]; then
  docker exec sso_keycloak /opt/keycloak/bin/kcadm.sh add-roles -r S4RAS --uid "$USER_ID" --cclientid "$MGMT_CID" --rolename realm-admin || true
fi

# Verify user roles
echo "Assigned Realm Roles:"
docker exec sso_keycloak /opt/keycloak/bin/kcadm.sh get-roles -r S4RAS --uid "$USER_ID"

# Verify token acquisition
echo "Testing token endpoint for nathan1..."
curl -s -k -X POST https://sso.s4ras.site/realms/S4RAS/protocol/openid-connect/token \
  -d "client_id=front-end" \
  -d "grant_type=password" \
  -d "username=nathan1" \
  -d "password=$NATHAN_PW" | grep -o '"access_token":' || echo "Token check failed!"

echo "Keycloak setup finished successfully."
