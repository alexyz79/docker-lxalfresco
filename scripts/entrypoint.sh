#!/bin/bash
# trap SIGTERM and gracefully stops alfresco
trap '$CATALINA_HOME/bin/catalina.sh stop;exit 0' SIGTERM
set -e
# Install of war and addons complete, apply them to war file
export ALF_HOME=/opt/alfresco
export CATALINA_HOME=/opt/alfresco/tomcat
export CATALINA_PID="/opt/alfresco/tomcat.pid"
export CATALINA_TMPDIR=/opt/alfresco/tomcat/temp

ALFRESCO_GLOBAL_PROPERTIES_TEMPLATE=$CATALINA_HOME/shared/classes/alfresco-global-template.properties
ALFRESCO_GLOBAL_PROPERTIES=$CATALINA_HOME/shared/classes/alfresco-global.properties
SHARE_CONFIG_CUSTOM_TEMPLATE=$CATALINA_HOME/shared/classes/alfresco/web-extension/tomcat/share-config-custom-template.xml
SHARE_CONFIG_CUSTOM=$CATALINA_HOME/shared/classes/alfresco/web-extension/tomcat/share-config-custom.xml

cp $ALFRESCO_GLOBAL_PROPERTIES_TEMPLATE $ALFRESCO_GLOBAL_PROPERTIES
cp $SHARE_CONFIG_CUSTOM_TEMPLATE $SHARE_CONFIG_CUSTOM

if [[ ! -v LOCALESUPPORT ]]; then
    LOCALESUPPORT='en_US.utf8'
fi

if [[ ! -v SERVER_MODE ]]; then
    SERVER_MODE='UNKNOWN'
fi

if [[ ! -v REPO_HOSTNAME ]]; then
    REPO_HOSTNAME='localhost'
fi

if [[ ! -v REPO_PORT ]]; then
    REPO_PORT=80
fi

if [[ ! -v REPO_PROTOCOL ]]; then
    REPO_PROTOCOL='http'
fi

if [[ ! -v SHARE_HOSTNAME ]]; then
    SHARE_HOSTNAME='localhost'
fi

if [[ ! -v SHARE_PORT ]]; then
    SHARE_PROTOCOL=80
fi

if [[ ! -v SHARE_PROTOCOL ]]; then
    SHARE_PROTOCOL='http'
fi

if [[ ! -v DB_USERNAME ]]; then
    DB_USERNAME='alfresco'
fi

if [[ ! -v DB_PASSWORD ]]; then
    DB_PASSWORD='alfresco'
fi

if [[ ! -v DB_NAME ]]; then
    DB_NAME='alfresco'
fi

if [[ ! -v DB_HOST ]]; then
    DB_HOST='localhost'
fi

if [[ ! -v DB_PORT ]]; then
    DB_PORT=3306
fi

if [[ ! -v SOLR_HOST ]]; then
    SOLR_HOST='localhost'
fi

if [[ ! -v SOLR_PORT ]]; then
    SOLR_PORT=8080
fi

if [[ ! -v SOLR_PORT_SSL ]]; then
    SOLR_PORT_SSL=8443
fi

if [[ ! -v SMTP_HOST ]]; then
    SMTP_HOST='smtp.example.com'
fi

if [[ ! -v SMTP_PORT ]]; then
    SMTP_PORT=25
fi

if [[ ! -v SMTP_USERNAME ]]; then
    SMTP_USERNAME='anonymous'
fi

if [[ ! -v SMTP_PASSWORD ]]; then
    SMTP_PASSWORD='password'
fi

if [[ ! -v SMTP_FROM ]]; then
    SMTP_FROM='alfresco@demo.alfresco.org'
fi

if [[ ! -v SMTP_PROTOCOL ]]; then
    SMTP_PROTOCOL='smtp'
fi

if [[ ! -v SMTP_AUTH ]]; then
    SMTP_AUTH='false'
fi

if [[ ! -v SMTP_ENABLE_TLS ]]; then
    SMTP_ENABLE_TLS='false'
fi

if [[ ! -v SMTPS_AUTH ]]; then
    SMTPS_AUTH='false'
fi

if [[ ! -v SMTPS_ENABLE_TLS ]]; then
    SMTPS_ENABLE_TLS='false'
