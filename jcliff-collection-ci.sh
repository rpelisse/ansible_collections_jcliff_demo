#!/bin/bash

readonly COLLECTION_REPO_URL=${COLLECTION_REPO_URL:-'https://github.com/rpelisse/ansible_collections_jcliff'}
readonly COLLECTION_FOLDER=${COLLECTION_FOLDER:-"/ansible-collection/"}
readonly PATH_TO_PLAYBOOK=${PATH_TO_PLAYBOOK:-'/work/playbook.yml'}

git clone "${COLLECTION_REPO_URL}" "${COLLECTION_FOLDER}"

cd "${COLLECTION_FOLDER}"
rm -f *.tar.gz
ansible-galaxy collection build --force
ansible-galaxy collection install --force *.tar.gz
cd - 2> /dev/null

export JBOSS_HOME=${JBOSS_HOME:-'/wildfly'}

if [ ! -d "${JBOSS_HOME}" ]; then
  echo "Invalid JBOSS_HOME: ${JBOSS_HOME}."
  exit 1
fi

"${JBOSS_HOME}/bin/standalone.sh" 2>&1 > /dev/null &
echo 'Waiting for JBoss AS to boot up...'
sleep 10
echo 'JBoss AS should be up.'
tail -3 "${JBOSS_HOME}/standalone/log/server.log"

ansible-playbook -vvvv "${PATH_TO_PLAYBOOK}" --extra-vars "jboss_home=${JBOSS_HOME} ansible_distribution=CentOS"
