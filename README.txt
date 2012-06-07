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
you simply need to edit the files in the xdocs/ directory.

The files in xdocs/stylesheets are the global files for the site. If you make a
modification to project.xml, it will affect the left side navigation for the
web site and all of your .html files will be re-generated.

Once you have built your documentation and confirmed that your changes are
ok, you can check your .xml and your .html files back into SVN.

Then, in the /www/tomcat.apache.org/ directory, execute:

svn up

to have the changes reflected on the Tomcat web site.



To update the documentation for Tomcat 5.5.x, Tomcat 6.0.x, Tomcat 7.0.x:
==========================================================================

1. Create build.properties file if you have not done so yet and set
   "base.path" property in it. E.g.

      base.path=..

   The documentation bundles will be downloaded and untarred into
   "${base.path}/tomcat-site-docs/"

2. Set the version numbers in build.properties.default

3. cd into your tomcat-site directory and execute one of the following
   commands:

   ant release-5
   ant release-6
   ant release-7

4. Check the changes with "svn status" command.

   Remember there may be deleted / missing files (shown with '!')
   and new files (shown with '?').

   Apply "svn delete" and "svn add" on those files as needed.

5. Commit the changes. 

6. In the /www/tomcat.apache.org/ directory on people.a.o execute:

   umask 002
   svn up



To update the documentation for Tomcat Native or Tomcat Connectors:
====================================================================

One way to update documentation is to:

 - Build it in those projects, e.g. as a part of release process,
   and to replace docs/native-doc or docs/connectors-doc with the docs
   that you have built.

Another way is to call the bring the sources into this project and build
them here.

For the latter:

1. One of two variants:

A)

   Use "svn switch" command to switch jk-xdocs or native-1.1-xdocs
   directories to xdocs directory of trunk or tag in those projects.

   The command looks like the following:

   To switch to current development versions:

      svn switch "^/tomcat/jk/trunk/xdocs" jk-xdocs
      svn switch "^/tomcat/native/branches/1.1.x/xdocs" native-1.1-xdocs

   To switch to tags for released versions:

      svn switch "^/tomcat/jk/tags/JK_1_2_37/xdocs" jk-xdocs
      svn switch "^/tomcat/native/tags/TOMCAT_NATIVE_1_1_23/xdocs" native-1.1-xdocs

   To switch back to empty directories:

      svn switch "^/tomcat/site/trunk/jk-xdocs" jk-xdocs
      svn switch "^/tomcat/site/trunk/native-1.1-xdocs" native-1.1-xdocs


   To check to what URLs switched directories are mapped:

      svn info jk-xdocs
      svn info native-1.1-xdocs

B)

   Or just copy the contents of "xdocs" directory from source
   distributive of released version into empty jk-xdocs or native-1.1-xdocs
   directories.

2. cd into your tomcat-site directory and execute one of the following
commands:

   ant release-native
   ant release-jk

3. Check the changes with "svn status" command.

 - Remember that there may be deleted / missing files or new files.

4. Commit the changes.
5. In the /www/tomcat.apache.org/ directory on people.a.o execute:

   umask 002
   svn up
