<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fmp="http://www.filemaker.com/fmpdsoresult" version="1.0">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="//fmp:ROW">
        <pbcoreDescriptionDocument xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" schemaVersion="2.0">
            <pbcoreIdentifier>
                <xsl:attribute name="source">MARS Program Record ID</xsl:attribute>
                <xsl:value-of select="ID_PROGRAM/text()" />              
            </pbcoreIdentifier>
            <xsl:apply-templates select="*[normalize-space()]"></xsl:apply-templates>
        </pbcoreDescriptionDocument>
    </xsl:template>
                  
    <xsl:template match="fmp:TITLE_SERIES">
        <pbcoreTitle>
            <xsl:attribute name="titleType">Series</xsl:attribute>
            <xsl:value-of select="text()" />
        </pbcoreTitle>
    </xsl:template>    

    <xsl:template match="fmp:TITLE_PROGRAM">
      <pbcoreTitle>
        <xsl:attribute name="titleType">Program</xsl:attribute>
        <xsl:value-of select="text()" />
      </pbcoreTitle>
    </xsl:template>

    <xsl:template match="fmp:DATE_RELEASE">
        <pbcoreAssetDate>
            <xsl:attribute name="dateType">broadcast</xsl:attribute>
            <xsl:value-of select="text()" />
        </pbcoreAssetDate>
    </xsl:template>

    <xsl:template match="fmp:COVERAGE_DATE_PORTRAYED">
        <pbcoreCoverage>
            <coverage>
            <xsl:value-of select="text()" />
            </coverage>
            <coverageType>temporal</coverageType>
        </pbcoreCoverage>
    </xsl:template>

    
    <xsl:template match="fmp:RIGHTS_SUMMARY">
        <pbcoreRightsSummary>
            <rightsSummary>
                <xsl:attribute name="annotation">rights summary</xsl:attribute>
                <xsl:attribute name="source">WGBH MARS</xsl:attribute>
                <xsl:value-of select="text()"/>
            </rightsSummary>
        </pbcoreRightsSummary>
    </xsl:template>

    <xsl:template match="fmp:ID_NOLA">
        <pbcoreIdentifier>
            <xsl:attribute name="source">NOLA Code</xsl:attribute>
            <xsl:value-of select="text()" />
        </pbcoreIdentifier>
    </xsl:template>
    
    <xsl:template match="fmp:SOURCE_PROGRAM_NUMBER">
        <pbcoreTitle> 
            <xsl:attribute name="titleType">Episode</xsl:attribute>
            <xsl:value-of select="text()"/>
        </pbcoreTitle>
    </xsl:template>
                   
    <xsl:template match="fmp:DESCRIPTION_PROGRAM">
        <pbcoreDescription>
            <xsl:attribute name="descriptionType">Program</xsl:attribute>
            <xsl:attribute name="descriptionTypeRef">http://metadataregistry.org/concept/show/id/1702.html</xsl:attribute>
            <xsl:value-of select="text()" />
        </pbcoreDescription>
    </xsl:template>
    
    <xsl:template match="fmp:Producer">
        <pbcoreCreator>
            <creator><xsl:value-of select="text()"/></creator>
            <creatorRole ref="http://metadataregistry.org/concept/show/id/1425.html">Producer</creatorRole>
        </pbcoreCreator>
    </xsl:template>
    
    <xsl:template match="text()" />
</xsl:stylesheet>
