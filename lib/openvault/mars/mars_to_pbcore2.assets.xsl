<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fmp="http://www.filemaker.com/fmpdsoresult" version="1.0">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
      <pbcoreCollection>
        <xsl:apply-templates/>
      </pbcoreCollection>
    </xsl:template>
    
    <xsl:template match="//fmp:ROW">
        <pbcoreDescriptionDocument xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" schemaVersion="2.0">
            <pbcoreIdentifier>
                <xsl:attribute name="source">MARS Asset Record ID</xsl:attribute>
                <xsl:value-of select="fmp:ID_MARS/text()" />              
            </pbcoreIdentifier>
            <xsl:apply-templates select="*[normalize-space()]"></xsl:apply-templates>
            <pbcoreInstantiation>
                <xsl:apply-templates mode="instantiation" select="*[normalize-space()]"></xsl:apply-templates>
                <instantiationLocation>
                    <xsl:value-of select="concat(fmp:HOLDINGS_LOCATION/text(), '-', fmp:HOLDINGS_LOCATION_VAULT_ID/text(), '-', fmp:HOLDINGS_LOCATION_VAULT_SIDE/text(), '-', fmp:HOLDINGS_LOCATION_VAULT_BAY/text(), '-', fmp:HOLDINGS_LOCATION_VAULT_SHELF/text(), '-', fmp:HOLDING_LOCATION_VAULT_DRAWER/text())" />
                </instantiationLocation>

                <instantiationAlternativeModes>
                    <xsl:if test="fmp:FORMAT_CC_YN[text() = 'Yes']">
                        CC
                    </xsl:if>
                    <xsl:if test="fmp:FORMAT_DVS_YN[text() = 'Yes']">
                        DVS
                    </xsl:if>
                    <xsl:if test="fmp:FORMAT_VISIBLE_TIMECODE[text() = 'Yes']">
                        Visible Time Code
                    </xsl:if>
                </instantiationAlternativeModes>
                <essenceTrack>
                    <xsl:apply-templates mode="essencetrack" select="*[normalize-space()]"></xsl:apply-templates>                  
                </essenceTrack>
            </pbcoreInstantiation>
        </pbcoreDescriptionDocument>
    </xsl:template>
    
    <!-- pbcoreAssetType? -->

    <xsl:template match="fmp:COVERAGE_DATE_PORTRAYED">
        <pbcoreCoverage>
            <coverage>
            <xsl:value-of select="text()" />
            </coverage>
            <coverageType>Temporal</coverageType>
        </pbcoreCoverage>
    </xsl:template>

    <xsl:template match="fmp:DATE_RELEASED">
        <pbcoreAssetDate>
            <xsl:attribute name="dateType">Broadcast</xsl:attribute>
            <xsl:value-of select="text()" />
        </pbcoreAssetDate>
    </xsl:template>

    <xsl:template match="fmp:SOURCE_CREATION_ORDER">
        <pbcoreIdentifier>
            <xsl:attribute name="source">MARS Source Creation Order</xsl:attribute>
            <xsl:value-of select="text()"/>
        </pbcoreIdentifier>    
    </xsl:template>

    <xsl:template match="SOURCE_OLD_FILE_NUMBER">
        <pbcoreIdentifier>          
            <xsl:attribute name="source">WGBH Old File Number</xsl:attribute>
            <xsl:value-of select="text()"/>
        </pbcoreIdentifier>
    </xsl:template> 

    <xsl:template match="fmp:SOURCE_REFERENCE">
        <pbcoreIdentifier> 
            <xsl:attribute name="source">Source Reference Number</xsl:attribute>
            <xsl:value-of select="text()"/>
        </pbcoreIdentifier>
    </xsl:template>  
    
    <xsl:template match="fmp:SOURCE_TRACKING_NUMBER">
        <pbcoreIdentifier>
            <xsl:attribute name="source">Source Tracking Number</xsl:attribute>
            <xsl:value-of select="text()"/>
        </pbcoreIdentifier>
    </xsl:template>  

    <xsl:template match="fmp:TITLE_PROGRAM">
        <pbcoreTitle>
            <xsl:attribute name="titleType">Program</xsl:attribute>
            <xsl:value-of select="text()" />
        </pbcoreTitle>
    </xsl:template>

    <xsl:template match="fmp:SOURCE_PROGRAM_NUMBER">
        <pbcoreTitle> <!-- REALLY? -->
            <xsl:attribute name="titleType">Episode</xsl:attribute>
            <xsl:value-of select="text()"/>
        </pbcoreTitle>
    </xsl:template>
    
    <xsl:template match="fmp:TITLE_SERIES">
        <pbcoreTitle>
            <xsl:attribute name="titleType">Series</xsl:attribute>
            <xsl:value-of select="text()" />
        </pbcoreTitle>
    </xsl:template>

    <xsl:template match="fmp:TITLE_PROJECT">
        <pbcoreTitle>
            <xsl:attribute name="titleType">Project</xsl:attribute>
            <xsl:value-of select="text()"/>
        </pbcoreTitle>
    </xsl:template>
    
    <xsl:template match="fmp:DESCRIPTION_SUMMARY">
        <pbcoreDescription>
          <xsl:attribute name="descriptionType">Summary</xsl:attribute>
          <xsl:attribute name="descriptionTypeRef">http://metadataregistry.org/concept/show/id/1702.html</xsl:attribute>
          <xsl:value-of select="text()" />
       </pbcoreDescription>
    </xsl:template>

    <xsl:template match="fmp:SUBJECT_KEYWORDS">
        <pbcoreDescription>
            <xsl:attribute name="descriptionType">Keyword</xsl:attribute>
            <xsl:attribute name="descriptionTypeRef">http://metadataregistry.org/concept/show/id/1674.html</xsl:attribute>       
            <xsl:value-of select="text()"/>    
        </pbcoreDescription>
    </xsl:template>

    <xsl:template match="fmp:TYPE_CATEGORY">
        <pbcoreDescription>
          <xsl:attribute name="descriptionType">Item</xsl:attribute>
          <xsl:attribute name="descriptionTypeRef">http://metadataregistry.org/concept/show/id/1672.html</xsl:attribute>
          <xsl:value-of select="text()" />
       </pbcoreDescription>
    </xsl:template>

    <xsl:template match="fmp:COVERAGE_EVENT_LOCATION">
        <pbcoreCoverage>
            <xsl:attribute name="annotation">Location Portrayed</xsl:attribute>
            <coverage><xsl:value-of select="text()" /></coverage>
            <coverageType>spatial</coverageType>
        </pbcoreCoverage>
    </xsl:template>
    
    <xsl:template match="fmp:COVERAGE_PRODUCTION_LOCATION">
        <pbcoreCoverage>
            <xsl:attribute name="annotation">Production Location</xsl:attribute>
            <coverage><xsl:value-of select="text()" /></coverage>
            <coverageType>spatial</coverageType>
        </pbcoreCoverage>
    </xsl:template>

    <!-- pbcoreAudienceLevel? -->
    <!-- pbcoreAudienceRating? -->

    <xsl:template match="fmp:ANNOTATION">
        <pbcoreAnnotation>
            <xsl:value-of select="text()"/>
        </pbcoreAnnotation>
    </xsl:template>
    
    <xsl:template match="fmp:HOLDINGS_ORIGINATING_DEPARTMENT">
        <pbcoreCreator>
            <creator><xsl:value-of select="text()" /></creator>
            <creatorRole ref="http://metadataregistry.org/concept/show/id/1426.html">Production Unit</creatorRole>
        </pbcoreCreator>
    </xsl:template>
    
    <xsl:template name="PUBLISHER">
        <pbcorePublisher>
            <publisher><xsl:value-of select="text()"/></publisher>
            <publisherRole ref="http://metadataregistry.org/concept/show/id/1828.html">Publisher</publisherRole>
        </pbcorePublisher>
    </xsl:template>
    
    <xsl:template name="RIGHTS_HOLDER">
        <pbcorePublisher>
            <publisher><xsl:value-of select="text()"/></publisher>
            <publisherRole ref="http://metadataregistry.org/concept/show/id/1825.html">Copyright Holder</publisherRole>
        </pbcorePublisher>
    </xsl:template>

    <xsl:template match="fmp:SOURCE_COLLECTION">
      <pbcoreRightsSummary>
        <rightsSummary>
           <xsl:attribute name="annotation">source collection</xsl:attribute>
           <xsl:value-of select="text()"/>
         </rightsSummary>
      </pbcoreRightsSummary>
    </xsl:template>
    
    <xsl:template match="fmp:ID_ITEM"  mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="source">WGBH Item ID</xsl:attribute>
            <xsl:value-of select="text()" />
        </instantiationIdentifier>
    </xsl:template>

    <xsl:template match="fmp:ID_BARCODE" mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="source">WGBH Barcode</xsl:attribute>
            <xsl:value-of select="text()" />
        </instantiationIdentifier>
    </xsl:template>
    
    <xsl:template match="fmp:ID_FILE_NUMBER" mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="source">WGBH File Number</xsl:attribute>
            <xsl:value-of select="text()" />
        </instantiationIdentifier>
    </xsl:template>

    <xsl:template match="fmp:SOURCE_CAM_ROLL" mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="annotation">camera roll</xsl:attribute>
            <xsl:value-of select="text()"/>
        </instantiationIdentifier>
    </xsl:template>

    <xsl:template match="fmp:SOURCE_LAB_ROLL" mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="annotation">lab roll</xsl:attribute>
            <xsl:value-of select="text()"/>
        </instantiationIdentifier>
    </xsl:template>
    
    <xsl:template match="fmp:SOURCE_REEL" mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="annotation">reel number</xsl:attribute>
            <xsl:value-of select="text()"/>
        </instantiationIdentifier>
    </xsl:template>
    
    <xsl:template match="fmp:SOURCE_SOUND_ROLL" mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="annotation">sound roll</xsl:attribute>
            <xsl:value-of select="text()"/>
        </instantiationIdentifier>
    </xsl:template>
    
    <xsl:template match="fmp:d_dam_entity_path" mode="instantiation">
        <instantiationIdentifier>
            <xsl:attribute name="annotation">DAM file name</xsl:attribute>
            <xsl:value-of select="text()"/>
        </instantiationIdentifier>
    </xsl:template>
    
    <xsl:template match="fmp:DATE_ITEM" mode="instantiation">
        <instantiationDate>
            <xsl:attribute name="dateType">Created</xsl:attribute>
            <xsl:value-of select="text()" />
        </instantiationDate>
    </xsl:template>
        
    <xsl:template match="fmp:c_uploaded[text() = 1]" mode="instantiation">
        <instantiationDigital>
            <xsl:attribute name="source">WGBH MARS</xsl:attribute>
            Digital Image
        </instantiationDigital>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_ITEM" mode="instantiation">
        <instantiationPhysical>
            <xsl:attribute name="source">WGBH MARS</xsl:attribute>
            <xsl:value-of select="text()" />
        </instantiationPhysical>
    </xsl:template>

    <xsl:template match="fmp:ID_URL" mode="instantiation">
        <instantiationLocation><xsl:value-of select="text()"/></instantiationLocation>
    </xsl:template>

    <xsl:template match="fmp:HOLDINGS_LOCATION" mode="instantiation">
        <instantiationLocation>
            <xsl:value-of select="text()" /> 
        </instantiationLocation>
    </xsl:template>
    
    <xsl:template match="fmp:dc_MEDIA" mode="instantiation">
        <instantiationMediaType>           
            <xsl:attribute name="source">WGBH MARS</xsl:attribute>
            <xsl:value-of select="text()" />
        </instantiationMediaType>
    </xsl:template>
    
    <xsl:template match="fmp:TYPE_ITEM" mode="instantiation">
        <instantiationGenerations>
            <xsl:attribute name="source">WGBH MARS</xsl:attribute>
            <xsl:value-of select="text()" />
        </instantiationGenerations>
    </xsl:template>

    <xsl:template match="fmp:FORMAT_MASTER_RUNNING_TIME" mode="instantiation">
        <instantiationDuration>
            <xsl:value-of select="text()" /> 
        </instantiationDuration>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_DURATION[../FORMAT_MASTER_RUNNING_TIME/text() = '0:00:00']" mode="instantiation">
        <instantiationDuration>
            <xsl:value-of select="text()"/>
        </instantiationDuration>
    </xsl:template>

    <xsl:template match="fmp:FORMAT_DURATION[not(../FORMAT_MASTER_RUNNING_TIME)]" mode="instantiation">
        <instantiationDuration>
            <xsl:value-of select="text()"/>
        </instantiationDuration>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_COLOR" mode="instantiation">
        <instantiationColors>          
            <xsl:attribute name="source">WGBH MARS</xsl:attribute>
            <xsl:value-of select="text()" /> 
        </instantiationColors>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_TRACKS_SUMMARY" mode="instantiation">
        <instantiationChannelConfiguration>
            <xsl:value-of select="text()" /> 
        </instantiationChannelConfiguration>
    </xsl:template>

    <xsl:template match="fmp:LANGUAGE" mode="instantiation">
        <instantiationLanguage>
            <xsl:value-of select="text()" />
        </instantiationLanguage>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_SCAN_LINES" mode="essencetrack">
        <essenceTrackScanLines>
            <xsl:value-of select="text()" /> 
        </essenceTrackScanLines>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_ASPECT_RATIO" mode="essencetrack">
        <essenceTrackAspectRatio>
            <xsl:value-of select="text()" /> 
        </essenceTrackAspectRatio>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_BROADCAST" mode="instantiation">
        <instantiationStandard>
            <xsl:value-of select="text()" /> 
        </instantiationStandard>
    </xsl:template>
    
    <xsl:template match="fmp:NOTES_ACCESS_RESTRICTIONS" mode="instantiation">
        <instantiationRights>
            <rightsSummary>
                <xsl:attribute name="annotation">access restrictions</xsl:attribute>
                <xsl:value-of select="text()"/>
            </rightsSummary>
        </instantiationRights>
    </xsl:template>
    
    <xsl:template match="fmp:RIGHTS_SUMMARY" mode="instantiation">
        <instantiationRights>
            <rightsSummary>
                <xsl:attribute name="annotation">rights summary</xsl:attribute>
                <xsl:value-of select="text()"/>
            </rightsSummary>
        </instantiationRights>
    </xsl:template>
    
    <xsl:template match="fmp:FORMAT_FRAME_RATE" mode="essencetrack">
        <essenceTrackFrameRate>
            <xsl:value-of select="text()" /> 
        </essenceTrackFrameRate>
    </xsl:template>

    <xsl:template match="fmp:FORMAT_TRACKS_NUMBER" mode="instantiation">
        <instantiationTracks>
            Audio: <xsl:value-of select="text() "/> tracks
        </instantiationTracks>
    </xsl:template>
    
    <xsl:template match="fmp:Producer">
        <pbcoreCreator>
            <creator><xsl:value-of select="text()"/></creator>
            <creatorRole ref="http://metadataregistry.org/concept/show/id/1425.html">Producer</creatorRole>
        </pbcoreCreator>
    </xsl:template>
    
    
    <xsl:template match="text()" />
    <xsl:template match="text()" mode="instantiation" />
    <xsl:template match="text()" mode="essencetrack"/>
</xsl:stylesheet>
