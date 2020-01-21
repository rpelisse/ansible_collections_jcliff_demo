# Ansible JCliff Collection - Demonstration playbook

This project demonstrates how to use the [redhat.jcliff](https://github.com/rpelisse/ansible_collections_jcliff) Ansible Collection in order to fine-tune [JBoss EAP](https://www.redhat.com/en/technologies/jboss-middleware/application-platform) or [Wildfly](https://wildfly.org/) server configuration.

1. First, go to the [redhat.jcliff](https://github.com/rpelisse/ansible_collections_jcliff) and ensure you have properly installed the redhat.jcliff Collection for Ansible
2. Install and start either a [JBoss EAP](https://www.redhat.com/en/technologies/jboss-middleware/application-platform) instance or a [Wildfly](https://wildfly.org/) instance on the target system
3. Edit the file playbook.yml provided in this project to specify the path to the home of the server instance (JBOSS_HOME)
4. Run the playbook:

    $ ansible-playbook playbook.yml

5. If everything went fine, you should be able to see a new property being defined inside the server configuration:

    $ "${JBOSS_HOME}/bin/jboss-cli.sh" --connect --command="ls /system-property=jcliff.enabled"
    value=enabled

Note: Running the playbook will require root privilege only to perform the installation of jcliff. The interaction between jcliff and the server instance does not require root privileges.