fi

if [[ ! -v SMTP_TEST_MSG_SEND ]]; then
    SMTP_TEST_MSG_SEND='false'
fi

if [[ ! -v SMTP_TEST_MSG_TO ]]; then
    SMTP_TEST_MSG_TO=''
fi

if [[ ! -v SMTP_TEST_MSG_SUBJECT ]]; then
    SMTP_TEST_MSG_SUBJECT=''
fi

if [[ ! -v SMTP_TEST_MSG_TEXT ]]; then
    SMTP_TEST_MSG_TEXT=''
fi

if [[ ! -v IMAP_ENABLE ]]; then
    IMAP_ENABLE='false'
fi

IMAP_PORT=143
IMAP_HOST='localhost'

if [[ ! -v CIFS_ENABLE ]]; then
    CIFS_ENABLE='false'
fi

CIFS_TCPIPPORT=1445
CIFS_SESSIONPORT=1139
CIFS_NAMEPORT=1137
CIFS_DATAGRAM=1138

if [[ ! -v CIFS_PSEUDOFILES_ENABLE ]]; then
    CIFS_PSEUDOFILES_ENABLE='false'
fi

if [[ ! -v CIFS_EXPLORERURL_ENABLED ]]; then
    CIFS_EXPLORERURL_ENABLED='false'
fi

if [[ ! -v CIFS_EXPLORERURL_FILENAME ]]; then
    CIFS_EXPLORERURL_FILENAME='__Alfresco.url'
fi

if [[ ! -v CIFS_SHAREURL_ENABLED ]]; then
    CIFS_SHAREURL_ENABLED='false'
fi

if [[ ! -v CIFS_SHAREURL_FILENAME ]]; then
    CIFS_SHAREURL_FILENAME='__Share.url'
fi

if [[ ! -v CIFS_DOMAIN ]]; then
    CIFS_DOMAIN='DOMAIN'
fi

if [[ ! -v CIFS_SERVERNAME ]]; then
    CIFS_SERVERNAME='ALFRESCO'
fi

if [[ ! -v FTP_ENABLE ]]; then
    FTP_ENABLE='false'
fi

FTP_PORT=2121
FTP_BIND='localhost'
FTP_DATAFROM=20000
FTP_DATATO=20999

if [[ ! -v SMART_FOLDER_ENABLED ]]; then
    SMART_FOLDER_ENABLED='false'
fi

if [[ ! -v GENERATE_AUTH_SYSTEM ]]; then
    GENERATE_AUTH_SYSTEM='true'
fi

