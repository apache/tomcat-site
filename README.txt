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



To update the documentation for Tomcat 5.5.x, Tomcat 6.0.x, Tomcat 7.0.x

1. Set the version numbers in build.properties.default
2. cd into your tomcat-site directory and execute:
   ant release
3. Check in the changes. Remember there may be deleted / missing files.
4. In the /www/tomcat.apache.org/ directory on people.a.o execute:
   umask 002
   svn up



To update the documentation for Tomcat Native or the 
Merging connectors documentation

1. Update the svn-external for tomcat-site to point to the correct revision.
   This *must* match the tag for the latest released version.
2. cd into your tomcat-site directory and execute:
   svn up
   ant release
3. Check in the changes. Remember there may be deleted / missing files.
4. In the /www/tomcat.apache.org/ directory on people.a.o execute:
   umask 002
   svn up
