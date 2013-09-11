<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!-- Content Stylesheet for "tomcat-site" Documentation -->

<!-- $Id$ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0">


  <!-- Output method -->
  <xsl:output method="html"
              html-version="5.0"
              encoding="UTF-8"
              indent="yes"
              doctype-system="about:legacy-compat"/>


  <!-- Defined parameters (overrideable) -->
  <xsl:param    name="relative-path" select="'.'"/>
  <xsl:param    name="home-logo"     select="'/images/tomcat.png'"/>
  <xsl:param    name="buglink"       select="'https://issues.apache.org/bugzilla/show_bug.cgi?id='"/>
  <xsl:param    name="revlink"       select="'http://svn.apache.org/viewvc?view=rev&amp;rev='"/>
  <xsl:param    name="cvelink"       select="'http://cve.mitre.org/cgi-bin/cvename.cgi?name='"/>

  <!-- Defined variables (non-overrideable) -->


  <!-- Process an entire document into an HTML page -->
  <xsl:template match="document">
    <xsl:variable name="project"
                select="document('project.xml')/project"/>

<html lang="en">
<head>
  <!-- Note: XLST seems to always output a
       <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
       when method="html",
       therefore we can't use
       <meta charset="UTF-8"/>.

       In XHTML, this is not needed as the encoding will be
       specified in the XML declaration.
  -->
  <link href="stylesheets/tomcat.css" rel="stylesheet" type="text/css"/>
  <link href="stylesheets/tomcat-printer.css" rel="stylesheet" type="text/css" media="print"/>
    <xsl:apply-templates select="meta"/>
    <title><xsl:value-of select="$project/title"/> - <xsl:value-of select="properties/title"/></title>
    <xsl:for-each select="properties/author">
      <xsl:variable name="name">
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:variable name="email">
        <xsl:value-of select="@email"/>
      </xsl:variable>
      <meta name="author" content="{$name}"/>
      <!-- Don't publish e-mail addresses
      <meta name="email" content="{$email}"/>
       -->
    </xsl:for-each>
    <xsl:for-each select="properties/google-site-verification">
      <meta name="google-site-verification" content="{.}"/>
    </xsl:for-each>
    <xsl:if test="properties/base">
      <base href="{properties/base/@href}"/>
    </xsl:if>
  </head>

  <body>
  <div id="wrapper">
  <header><div id="header">
    <div>
      <div>
          <xsl:variable name="src">
            <xsl:value-of select="$relative-path"/><xsl:value-of select="$home-logo"/>
          </xsl:variable>
          <div class="logo noPrint">
            <a href="{project/@href}"><img alt="Tomcat Home" src="{$src}"/></a>
          </div>

        <div style="height: 1px;"/>
        <div class="asfLogo"><a href="http://www.apache.org/" target="_blank"><img src="http://www.apache.org/images/feather.png" alt="The Apache Software Foundation" style="width: 266px; height: 83px;"/></a></div>
        <h1 style="margin-top: 35px;"><xsl:value-of select="$project/title"/></h1>
        <div style="clear: right;"/>

    <!-- Search box: uses CSS positioning -->
    <div class="searchbox noPrint">
      <form action="http://www.google.com/search" method="get">
        <input value="tomcat.apache.org" name="sitesearch" type="hidden" />
        <input placeholder="Search the Site…" required="required" size="25" name="q" id="query" type="search" />
        <button>Search</button>
      </form>
    </div>
    <!-- End search box -->

        <div style="height: 1px;"/>
        <div style="clear: left;"/>
      </div>
    </div>
  </div></header>

  <div id="middle">
    <div>
      <div id="mainLeft" class="noprint">
        <div>
          <!-- Navigation -->
          <nav>
            <xsl:apply-templates select="$project/body/menu"/>
          </nav>
        </div>
      </div>
      <div id="mainRight">
        <div id="content">
          <!-- Main Part -->
          <!-- Hidden heading -->
          <h2 style="display: none;">Content</h2>
          <xsl:apply-templates select="body/section"/>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <footer><div id="footer">
    Copyright © 1999-2013, The Apache Software Foundation
    <br/>
    Apache Tomcat, Tomcat, Apache, the Apache feather, and the Apache Tomcat
    project logo are trademarks of the Apache Software Foundation.
  </div></footer>