if [ "$GENERATE_AUTH_SYSTEM" = "true" ]; then

    ALFRESCO_NTLM_FILE=$CATALINA_HOME/shared/classes/alfresco/extension/subsystems/Authentication/alfrescoNtlm/alfrescoNtlm1/alfresco-authentication.properties
    LDAP_AUTH_FILE=$CATALINA_HOME/shared/classes/alfresco/extension/subsystems/Authentication/ldap-ad/ldap1/ldap-authentication.properties

    if [ ! -d "$CATALINA_HOME/shared/classes/alfresco/extension/subsystems/Authentication/ldap-ad/ldap1" ]; then
        mkdir -p $CATALINA_HOME/shared/classes/alfresco/extension/subsystems/Authentication/ldap-ad/ldap1
    fi
    if [ ! -d "$CATALINA_HOME/shared/classes/alfresco/extension/subsystems/Authentication/alfrescoNtlm/alfrescoNtlm1" ]; then
        mkdir -p $CATALINA_HOME/shared/classes/alfresco/extension/subsystems/Authentication/alfrescoNtlm/alfrescoNtlm1
    fi

    if [ -e $ALFRESCO_NTLM_FILE ]; then
        rm $ALFRESCO_NTLM_FILE
    fi

    if [ -e $LDAP_AUTH_FILE ]; then
        rm $LDAP_AUTH_FILE
    fi

    if [[ ! -v ALFRESCO_AUTH_ALLOWGUEST  ]]; then
        ALFRESCO_AUTH_ALLOWGUEST='false'
    fi

    if [[ ! -v ALFRESCO_AUTH_CIFS ]]; then
        ALFRESCO_AUTH_CIFS='false'
    fi

    touch $ALFRESCO_NTLM_FILE

    echo "alfresco.authentication.allowGuestLogin=$ALFRESCO_AUTH_ALLOWGUEST" > $ALFRESCO_NTLM_FILE
    echo "alfresco.authentication.authenticateCIFS=$ALFRESCO_AUTH_CIFS" >> $ALFRESCO_NTLM_FILE

    if [[ ! -v LDAP_ENABLED ]]; then
        LDAP_ENABLED='false'
    fi

    if [ "$LDAP_ENABLED" = "true" ]; then

        LDAP_AUTH_SYSTEM='ldap1:ldap-ad'
        sed -i "s/@@LDAP_AUTH_SYSTEM@@/,$LDAP_AUTH_SYSTEM/g" $ALFRESCO_GLOBAL_PROPERTIES

        touch $LDAP_AUTH_FILE

        if [[ ! -v LDAP_ALLOWGUEST ]]; then
            LDAP_ALLOWGUEST='false'
        fi
        if [[ ! -v LDAP_USER_FORMAT ]]; then
            LDAP_USER_FORMAT='%s@DOMAIN'
        fi
        if [[ ! -v LDAP_HOST ]]; then
            LDAP_HOST='localhost'
        fi

        if [[ ! -v LDAP_SYNC_ENABLED ]]; then
            LDAP_SYNC_ENABLED='false'
        fi

        if [[ ! -v LDAP_PRINCIPAL_USER ]]; then
            LDAP_PRINCIPAL_USER='CN=user,OU=users,DC=DOMAIN,DC=EXT'
        fi

        if [[ ! -v LDAP_PRINCIPAL_PASSWORD ]]; then
            LDAP_PRINCIPAL_PASSWORD='password'
        fi
        
        if [[ ! -v LDAP_GROUP_QUERY ]]; then
            LDAP_GROUP_QUERY='(objectClass\\=group)'
        fi
        
        if [[ ! -v LDAP_GROUP_DIFFERENTIAL_QUERY ]]; then
            LDAP_GROUP_DIFFERENTIAL_QUERY='(&(objectClass\\=group)(!(whenChanged<\\={0})))'
        fi
        
        if [[ ! -v LDAP_PERSON_QUERY ]]; then
            LDAP_PERSON_QUERY='(&(objectClass\\=user)(objectClass\\=person))'
        fi
        
        if [[ ! -v LDAP_PERSON_DIFERNTIAL_QUERY ]]; then
            LDAP_PERSON_DIFERNTIAL_QUERY='(&(objectClass\\=user)(objectClass\\=person)(!(whenChanged<\\={0})))'
        fi
        
        if [[ ! -v LDAP_GROUP_SEARCHBASE ]]; then
            LDAP_GROUP_SEARCHBASE='DC\\=DOMAIN,DC\\=TLD'
        fi
        
        if [[ ! -v LDAP_USER_SEARCHBASE ]]; then
            LDAP_USER_SEARCHBASE='DC\\=DOMAIN,DC\\=TLD'
        fi
        
        if [[ ! -v LDAP_MODIFYTS_NAME ]]; then
            LDAP_MODIFYTS_NAME='whenChanged'
        fi
        
        if [[ ! -v LDAP_MODIFYTS_FORMAT ]]; then
            LDAP_MODIFYTS_FORMAT="yyyyMMddHHmmss'.0Z'"
        fi
        
        if [[ ! -v LDAP_USER_ID_ATTRIB ]]; then
            LDAP_USER_ID_ATTRIB='uid'
        fi
        
        if [[ ! -v LDAP_USER_FN_ATTRIB ]]; then
            LDAP_USER_FN_ATTRIB='firstName'
        fi
        
        if [[ ! -v LDAP_USER_LN_ATTRIB ]]; then
            LDAP_USER_LN_ATTRIB='sn'
        fi
        
        if [[ ! -v LDAP_USER_MAIL_ATTRIB ]]; then
            LDAP_USER_MAIL_ATTRIB='mail'
        fi
        
        if [[ ! -v LDAP_ORG_ID_ATTRIB ]]; then
            LDAP_ORG_ID_ATTRIB='o'
        fi
        
        if [[ ! -v LDAP_USER_DEF_HOMEDIR_ATTRIB ]]; then
            LDAP_USER_DEF_HOMEDIR_ATTRIB='homeDirectory'
        fi
        
        if [[ ! -v LDAP_GROUP_ID_ATTRIB ]]; then
            LDAP_GROUP_ID_ATTRIB='cn'
        fi
        
        if [[ ! -v LDAP_GROUP_TYPE ]]; then
            LDAP_GROUP_TYPE='group'
        fi
        
        if [[ ! -v LDAP_PERSON_TYPE ]]; then
            LDAP_PERSON_TYPE='person'
        fi
        
        if [[ ! -v LDAP_GROUP_MEMBER_ATTRIB ]]; then
            LDAP_GROUP_MEMBER_ATTRIB='member'
        fi
        
        echo "ldap.authentication.active=$LDAP_ENABLED" > $LDAP_AUTH_FILE
        echo "ldap.authentication.allowGuestLogin=$LDAP_ALLOWGUEST" >> $LDAP_AUTH_FILE
        echo "ldap.authentication.userNameFormat=$LDAP_USER_FORMAT" >> $LDAP_AUTH_FILE
        echo "ldap.authentication.java.naming.provider.url=ldap://$LDAP_HOST:389/" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.active=$LDAP_SYNC_ENABLED" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.java.naming.security.principal=$LDAP_PRINCIPAL_USER" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.java.naming.security.credentials=$LDAP_PRINCIPAL_PASSWORD" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.groupQuery=$LDAP_GROUP_QUERY" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.groupDifferentialQuery=$LDAP_GROUP_DIFFERENTIAL_QUERY" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.personQuery=$LDAP_PERSON_QUERY" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.personDifferentialQuery=$LDAP_PERSON_DIFERNTIAL_QUERY" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.groupSearchBase=$LDAP_GROUP_SEARCHBASE" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.userSearchBase=$LDAP_USER_SEARCHBASE" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.modifyTimestampAttributeName=$LDAP_MODIFYTS_NAME" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.timestampFormat=$LDAP_MODIFYTS_FORMAT" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.userIdAttributeName=$LDAP_USER_ID_ATTRIB" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.userFirstNameAttributeName=$LDAP_USER_FN_ATTRIB" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.userLastNameAttributeName=$LDAP_USER_LN_ATTRIB" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.userEmailAttributeName=$LDAP_USER_MAIL_ATTRIB" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.userOrganizationalIdAttributeName=$LDAP_ORG_ID_ATTRIB" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.defaultHomeFolderProvider=$LDAP_USER_DEF_HOMEDIR_ATTRIB" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.groupIdAttributeName=$LDAP_GROUP_ID_ATTRIB" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.groupType=$LDAP_GROUP_TYPE" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.personType=$LDAP_PERSON_TYPE" >> $LDAP_AUTH_FILE
        echo "ldap.synchronization.groupMemberAttributeName=$LDAP_GROUP_MEMBER_ATTRIB" >> $LDAP_AUTH_FILE
    else
        sed -i "s/@@LDAP_AUTH_SYSTEM@@/ /g" $ALFRESCO_GLOBAL_PROPERTIES
    fi
