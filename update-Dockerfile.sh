#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE:-$0}"); pwd)
cd $SCRIPT_DIR
# for mac, $(date -v-1d '+%Y%m%d')
ODOO_RELEASE=$(date -d-1day '+%Y%m%d')

function update(){
  ODOO_VERSION=$1
  SUFFIX=${2:-""}
  sed -i.bak "s/ARG ODOO_RELEASE=.*$/ARG ODOO_RELEASE=$ODOO_RELEASE/" $ODOO_VERSION$SUFFIX/Dockerfile
  # for mac, sha1sum should be shasum
  ODOO_SHA=$(curl -s -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb && sha1sum odoo.deb | cut -d' ' -f 1)
  sed -i.bak "s/ARG ODOO_SHA=.*$/ARG ODOO_SHA=$ODOO_SHA/" $ODOO_VERSION$SUFFIX/Dockerfile
  rm odoo.deb
  rm $ODOO_VERSION$SUFFIX/Dockerfile.bak
  git add $ODOO_VERSION$SUFFIX/Dockerfile
}
update 10.0
update 11.0
update 12.0
update 13.0

function updateJP(){
  ODOO_VERSION=$1
  update $ODOO_VERSION '-jp'
}
updateJP 12.0

function updateJPBuster(){
  ODOO_VERSION=$1
  update $ODOO_VERSION '-jp-buster'
}
updateJPBuster 12.0

git commit -m "[REF] Odoo 10.0-12.0: update to release $ODOO_RELEASE"
git tag $ODOO_RELEASE
git push origin $ODOO_RELEASE
git push origin master