</div>
</body>
</html>

  </xsl:template>


  <!-- Process a menu for the navigation bar -->
  <xsl:template match="menu">
  <div>
    <h2><strong><xsl:value-of select="@name"/></strong></h2>
    <ul>
      <xsl:apply-templates select="item"/>
    </ul>
  </div>
  </xsl:template>


  <!-- Process a menu item for the navigation bar -->
  <xsl:template match="item">
    <xsl:variable name="href">
      <xsl:choose>
            <xsl:when test="starts-with(@href, 'http://')">
                <xsl:value-of select="@href"/>
            </xsl:when>
            <xsl:when test="starts-with(@href, 'https://')">
                <xsl:value-of select="@href"/>
            </xsl:when>
            <xsl:when test="starts-with(@href, '/site')">
                <xsl:text>http://tomcat.apache.org</xsl:text><xsl:value-of select="@href"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$relative-path"/><xsl:value-of select="@href"/>
            </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li><a href="{$href}"><xsl:value-of select="@name"/></a></li>
  </xsl:template>


  <!-- Process a documentation section -->
  <xsl:template match="section">
    <xsl:variable name="name2">
      <xsl:choose>
        <xsl:when test="@anchor">
          <xsl:value-of select="@anchor" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="name">
      <xsl:value-of select="translate($name2, ' #', '__')"/>
    </xsl:variable>

    <!-- Section heading -->
    <h3 id="{$name}">
      <xsl:if test="@rtext">
        <!-- Additional right-aligned text cell in section heading. -->
        <span style="float: right;">
          <xsl:value-of select="@rtext"/>
        </span><xsl:text>&#x20;</xsl:text> <!-- Ensure a space follows after </span> -->
      </xsl:if>
      <xsl:value-of select="@name"/>
    </h3>
    <!-- Section body -->
    <div class="text">
      <xsl:apply-templates/>
    </div>

  </xsl:template>


  <!-- Process a documentation subsection -->
  <xsl:template match="subsection">
    <xsl:variable name="name2">
      <xsl:choose>
        <xsl:when test="@anchor">
          <xsl:value-of select="@anchor" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="
              count(//*[(local-name()='section' or local-name()='subsection') and @name=current()/@name]) &gt; 1
              ">
            <xsl:value-of select="concat(ancestor::section/@name, '/')"/>
          </xsl:if>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="name">
      <xsl:value-of select="translate($name2, ' #', '__')"/>
    </xsl:variable>

    <div class="subsection">
      <!-- Subsection heading -->
      <!-- TODO: When a <subsection> is nested in another <subsection>,
           the output should be <h5>, not <h4>. Same with <h6>. -->
      <h4 id="{$name}">
        <xsl:value-of select="@name"/>
      </h4>
      <!-- Subsection body -->
      <div class="text">
        <xsl:apply-templates/>
      </div>
    </div>

  </xsl:template>


  <!-- Generate table of contents -->
  <xsl:template match="toc">
    <ul><xsl:apply-templates mode="toc" select="following::section"/></ul>
  </xsl:template>

  <xsl:template mode="toc" match="section|subsection">
    <xsl:variable name="name2">
      <xsl:choose>
        <xsl:when test="@anchor">
          <xsl:value-of select="@anchor" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="local-name()='subsection' and 
              count(//*[(local-name()='section' or local-name()='subsection') and @name=current()/@name]) &gt; 1
              ">
            <xsl:value-of select="concat(ancestor::section/@name, '/')"/>
          </xsl:if>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="name">
      <xsl:value-of select="translate($name2, ' #', '__')"/>
    </xsl:variable>
    <li><a href="#{$name}"><xsl:value-of select="@name"/></a>
    <xsl:if test="subsection">
      <ol><xsl:apply-templates mode="toc" select="subsection"/></ol>
    </xsl:if>
    </li>
  </xsl:template>


  <!-- Process a source code example -->
  <xsl:template match="source">
  <div class="codeBox">
    <pre>
      <xsl:if test="@wrapped='true'">
        <xsl:attribute name="class">wrap</xsl:attribute>
      </xsl:if>
      <code><xsl:apply-templates/></code>
    </pre>
  </div>
  </xsl:template>

  <!-- Link to a bug report -->
  <xsl:template match="bug">
      <xsl:variable name="link"><xsl:value-of select="$buglink"/><xsl:value-of select="text()"/></xsl:variable>
      <a href="{$link}"><xsl:apply-templates/></a>
  </xsl:template>

  <!-- Link to a SVN revision report -->
  <xsl:template match="rev">
      <xsl:variable name="link"><xsl:value-of select="$revlink"/><xsl:value-of select="text()"/></xsl:variable>
      <a href="{$link}">r<xsl:apply-templates/></a>
  </xsl:template>

  <!-- Link to a SVN revision report -->
  <!-- It is similat to <rev> tag, but allows arbitrary text inside -->
  <xsl:template match="revlink">
      <xsl:variable name="link"><xsl:value-of select="$revlink"/><xsl:value-of select="@rev"/></xsl:variable>
      <a href="{$link}"><xsl:apply-templates/></a>
  </xsl:template>

  <!-- Link to a CVE report -->
  <xsl:template match="cve">
      <xsl:variable name="link"><xsl:value-of select="$cvelink"/><xsl:value-of select="text()"/></xsl:variable>
      <a href="{$link}" rel="nofollow"><xsl:apply-templates/></a>
  </xsl:template>

  <!-- Process everything else by just passing it through -->
  <xsl:template match="*|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
