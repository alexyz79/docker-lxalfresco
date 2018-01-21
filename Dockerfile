FROM mlaccetti/docker-oracle-java8-ubuntu-16.04
MAINTAINER Alexandre Pires c.alexandre.pires@gmail.com

ENV TOMCAT_DOWNLOAD=http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.46/bin/apache-tomcat-8.0.46.tar.gz
ENV JDBCPOSTGRESURL=https://jdbc.postgresql.org/download
ENV JDBCPOSTGRES=postgresql-42.1.4.jar
ENV JDBCMYSQLURL=https://dev.mysql.com/get/Downloads/Connector-J
ENV JDBCMYSQL=mysql-connector-java-5.1.43.tar.gz
ENV LIBREOFFICE=http://downloadarchive.documentfoundation.org/libreoffice/old/5.1.6.2/deb/x86_64/LibreOffice_5.1.6.2_Linux_x86-64_deb.tar.gz
ENV ALFMMTJAR=https://downloads.loftux.net/public/content/org/alfresco/alfresco-mmt/5.2.g/alfresco-mmt-5.2.g.jar
ENV ALFRESCO_PDF_RENDERER=https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/alfresco-pdf-renderer/1.0/alfresco-pdf-renderer-1.0-linux.tgz
ENV KEYSTOREBASE=https://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore
ENV ALFREPOWAR=https://downloads.loftux.net/alfresco/alfresco-platform/LX100/alfresco-platform-LX100.war
ENV ALFSHAREWAR=https://downloads.loftux.net/alfresco/share/LX100/share-LX100.war
ENV ALFSHARESERVICES=https://downloads.loftux.net/alfresco/alfresco-share-services/LX100/alfresco-share-services-LX100.amp
ENV GOOGLEDOCSREPO=https://downloads.loftux.net/public/content/org/alfresco/integrations/alfresco-googledocs-repo/3.0.4.1/alfresco-googledocs-repo-3.0.4.1.amp
ENV GOOGLEDOCSSHARE=https://downloads.loftux.net/public/content/org/alfresco/integrations/alfresco-googledocs-share/3.0.4.1/alfresco-googledocs-share-3.0.4.1.amp
ENV AOS_VTI=https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/aos-module/alfresco-vti-bin/1.1.5/alfresco-vti-bin-1.1.5.war
ENV AOS_SERVER_ROOT=https://downloads.loftux.net/public/content/org/alfresco/alfresco-server-root/5.2.g/alfresco-server-root-5.2.g.war
ENV AOS_AMP=https://downloads.loftux.net/public/content/org/alfresco/aos-module/alfresco-aos-module/1.1.6/alfresco-aos-module-1.1.6.amp
ENV TTF_MSCORE_INSTALLER=ttf-mscorefonts-installer_3.6_all.deb
ENV TTF_MSCORE_INSTALL_URL=http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/$TTF_MSCORE_INSTALLER
ENV SOLR4_CONFIG_DOWNLOAD=https://downloads.loftux.net/alfresco/alfresco-solr4/LX100/alfresco-solr4-LX100-config-ssl.zip
ENV SOLR4_WAR_DOWNLOAD=https://downloads.loftux.net/alfresco/alfresco-solr4/LX100/alfresco-solr4-LX100.war

# Create working directories
RUN mkdir /tmp/alfrescoinstall && \
    mkdir -p /opt/alfresco/addons/war && \
    mkdir -p /opt/alfresco/addons/share && \
    mkdir -p /opt/alfresco/addons/alfresco && \
    mkdir -p /opt/alfresco/addons/custom-alfresco && \
    mkdir -p /opt/alfresco/addons/custom-share && \
    mkdir -p /opt/alfresco/modules/platform && \
    mkdir -p /opt/alfresco/modules/share && \
    mkdir -p /opt/alfresco/bin && \
    mkdir -p /opt/alfresco/solr4 && \
    mkdir -p /opt/alfresco/keystore && \
    mkdir -p /opt/alfresco/logs 
    
