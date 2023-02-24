#!/bin/sh

RELEASE=${1:-8.5}
MAJOR_RELEASE=$( expr "${RELEASE}" : '^\([0-9]*\)' )
if [ "8" = "${MAJOR_RELEASE}" ] ; then
  DOWNLOAD_FILENAME=xdocs/download-80.xml
elif [ "9" = "${MAJOR_RELEASE}" ] ; then
  DOWNLOAD_FILENAME=xdocs/download-90.xml
else
  DOWNLOAD_FILENAME=xdocs/download-${MAJOR_RELEASE}.xml
fi

if [ "8.5" = "${RELEASE}" ] ; then 
  MIGRATION_FILENAME=xdocs/migration-85.xml
elif [ "9.0" = "${RELEASE}" ] ; then
  MIGRATION_FILENAME=xdocs/migration-90.xml
else
  MIGRATION_FILENAME=xdocs/migration-${RELEASE}.xml
fi

vi build.properties.default "${DOWNLOAD_FILENAME}" xdocs/index.xml xdocs/oldnews.xml xdocs/whichversion.xml "${MIGRATION_FILENAME}" xdocs/doap_Tomcat.rdf
