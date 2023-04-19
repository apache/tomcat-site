#!/bin/sh
#
# Assists updating the web site to include a new release.
#
# Run update-version.sh with -h or --help for usage instructions.
#

SCRIPT_DIR=$( dirname $0 )
EDITOR=${EDITOR:-vi}
OLD_RELEASE=$1
NEW_RELEASE=$2
RELEASE_DATE=${3:-$(date -I)}

function fail_migration_patch() {
  FAILED_MIGRATION=1

  echo "====="
  echo "Something went wrong patching ${MIGRATION_FILENAME}; rolling-back changes. File already updated?"
  echo "====="
  rm -f "${MIGRATION_FILENAME}.new"
}

if [ \( "$1" == '-h' \) -o \( "$1" == "--help" \) ] ; then
  echo "Usage: $0 oldrelease newrelease [release date]"
  echo
  echo e.g. $0 8.5.86 8.5.87 2023-03-03
  echo
  echo The release date will default to "today" in your current time zone.
  echo
  exit 0
fi
if [ \( "" == "$NEW_RELEASE" \) -o \( "" == "$OLD_RELEASE" \) ] ; then
  >&2 echo "You must specify both new and old release numbers"
  >&2 echo
  >&2 echo "Usage: $0 oldrelease newrelease [release date]"
  >&2 echo
  >&2 echo e.g. $0 8.5.85 8.5.86 2023-03-03
  >&2 echo
  exit 1
fi

MINOR_RELEASE=$( expr "${NEW_RELEASE}" : '^\([0-9]*\.[0-9]*\)' )
MAJOR_RELEASE=$( expr "${NEW_RELEASE}" : '^\([0-9]*\)' )

if [ "$DEBUG" == "1" ] ; then
  echo major=$MAJOR_RELEASE
  echo minor=$MINOR_RELEASE
  echo $NEW_RELEASE / $OLD_RELEASE
  echo RELEASE_DATE=$RELEASE_DATE
fi

if [ "8" = "${MAJOR_RELEASE}" ] ; then
  DOWNLOAD_FILENAME=xdocs/download-80.xml
elif [ "9" = "${MAJOR_RELEASE}" ] ; then
  DOWNLOAD_FILENAME=xdocs/download-90.xml
else
  DOWNLOAD_FILENAME=xdocs/download-${MAJOR_RELEASE}.xml
fi

if [ "8.5" = "${MINOR_RELEASE}" ] ; then 
  MIGRATION_FILENAME=xdocs/migration-85.xml
elif [ "9.0" = "${MINOR_RELEASE}" ] ; then
  MIGRATION_FILENAME=xdocs/migration-90.xml
else
  MIGRATION_FILENAME=xdocs/migration-${MINOR_RELEASE}.xml
fi

# build.properties.default
# Set the current minor release to point to the new release
# e.g. tomcat10.0=10.0.27
echo "Patching build.properties.default..."
sed -i '' -e "s/tomcat${MINOR_RELEASE}=.*/tomcat${MINOR_RELEASE}=$NEW_RELEASE/" build.properties.default

# Download file
# set the version number to the latest
# e.g. [define v]8.5.87[end]
echo "Patching ${DOWNLOAD_FILENAME}..."
sed -i '' -e "s/\[define v]${MINOR_RELEASE}.*\[end\]/[define v]${NEW_RELEASE}[end]/" "${DOWNLOAD_FILENAME}"

# whichversion.xml
# set the current point-release version 
# e.g. <td>10.1.7</td>
echo "Patching xdocs/whichversion.xml..."
sed -i '' -e "s/<td>${MINOR_RELEASE}\.[0-9]*<\/td>/<td>${NEW_RELEASE}<\/td>/" "xdocs/whichversion.xml"

# CHANGELOG
#
# The changelog needs to be merged AFTER the javadocs have been built.
#
# Set the release date.
# e.g. <span id="Tomcat_8.5.87_(schultz)_rtext" style="float: right;">2023-03-03</span>
CHANGELOG_FILENAME=docs/tomcat-${MINOR_RELEASE}-doc/changelog.html
echo "Patching ${CHANGELOG_FILENAME}..."
sed -i '' -e "s/\(<span id=\"Tomcat_${NEW_RELEASE}.*_rtext\"[^>]*>\)[^<]*/\1${RELEASE_DATE}/" "${CHANGELOG_FILENAME}"

# Migration file
# Add new entries for the old and new releases like this:
# In the "from" drop-down:
# - remove 'selected' attribute from any old release
# - add 'selected' attribute to old release
# - add the new release
#
# In the "to" drop-down:
# - remove 'selected' from the old release
# - add the new release, including 'selected' attribute
#
# This is not possible with sed nor XSLT
#
# sed -e "s/<option value=\"${OLD_RELEASE}\" selected=\"selected\">${OLD_RELEASE}<\/option>/<option value=\"${OLD_RELEASE}\">${OLD_RELEASE}<\/option>\n    <option value=\"${NEW_RELEASE}\" selected=\"selected\">${NEW_RELEASE}<\/option>/" "${MIGRATION_FILENAME}" > migration.xml
echo "Patching ${MIGRATION_FILENAME}..."
"${SCRIPT_DIR}/migration.pl" "${OLD_RELEASE}" "${NEW_RELEASE}" "${MIGRATION_FILENAME}" > "${MIGRATION_FILENAME}.new" && mv "${MIGRATION_FILENAME}.new" "${MIGRATION_FILENAME}" || fail_migration_patch

echo
echo "Now you will have to edit xdocs/index.xml and xdocs/oldnews.xml"
echo "to move the ${OLD_RELEASE} release announcement to xdocs/oldnews.xml"
echo "and add the ${NEW_RELEASE} release announcement to xdocs/index.xml."
echo
echo "Press ENTER to continue..."
read

"${EDITOR}" xdocs/index.xml xdocs/oldnews.xml

# xdocs/doap_Tomcat.rdf
# Set the release date and revision number e.g.
#    <release>
#      <Version>
#        <name>Latest Stable 8.5.x Release</name>
#        <created>2023-03-03</created>
#        <revision>8.5.88</revision>
#      </Version>
#    </release>
#
# This is difficult/impossible to do with just sed. This is also difficult to do
# with XSLT as it will re-format the file in some ways that make it less readable.
# sed -i '' -e "s/<revision>${MINOR_RELEASE}\.[0-9]*<\/revision>/<revision>${NEW_RELEASE}<\/revision>/" "xdocs/doap_Tomcat.rdf"
#
# We will do it in Perl
echo "Patching xdocs/doap_Tomcat.rdf..."
"${SCRIPT_DIR}/doap.pl" "${NEW_RELEASE}" "${RELEASE_DATE}" "xdocs/doap_Tomcat.rdf" > "xdocs/doap_Tomcat.rdf.new" && mv "xdocs/doap_Tomcat.rdf.new" "xdocs/doap_Tomcat.rdf"

echo "Building release documents..."

ant "release-${MINOR_RELEASE}"

echo
echo "Done. You should run 'svn status' to see whcih files changed, and maybe an 'svn diff' on some of them."
if [ "1" == "$FAILED_MIGRATION" ] ; then
echo
echo "NOTE: The patch for ${MIGRATION_FILENAME} failed; you may want to examine the situation manually."
fi
