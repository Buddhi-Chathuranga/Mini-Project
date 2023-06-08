<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:java="ifs.fnd.tc.framework.xml.TransformerFactory"
      exclude-result-prefixes="java">
  <xsl:template match="/">
    <xsl:for-each select="*">
      <xsl:element name="{java:toIFSXMLCase(name())}">
        <xsl:call-template name="toIFSXMLCaseTemplate">
          <xsl:with-param name="p" select="current()" />
        </xsl:call-template>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="toIFSXMLCaseTemplate">
    <xsl:for-each select="*">
      <xsl:element name="{java:toIFSXMLCase(name())}">
        <xsl:value-of select="text()"/>
        <xsl:call-template name="toIFSXMLCaseTemplate">
          <xsl:with-param name="p" select="current()" />
        </xsl:call-template>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
