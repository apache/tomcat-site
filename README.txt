$Id$

The Apache Tomcat Website Instructions
---------------------------------------

***NOTE***
DO NOT EDIT THE .html files in the docs directory.
Please follow the directions below for updating the website.
***NOTE***

The Tomcat web site is based on .xml files which are transformed
into .html files using XSLT and Ant.

In order to make modifications to the Tomcat web site, you need to first check out
the Tomcat site from SVN. To check out the Tomcat site into a sub-directory
called tomcat-site in the current directory:

svn checkout https://svn.apache.org/repos/asf/tomcat/site/trunk tomcat-site

Once you have the site checked out locally, cd into your
tomcat-site directory and execute:

ant

This will build the documentation into the docs/ directory. The output
will show you which files got re-generated.

If you would like to make modifications to the web site documents,
you simply need to edit the files in the xdocs/ and/or xdocs-faq/ directory.

The files in xdocs/stylesheets are the global files for the site. If you make a
modification to project.xml, it will affect the left side navigation for the
web site and all of your .html files will be re-generated.

The xdocs-faq directory has its own project.xml and tomcat-faq.xsl

Once you have built your documentation and confirmed that your changes are
ok, you can check your .xml and your .html files back into SVN.

Then, in the /www/tomcat.apache.org/ directory, execute:

svn up

to have the changes reflected on the Tomcat web site.

Merging connectors documentation

Tomcat Native and JK connector have their own documentation that
needs to get updated on release. Beside updating release notes and
download page that should reflect the current stable, it is needed
to copy those documents as well.
Currently this is manual procedure that involves copying connector
documentation and modifying symbolic links

When releasing Tomcat native create a new native-doc-x.y.z directory
and upload the documentation created with calling ant inside
native's xdoc directory.
Once you have done that update the symlink to point to that new location.
Inside  /www/tomcat.apache.org/ directory, execute:

ln -sf native-doc-x.y.x native-doc

Similar should be done for JK connector documentation with the exception
that all symbolic link for the connectors-doc should point to the
connectors-doc-x.y.z

ln -sf connectors-doc-x.y.x connectors-doc

