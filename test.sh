#!/bin/bash

readonly COLLECTION_REPO_URL=${COLLECTION_REPO_URL:-'https://github.com/rpelisse/ansible_collections_jcliff'}
readonly COLLECTION_FOLDER=${COLLECTION_FOLDER:-"/ansible-collection/"}

git clone "${COLLECTION_REPO_URL}" "${COLLECTION_FOLDER}"

cd "${COLLECTION_FOLDER}"
rm -f *.tar.gz
ansible-galaxy collection build --force
ansible-galaxy collection install --force *.tar.gz
cd -

export JBOSS_HOME=${JBOSS_HOME:-'/wildfly'}

if [ ! -d "${JBOSS_HOME}" ]; then
  echo "Invalid JBOSS_HOME: ${JBOSS_HOME}."
  exit 1
fi

/wildfly/bin/standalone.sh 2>&1 > /dev/null

echo -n 'Waiting for JBoss AS to boot up...'
sleep 60
echo 'Done.'

ansible-playbook playbook.yml --extra-vars "jboss_home=${JBOSS_HOME} ansible_distribution=CentOS"
