#!/bin/sh

MYSQLROOT=`grep -oE 'mysql_root_password: .*' ansible/vars/domserver-passwords.yml | sed -e 's/mysql_root_password: //'`
SCPOPTS=`vagrant ssh-config domjudgegrader | grep -v '^Host ' | grep -v '^$' | awk -v ORS=' ' '{print "-o " $1 "=" $2}'`
IP=`echo ${SCPOPTS} | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'`
scp ${SCPOPTS} domjudge.sql vagrant@${IP}:/home/vagrant/domjudge.sql
vagrant ssh domjudgegrader -- "mysql -u root -p${MYSQLROOT} domjudge < /home/vagrant/domjudge.sql"
vagrant ssh domjudgegrader -- "rm -f /home/vagrant/domjudge.sql"
vagrant ssh domjudgegrader -- "sudo service judgehost restart"

