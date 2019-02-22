#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE:-$0}"); pwd)
cd $SCRIPT_DIR
# for mac, $(date -v-1d '+%Y%m%d')
ODOO_RELEASE=$(date -d-1day '+%Y%m%d')

function update(){
  ODOO_VERSION=$1
  sed -i.bak "s/ARG ODOO_RELEASE=.*$/ARG ODOO_RELEASE=$ODOO_RELEASE/" $ODOO_VERSION/Dockerfile
  # for mac, sha1sum should be shasum
  ODOO_SHA=$(curl -s -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb && sha1sum odoo.deb | cut -d' ' -f 1)
  sed -i.bak "s/ARG ODOO_SHA=.*$/ARG ODOO_SHA=$ODOO_SHA/" $ODOO_VERSION/Dockerfile
  rm odoo.deb
  rm $ODOO_VERSION/Dockerfile.bak
  git add $ODOO_VERSION/Dockerfile
}
update 10.0
update 11.0
update 12.0

function updateJP(){
  ODOO_VERSION=$1
  sed -i.bak "s/FROM pmusers/odoo:${ODOO_VERSION}-.*$/FROM pmusers/odoo:${ODOO_VERSION}-$ODOO_RELEASE/" ${ODOO_VERSION}-jp/Dockerfile
  rm ${ODOO_VERSION}-jp/Dockerfile.bak
  git add ${ODOO_VERSION}-jp/Dockerfile
}
updateJP 12.0

git commit -m "[REF] Odoo 10.0-12.0: update to release $ODOO_RELEASE"
git tag $ODOO_RELEASE
git push origin $ODOO_RELEASE master