fi

locale-gen $LOCALESUPPORT
$ALF_HOME/addons/apply.sh all

sed -i "s/@@SERVER_MODE@@/$SERVER_MODE/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@DB_USERNAME@@/$DB_USERNAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@DB_PASSWORD@@/$DB_PASSWORD/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@DB_NAME@@/$DB_NAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@DB_HOST@@/$DB_HOST/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@DB_PORT@@/$DB_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@ALFRESCO_REPO_SERVER@@/$REPO_HOSTNAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@ALFRESCO_REPO_PORT@@/$REPO_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@ALFRESCO_REPO_PROTOCOL@@/$REPO_PROTOCOL/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@ALFRESCO_SHARE_SERVER@@/$SHARE_HOSTNAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@ALFRESCO_SHARE_SERVER_PORT@@/$SHARE_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@ALFRESCO_SHARE_SERVER_PROTOCOL@@/$SHARE_PROTOCOL/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMART_FOLDER_ENABLED@@/$SMART_FOLDER_ENABLED/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SOLR_HOST@@/$SOLR_HOST/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SOLR_PORT@@/$SOLR_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SOLR_PORT_SSL@@/$SOLR_PORT_SSL/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_HOST@@/$SMTP_HOST/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_PORT@@/$SMTP_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_USERNAME@@/$SMTP_USERNAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_PASSWORD@@/$SMTP_PASSWORD/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_FROM@@/$SMTP_FROM/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_PROTOCOL@@/$SMTP_PROTOCOL/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_AUTH@@/$SMTP_AUTH/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_ENABLE_TLS@@/$SMTP_ENABLE_TLS/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTPS_AUTH@@/$SMTPS_AUTH/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTPS_ENABLE_TLS@@/$SMTPS_ENABLE_TLS/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_TEST_MSG_SEND@@/$SMTP_TEST_MSG_SEND/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_TEST_MSG_TO@@/$SMTP_TEST_MSG_TO/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_TEST_MSG_SUBJECT@@/$SMTP_TEST_MSG_SUBJECT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@SMTP_TEST_MSG_TEXT@@/$SMTP_TEST_MSG_TEXT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@IMAP_ENABLED@@/$IMAP_ENABLE/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@IMAP_PORT@@/$IMAP_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@IMAP_HOST@@/$IMAP_HOST/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_ENABLE@@/$CIFS_ENABLE/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_TCPIPPORT@@/$CIFS_TCPIPPORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_SESSIONPORT@@/$CIFS_SESSIONPORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_NAMEPORT@@/$CIFS_NAMEPORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_DATAGRAM@@/$CIFS_DATAGRAM/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_PSEUDOFILES_ENABLE@@/$CIFS_PSEUDOFILES_ENABLE/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_EXPLORERURL_ENABLED@@/$CIFS_EXPLORERURL_ENABLED/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_EXPLORERURL_FILENAME@@/$CIFS_EXPLORERURL_FILENAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_SHAREURL_ENABLED@@/$CIFS_SHAREURL_ENABLED/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_SHAREURL_FILENAME@@/$CIFS_SHAREURL_FILENAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_DOMAIN@@/$CIFS_DOMAIN/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@CIFS_SERVERNAME@@/$CIFS_SERVERNAME/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@FTP_ENABLE@@/$FTP_ENABLE/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@FTP_PORT@@/$FTP_PORT/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@FTP_BIND@@/$FTP_BIND/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@FTP_DATAFROM@@/$FTP_DATAFROM/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@FTP_DATATO@@/$FTP_DATATO/g" $ALFRESCO_GLOBAL_PROPERTIES
sed -i "s/@@ALFRESCO_SHARE_SERVER@@/$SHARE_HOSTNAME/g" $SHARE_CONFIG_CUSTOM
sed -i "s/@@SHARE_TO_REPO_SERVER@@/$SHARE_TO_REPO_HOSTNAME/g" $SHARE_CONFIG_CUSTOM

# Change to directory, this is where alfresco default log files will go
if [ ! -d "$ALF_HOME/logs" ]; then
    mkdir -p $ALF_HOME/logs
fi

cd $ALF_HOME/logs

JAVA_OPTS="-Xms1G -Xmx2G -Xss1024k"
JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC -XX:+UseParNewGC"
JAVA_OPTS="${JAVA_OPTS} -Duser.country=US -Duser.region=US -Duser.language=en -Duser.timezone=\"Europe/Stockholm\" -d64"
JAVA_OPTS="${JAVA_OPTS} -Djava.awt.headless=true"
JAVA_OPTS="${JAVA_OPTS} -Djava.io.tmpdir=${CATALINA_TMPDIR}"
JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"
JAVA_OPTS="${JAVA_OPTS} -Dalfresco.home=${ALF_HOME} -Dcom.sun.management.jmxremote=true"
JAVA_OPTS="${JAVA_OPTS} -server"

# cleanup temp directory before starting
rm -rf $CATALINA_TMPDIR/* 
rm -rf $CATALINA_HOME/work/* 
$CATALINA_HOME/bin/catalina.sh run

while true;do sleep 5;done;
