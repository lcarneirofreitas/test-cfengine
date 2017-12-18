#!/bin/bash

#############################################################################
# Script para instalacao do oracle java7 no servidor
# eduardo.batista@reservafacil.tur.br
# Wed Mar 27 15:16:01 BRT 2013
#############################################################################

PACKAGES="oracle-java8-installer oracle-java8-set-default"
APTREPOSITORY="/usr/bin/add-apt-repository"
APTGET="/usr/bin/apt-get"
DEBCONFSET="/usr/bin/debconf-set-selections"
DEBCONFLOAD="/usr/bin/debconf-loadtemplate"
FILE="/tmp/x.$$"
RM="/bin/rm"
LN="/bin/ln"

main () {
        $APTREPOSITORY -y ppa:webupd8team/java
        $APTGET update  > /dev/null

        echo -e "Template: shared/accepted-oracle-license-v1-1\nType: select" > $FILE
        $DEBCONFLOAD "oracle-java7-installer, oracle-java7-set-default, oracle-jdk7-installer" $FILE

        for pkg in $PACKAGES;
                do echo $pkg shared/accepted-oracle-license-v1-1 select true | $DEBCONFSET
        done

        for pkg in $PACKAGES;
                do /usr/bin/env DEBIAN_FRONTEND=noninteractive LC_ALL=C $APTGET -y install $pkg
        done

        $RM /usr/lib/jvm/default-java
        $LN -s /usr/lib/jvm/java-8-oracle /usr/lib/jvm/default-java
        $RM -f $FILE

}

main