# Execute all in one layer so that it keeps the image as small as possible
RUN apt-get update && \
    apt-get install -y unzip curl wget fonts-noto \
                   fontconfig libcups2 libfontconfig1 libglu1-mesa \
                   libice6 libsm6 libxinerama1 libxrender1 libxt6 \
                   imagemagick ghostscript libjpeg62 libpng3 \
                   mysql-client xfonts-utils cabextract && \ 
    ln -s /etc/ImageMagick-6 /etc/ImageMagick && \
    rm -rf /var/lib/apt/lists/*

# Fix Settings
RUN echo "alfresco  soft  nofile  8192" | tee -a /etc/security/limits.conf && \
    echo "alfresco  hard  nofile  65536" | tee -a /etc/security/limits.conf && \
    echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session && \
    echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session-noninteractive

# Install Microsoft Fonts
RUN cd /tmp/alfrescoinstall && \
    wget $TTF_MSCORE_INSTALL_URL && \
    dpkg -i $TTF_MSCORE_INSTALLER

# Install Tomcat 
RUN cd /tmp/alfrescoinstall && \
    curl -# -L -O $TOMCAT_DOWNLOAD && \
    tar xf "$(find . -type f -name "apache-tomcat*")" && \
    mv "$(find . -type d -name "apache-tomcat*")" /opt/alfresco/tomcat && \
    rm -rf /opt/alfresco/tomcat/webapps/* && \
    mkdir -p /opt/alfresco/tomcat/shared/classes/alfresco/extension && \
    mkdir -p /opt/alfresco/tomcat/shared/classes/alfresco/web-extension && \
    mkdir -p /opt/alfresco/tomcat/shared/lib && \
    mkdir -p /opt/alfresco/tomcat/endorsed && \
    mkdir -p /opt/alfresco/tomcat/conf/Catalina/localhost

# Install MySQL JBDC Connector
RUN cd /tmp/alfrescoinstall && \
    curl -# -L -O $JDBCMYSQLURL/$JDBCMYSQL && \
    tar xf $JDBCMYSQL && \
    cd "$(find . -type d -name "mysql-connector*")" && \
    mv mysql-connector*.jar /opt/alfresco/tomcat/lib 

# Install LibreOffice & Rendering Tools
RUN cd /tmp/alfrescoinstall && \
    curl -# -L -O $LIBREOFFICE && \
    tar xf LibreOffice*.tar.gz && \
    cd "$(find . -type d -name "LibreOffice*")" && \
    cd DEBS && \
    rm *gnome-integration*.deb && \
    rm *kde-integration*.deb && \
    rm *debian-menus*.deb && \
    dpkg -i *.deb && \
    curl -# -o /tmp/alfrescoinstall/alfresco-pdf-renderer.tgz $ALFRESCO_PDF_RENDERER && \
    tar -xf /tmp/alfrescoinstall/alfresco-pdf-renderer.tgz -C /tmp/alfrescoinstall && \
    mv /tmp/alfrescoinstall/alfresco-pdf-renderer /opt/alfresco/bin/ 

# Deploy Alfresco Support Files
RUN cd /tmp/alfrescoinstall && \
    curl -# -o /opt/alfresco/addons/war/alfresco.war $ALFREPOWAR && \
    curl -# -o /opt/alfresco/addons/war/share.war $ALFSHAREWAR && \
    curl -# -O $ALFSHARESERVICES && \
    curl -# -o /opt/alfresco/addons/alfresco-mmt.jar $ALFMMTJAR && \
    mv alfresco-share-services*.amp /opt/alfresco/addons/alfresco/ 

# Deploy Google Docs Integration
RUN cd /tmp/alfrescoinstall && \
    curl -# -O $GOOGLEDOCSREPO && \
    mv alfresco-googledocs-repo*.amp /opt/alfresco/addons/alfresco/ && \
    curl -# -O $GOOGLEDOCSSHARE && \
    mv alfresco-googledocs-share* /opt/alfresco/addons/share/

# Alfresco Office Services
RUN cd /tmp/alfrescoinstall && \
    curl -# -O $AOS_AMP && \
    curl -# -O $AOS_VTI && \
    curl -# -O $AOS_SERVER_ROOT && \
    mv alfresco-aos-module*.amp /opt/alfresco/addons/alfresco && \
    mv alfresco-vti-bin-1.1.5.war /opt/alfresco/tomcat/webapps/_vti_bin.war && \
    mv alfresco-server-root-5.2.g.war /opt/alfresco/tomcat/webapps/ROOT.war


# Instal SOLR4
RUN cd /opt/alfresco/solr4 && \
  curl -# -o /opt/alfresco/tomcat/webapps/solr4.war $SOLR4_WAR_DOWNLOAD && \
  curl -# -o /opt/alfresco/solr4/solrconfig.zip $SOLR4_CONFIG_DOWNLOAD  && \
  unzip -q solrconfig.zip && \
  rm solrconfig.zip

RUN mkdir -p /opt/alfresco/alf_data/solr4 && \
  mv /opt/alfresco/solr4/workspace-SpacesStore/conf/solrcore.properties /opt/alfresco/solr4/workspace-SpacesStore/conf/solrcore.properties.orig  && \
  mv /opt/alfresco/solr4/archive-SpacesStore/conf/solrcore.properties /opt/alfresco/solr4/archive-SpacesStore/conf/solrcore.properties.orig && \
  sed "s/@@ALFRESCO_SOLR4_DATA_DIR@@/\/opt\/alfresco\/alf_data\/solr4/g" /opt/alfresco/solr4/workspace-SpacesStore/conf/solrcore.properties.orig >  /tmp/alfrescoinstall/solrcore.properties && \
  mv /tmp/alfrescoinstall/solrcore.properties /opt/alfresco/solr4/workspace-SpacesStore/conf/solrcore.properties && \
  sed "s/@@ALFRESCO_SOLR4_DATA_DIR@@/\/opt\/alfresco\/alf_data\/solr4/g" /opt/alfresco/solr4/archive-SpacesStore/conf/solrcore.properties.orig >  /tmp/alfrescoinstall/solrcore.properties && \
  mv /tmp/alfrescoinstall/solrcore.properties /opt/alfresco/solr4/archive-SpacesStore/conf/solrcore.properties && \
  echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > /tmp/alfrescoinstall/solr4.xml && \
  echo "<Context debug=\"0\" crossContext=\"true\">" >> /tmp/alfrescoinstall/solr4.xml && \
  echo "  <Environment name=\"solr/home\" type=\"java.lang.String\" value=\"/opt/alfresco/solr4\" override=\"true\"/>" >> /tmp/alfrescoinstall/solr4.xml && \
  echo "  <Environment name=\"solr/model/dir\" type=\"java.lang.String\" value=\"/opt/alfresco/solr4/alfrescoModels\" override=\"true\"/>" >> /tmp/alfrescoinstall/solr4.xml && \
  echo "  <Environment name=\"solr/content/dir\" type=\"java.lang.String\" value=\"/opt/alfresco/alf_data/solr4/content\" override=\"true\"/>" >> /tmp/alfrescoinstall/solr4.xml && \
  echo "</Context>" >> /tmp/alfrescoinstall/solr4.xml && \
  mv /tmp/alfrescoinstall/solr4.xml /opt/alfresco/tomcat/conf/Catalina/localhost/solr4.xml

# Deploy Keystore
RUN mkdir -p /opt/alfresco/keystore && \
    cd /tmp/alfrescoinstall && \
    curl -# -o /opt/alfresco/keystore/browser.p12 $KEYSTOREBASE/browser.p12 && \
    curl -# -o /opt/alfresco/keystore/generate_keystores.sh $KEYSTOREBASE/generate_keystores.sh  && \
    curl -# -o /opt/alfresco/keystore/keystore $KEYSTOREBASE/keystore  && \
    curl -# -o /opt/alfresco/keystore/keystore-passwords.properties $KEYSTOREBASE/keystore-passwords.properties  && \
    curl -# -o /opt/alfresco/keystore/ssl-keystore-passwords.properties $KEYSTOREBASE/ssl-keystore-passwords.properties  && \
    curl -# -o /opt/alfresco/keystore/ssl-truststore-passwords.properties $KEYSTOREBASE/ssl-truststore-passwords.properties  && \
    curl -# -o /opt/alfresco/keystore/ssl.keystore $KEYSTOREBASE/ssl.keystore && \
    curl -# -o /opt/alfresco/keystore/ssl.truststore $KEYSTOREBASE/ssl.truststore

# Copy Tomcat required files 
ADD tomcat/catalina.properties /opt/alfresco/tomcat/conf/catalina.properties
ADD tomcat/context.xml /opt/alfresco/tomcat/conf/context.xml
ADD tomcat/server.xml /opt/alfresco/tomcat/conf/server.xml
ADD tomcat/tomcat-users.xml /opt/alfresco/tomcat/conf/tomcat-users.xml
ADD tomcat/alfresco.xml /opt/alfresco/tomcat/conf/Catalina/localhost/alfresco.xml 
ADD tomcat/share.xml /opt/alfresco/tomcat/conf/Catalina/localhost/share.xml 

# Deploy scripts & fix permissions
ADD tomcat/alfresco-global.properties /opt/alfresco/tomcat/shared/classes/alfresco-global-template.properties
ADD tomcat/share-config-custom.xml /opt/alfresco/tomcat/shared/classes/alfresco/web-extension/share-config-custom-template.xml
ADD scripts/apply.sh /opt/alfresco/addons/apply.sh
ADD scripts/entrypoint.sh /opt/alfresco/bin/entrypoint.sh
ADD scripts/limitconvert.sh /opt/alfresco/bin/limitconvert.sh
ADD scripts/mysql.sh /opt/alfresco/bin/mysql.sh
ADD scripts/libreoffice.sh /opt/alfresco/bin/libreoffice.sh

RUN chmod u+x /opt/alfresco/addons/apply.sh && \ 
    chmod a+x /opt/alfresco/bin/libreoffice.sh && \
    chmod a+x /opt/alfresco/bin/mysql.sh && \
    chmod a+x /opt/alfresco/bin/limitconvert.sh && \
    chmod a+x /opt/alfresco/bin/entrypoint.sh

EXPOSE 8080 1445 1139 1137 1138 2121 20000-20999

CMD ["/opt/alfresco/bin/entrypoint.sh"]