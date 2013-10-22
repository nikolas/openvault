<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:param name="lf" select="'&#10;'"/>

    <xsl:template match="/TEAMS_ASSET_FILE">
        <xsl:choose>
            <xsl:when test="count(ASSETS/ASSET) &gt; 1 ">
                <xsl:call-template name="pbcoreCollection"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="pbcoreDescriptionDocument" select="ASSETS/ASSET"/>
                <!--<xsl:call-template name="pbcoreDescriptionDocument"/>-->
                <!--<xsl:apply-templates select="ASSET"/>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pbcoreCollection">
        <xsl:element name="pbcoreCollection">
            <xsl:apply-templates mode="pbcoreCollectionType" select="ASSETS"/>
        </xsl:element>

    </xsl:template>

    <xsl:template mode="pbcoreCollectionType" match="ASSETS">
        <xsl:attribute name="collectionTitle"/>
        <xsl:attribute name="collectionDescription"/>
        <xsl:attribute name="collectionSource"/>
        <xsl:attribute name="collectionRef"/>
        <xsl:attribute name="collectionDate"/>

        <xsl:apply-templates mode="pbcoreDescriptionDocument" select="ASSET"/>

    </xsl:template>



    <xsl:template name="pbcoreDescriptionDocument" mode="pbcoreDescriptionDocument" match="ASSET">
        <!--<xsl:variable name="assetNum" select="position()"/>-->
        <xsl:element name="pbcoreDescriptionDocument">

            <xsl:apply-templates mode="pbcoreDescriptionDocumentType" select="METADATA">
                <!--<xsl:with-param name="assetNum" select="$assetNum"/>-->
            </xsl:apply-templates>
        </xsl:element>

    </xsl:template>

    <xsl:template name="pbcoreDescriptionDocumentType" mode="pbcoreDescriptionDocumentType"
        match="METADATA">
        <!--<xsl:param name="assetNum" select="1"/>-->
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="isPartType" select="false()"/>
        <xsl:choose>
            <xsl:when test="$isPartType = false()">
                <!--this section is used for the main document(s - in pbcoreCollection)-->
                <!--any elements used here must appear in specific order!-->
                <!--e.g. keep repeatable elements together-->
                <!--<xsl:apply-templates mode="pbcoreAssetDate" select="FOO_DATE"/>-->
                <!--<xsl:apply-templates mode="pbcoreAssetDate" select="BAR_DATE"/>-->
                <!--or-->
                <!--<xsl:apply-templates mode="pbcoreAssetDate" select="FOO_DATE | BAR_DATE"/>-->



                <xsl:apply-templates mode="pbcoreAssetType" select="UOIS/WGBH_TYPE[@ITEM_TYPE]">
                    <xsl:with-param name="attName" select="'ITEM_TYPE'"/>
                    <xsl:with-param name="ann" select="UOIS/WGBH_TYPE[@ITEM_CATEGORY]"/>
                </xsl:apply-templates>

                <!--use apply-templates for optional structures-->
                <xsl:apply-templates mode="pbcoreAssetDate" select="UOIS/WGBH_DATE"/>

                <!--use call-template for required structures-->
                <xsl:call-template name="pbcoreIdentifier">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_IDENTIFIER[@ITEM_IDENTIFIER]"/>
                    <!--note use of quoted strings for attibute-name parameters below-->
                    <xsl:with-param name="ann" select="'IDENTIFIER_NOTE'"/>
                    <xsl:with-param name="src" select="'!ITEM_IDENTIFIER'"/>
                    <xsl:with-param name="idval" select="'ITEM_IDENTIFIER'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreIdentifier">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_IDENTIFIER[@NOLA_CODE]"/>
                    <!--note use of quoted strings for attibute-name parameters below-->
                    <xsl:with-param name="ann" select="'IDENTIFIER_NOTE'"/>
                    <xsl:with-param name="src" select="'!NOLA_CODE'"/>
                    <xsl:with-param name="idval" select="'NOLA_CODE'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreIdentifier">
                    <xsl:with-param name="dataNode" select="UOIS"/>
                    <!--note use of quoted strings for attibute-name parameters below-->
                    <xsl:with-param name="src" select="'!UOI_ID'"/>
                    <xsl:with-param name="ver" select="'VERSION'"/>
                    <xsl:with-param name="idval" select="'UOI_ID'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreIdentifier">
                    <xsl:with-param name="dataNode" select="UOIS[@PO_REFERENCE]"/>
                    <!--note use of quoted strings for attibute-name parameters below-->
                    <xsl:with-param name="src" select="'!PO_REFERENCE'"/>
                    <xsl:with-param name="ver" select="'VERSION'"/>
                    <xsl:with-param name="idval" select="'PO_REFERENCE'"/>
                    <xsl:with-param name="ann"
                        select="'Refers to a Physical Object or key from a legacy database'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreIdentifier">
                    <xsl:with-param name="dataNode" select="UOIS[@IMPORT_ID]"/>
                    <!--note use of quoted strings for attibute-name parameters below-->
                    <xsl:with-param name="src" select="'!IMPORT_ID'"/>
                    <xsl:with-param name="ver" select="'VERSION'"/>
                    <xsl:with-param name="idval" select="'IMPORT_ID'"/>
                    <xsl:with-param name="ann"
                        select="'Session shared by items brought into ArtesiaDAM together.'"/>
                </xsl:call-template>


                <!--use call-template for required structures-->
                <xsl:call-template name="pbcoreTitle">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_TITLE"/>
                    <!--note use of quoted strings for attibute-name parameters below-->
                    <xsl:with-param name="ttyp" select="'TITLE_TYPE'"/>
                    <xsl:with-param name="tval" select="'TITLE'"/>
                    <xsl:with-param name="tann" select="'TITLE_NOTE'"/>
                    <xsl:with-param name="ver" select="'TITLE_DATE'"/>
                </xsl:call-template>

                <!--use apply-templates for optional structures-->
                <xsl:apply-templates mode="pbcoreSubject" select="UOIS/WGBH_SUBJECT"/>


                <!--use call-template for required structures-->
                <xsl:call-template name="pbcoreDescription">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_DESCRIPTION"/>
                    <!--note use of quoted strings for parameters below; also see template 'thisThingValue' -->
                    <xsl:with-param name="dsann">
                        <xsl:value-of select="concat('!',UOIS/WGBH_DESCRIPTION/@DESCRIPTION_NOTE)"/>
                        <xsl:if
                            test="UOIS/WGBH_DESCRIPTION/@DESCRIPTION_NOTE != '' and UOIS/@DESC != ''">
                            <xsl:value-of select="concat(', ', UOIS/@DESC)"/>
                        </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="dstyp" select="'DESCRIPTION_TYPE'"/>
                    <xsl:with-param name="stim" select="'DESCRIPTION_COVERAGE_IN'"/>
                    <xsl:with-param name="etim" select="'DESCRIPTION_COVERAGE_OUT'"/>
                    <xsl:with-param name="dsval" select="'DESCRIPTION'"/>
                </xsl:call-template>

                <xsl:apply-templates mode="pbcoreGenre" select="UOIS/WGBH_TYPE_GENRE"/>

                <xsl:call-template name="pbcoreRelation">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_SOURCE[@SOURCE != '']"/>
                    <xsl:with-param name="type_src" select="'!SOURCE'"/>
                    <!--<xsl:with-param name="type_ann" select="'!ID or Title'"/>-->
                    <xsl:with-param name="type_val" select="'SOURCE_TYPE'"/>
                    <xsl:with-param name="id_ann" select="'SOURCE_NOTE'"/>
                    <xsl:with-param name="id_val" select="'SOURCE'"/>
                </xsl:call-template>

                <xsl:apply-templates mode="pbcoreRelation"
                    select="UOIS/WGBH_RELATION[@RELATION | @RELATION_TYPE]">
                    <!--<xsl:with-param name="type_ann" select="'RELATION_NOTE'"/>-->
                    <xsl:with-param name="type_src" select="'!WGBH_RELATION'"></xsl:with-param>
                    <xsl:with-param name="type_val" select="'RELATION_TYPE'"/>
                    <xsl:with-param name="id_ann" select="'RELATION_NOTE'"/>
                    <xsl:with-param name="id_val" select="'RELATION'"/>
                </xsl:apply-templates>
                <!--now process the LINKS and their ENTITY declarations-->
                <xsl:variable name="thisEntity">
                    <xsl:variable name="entityString">
                        <xsl:apply-templates select="/TEAMS_ASSET_FILE/LINKS/LINK">
                            <xsl:with-param name="searchUOID" select="UOIS/@UOI_ID"/>
                        </xsl:apply-templates>
                    </xsl:variable>
                    <xsl:value-of select="substring-before($entityString,'&#10;')"/>
                </xsl:variable>
                <xsl:for-each select="/TEAMS_ASSET_FILE/LINKS/LINK[@SOURCE=$thisEntity]">
                    <xsl:call-template name="pbcoreRelation">
                        <!--<xsl:with-param name="dataNode" select="/TEAMS_ASSET_FILE/LINKS/LINK[@SOURCE=$thisEntity]"/>-->
                        <xsl:with-param name="type_val" select="'LINK_TYPE'"/>
                        <xsl:with-param name="type_src" select="'!LINK_TYPE'"/>
                        <xsl:with-param name="type_ann"
                            select="'!Current item is the source of this relationship'"/>

                        <xsl:with-param name="id_val"
                            select="concat('!',substring-after(unparsed-entity-uri(@DESTINATION),'teams:/query-uoi?uois:uoi_id:eq:'))"/>
                        <xsl:with-param name="id_ann"
                            select="'!Another item is the destination of this relationship'"/>
                        <xsl:with-param name="id_src" select="'!UOI_ID'"/>
                    </xsl:call-template>
                </xsl:for-each>
                <!--end section pbcoreRelation-->



                <xsl:apply-templates mode="pbcoreCoverage" select="UOIS/WGBH_COVERAGE"/>
                <xsl:apply-templates mode="pbcoreAudienceLevel" select="UOIS/WGBH_AUDIENCE"/>
                <xsl:apply-templates mode="pbcoreAudienceRating" select="unmapped"/>

                <!--special case where one sub-element iterates against another-->
                <xsl:call-template name="pbcoreCreator">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_CREATOR"/>
                    <!--note use of quoted strings for attribute-name parameters below-->
                    <xsl:with-param name="creator_attributeName" select="'CREATOR_NAME'"/>
                    <xsl:with-param name="role_attributeName" select="'CREATOR_ROLE'"/>
                    <xsl:with-param name="affil_attributeName" select="'ORGANIZATION'"/>
                    <xsl:with-param name="ann_attributeName" select="'CREATOR_NOTE'"/>
                </xsl:call-template>

                <!--special case where one sub-element iterates against another-->
                <xsl:call-template name="pbcoreContributor">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_CONTRIBUTOR"/>
                    <!--note use of quoted strings for attribute-name parameters below-->
                    <xsl:with-param name="person_attributeName" select="'CONTRIBUTOR_NAME'"/>
                    <xsl:with-param name="role_attributeName" select="'CONTRIBUTOR_ROLE'"/>
                    <xsl:with-param name="affil_attributeName" select="'ORGANIZATION'"/>
                    <xsl:with-param name="ann_attributeName" select="'CONTRIBUTOR_NOTE'"/>
                </xsl:call-template>

                <!--special case where one sub-element iterates against another-->
                <xsl:call-template name="pbcorePublisher">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_PUBLISHER"/>
                    <!--note use of quoted strings for attribute-name parameters below-->
                    <xsl:with-param name="person_attributeName" select="'PUBLISHER'"/>
                    <xsl:with-param name="role_attributeName" select="'PUBLISHER_TYPE'"/>
                    <xsl:with-param name="ann_attributeName" select="'PUBLISHER_NOTE'"/>
                </xsl:call-template>


                <xsl:apply-templates mode="pbcoreRightsSummary" select="UOIS/WGBH_RIGHTS"/>
                <!--<xsl:call-template name="pbcoreRightsSummary" >
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_RIGHTS"/>
                    <xsl:with-param name="rightSum_ann" select="'RIGHTS_NOTE'"/>
                    <xsl:with-param name="rightSum_val" select="'RIGHTS'"/>
                    <xsl:with-param name="tann" select="'RIGHTS_COVERAGE'"/>
                </xsl:call-template>-->




                <xsl:call-template name="pbcoreInstantiation"/>
                <!--pbcoreInstantiation is a huge template with many subs; there is no elegant way to make it re-usable-->

                <xsl:call-template name="pbcoreAnnotation">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_ANNOTATION[@ANNOTATION]"/>
                    <xsl:with-param name="elementValue" select="'ANNOTATION'"/>
                    <xsl:with-param name="annotationType" select="'ANNOTATION_TYPE'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreAnnotation">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_SOURCE[@SOURCE_NOTE]"/>
                    <xsl:with-param name="elementValue" select="'SOURCE_NOTE'"/>
                    <xsl:with-param name="annotationType" select="'!SOURCE'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreAnnotation">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_LANGUAGE[@LANGUAGE_NOTE]"/>
                    <xsl:with-param name="elementValue" select="'LANGUAGE_NOTE'"/>
                    <xsl:with-param name="annotationType" select="'!LANGUAGE'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreAnnotation">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_DATE[DATE_NOTE != '']"/>
                    <xsl:with-param name="elementValue" select="'DATE_NOTE'"/>
                    <xsl:with-param name="annotationType" select="'!DATE_NOTE'"/>
                    <xsl:with-param name="ref" select="'pbcoreAssetDate'"/>
                </xsl:call-template>


                <xsl:call-template name="pbcoreExtension">
                    <xsl:with-param name="dataNode" select="UOIS/SECURITY_POLICY_UOIS"/>
                    <xsl:with-param name="embeddedType_ann" select="'Access control information'"/>
                    <!--<xsl:with-param name="extensionType" select="'extensionWrap'"/>-->
                    <!--default extensionType is 'extensionEmbedded'-->
                </xsl:call-template>
                <xsl:call-template name="pbcoreExtension">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_DATE_RELEASE"/>
                    <xsl:with-param name="embeddedType_ann" select="'Release date information'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreExtension">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_DATE"/>
                    <xsl:with-param name="embeddedType_ann" select="'Lifecycle information'"/>
                </xsl:call-template>
                <xsl:call-template name="pbcoreExtension">
                    <xsl:with-param name="dataNode" select="UOIS/WGBH_META"/>
                    <xsl:with-param name="embeddedType_ann" select="'Originating department information'"/>
                </xsl:call-template>



            </xsl:when>

            <xsl:otherwise>
                <!--handle pbcorePart versions here-->
                <xsl:choose>
                    <xsl:when test="$isPartType = 'foo'">
                        <!--any elements used here must appear in specific order!-->
                        <!--remember that these few elements are required
                        <xsl:call-template name="pbcoreIdentifier"/>
                        <xsl:call-template name="pbcoreTitle"/>
                        <xsl:call-template name="pbcoreDescription"/>-->
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>























    <!--begin section: templates to draw child elements of pbcoreDescriptionDocument-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<< -->














    <xsl:template name="pbcoreAssetType" mode="pbcoreAssetType" match="UOIS/WGBH_TYPE">
        <xsl:param name="ann"/>
        <xsl:param name="attName" select="'ITEM_TYPE'"/>
        <xsl:if test="$attName != '' or attribute::node()[local-name(.)=$attName] != ''">
            <xsl:element name="pbcoreAssetType">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <!--<xsl:with-param name="ann" select="$ann"/>-->
                    <xsl:with-param name="ann">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$ann"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="thisThingValue">
                    <xsl:with-param name="s" select="$attName"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!--NOTE:  example of using additional templates with common 'mode' (& shared select/match args) for add'l doc elements-->
    <!--example of the selecting doc element:-->
    <!--<xsl:apply-templates mode="pbcoreAssetType" select="WGBH_ANNOTATION | WGBH_CONTRIBUTOR"/>-->
    <!--example of the matching template-->
    <!--    <xsl:template mode="pbcoreAssetType" match="WGBH_CONTRIBUTOR" priority="2">
        <xsl:element name="pbcoreAssetType">
            <xsl:call-template name="sourceVersionStringType">
                <xsl:with-param name="ann" select="@CONTRIBUTOR_ROLE"/>
            </xsl:call-template>
            <xsl:value-of select="@CONTRIBUTOR_NAME"/>
        </xsl:element>
    </xsl:template>-->

    <xsl:template mode="pbcoreAssetDate" match="UOIS/WGBH_DATE[@ITEM_DATE]">
        <xsl:if test="count(.) > 0">
            <xsl:element name="pbcoreAssetDate">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="dateStringType">
                    <xsl:with-param name="dtyp" select="'Item Date'"/>
                </xsl:call-template>
                <xsl:value-of select="@ITEM_DATE"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>


    <xsl:template name="pbcoreIdentifier">
        <xsl:param name="dataNode" select="."/>
        <!--ADD ALL POSSIBLE PARAMETERS HERE-->
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>
        <xsl:param name="idval"/>

        <!--#copy that list of parameters to a text file-->
        <!--# use that text file with this shell script-->
        <!-- for i in `cut -f2 -d\" 'that_text_file' | cut -f1`;do echo "<xsl:with-param name=\"$i\"  select=\"attribute::node()[local-name(.)=\$$i]\"/>"; done | pbcopy-->
        <!--# paste result from running shell script to 'call-template' below to provide its with-parameter list-->
        <xsl:choose>
            <xsl:when test="count($dataNode) &lt; 1"/>
            <xsl:when test="$dataNode/text() = ''">
                <xsl:element name="pbcoreIdentifier">
                    <!--maxOccurs="unbounded" minOccurs="1"-->
                    <xsl:attribute name="source">
                        <xsl:value-of select="'missing value'"/>
                    </xsl:attribute>
                    <xsl:text>missing value</xsl:text>
                </xsl:element>

            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$dataNode">
                    <xsl:element name="pbcoreIdentifier">
                        <!--maxOccurs="unbounded" minOccurs="1"-->
                        <xsl:call-template name="requiredSourceVersionStringType">
                            <xsl:with-param name="src">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$src"/>
                                </xsl:call-template>
                                <!--<xsl:choose>
                                    <xsl:when test="$src = ''"/>
                                    <xsl:when test="attribute::node()[local-name(.)=$src]">
                                        <xsl:value-of select="attribute::node()[local-name(.)=$src]"
                                        />
                                    </xsl:when>
                                    <xsl:when test="node()[local-name(.)=$src]">
                                        <xsl:value-of select="node()[local-name(.)=$src]/text()"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$src"/>
                                    </xsl:otherwise>
                                </xsl:choose>-->
                            </xsl:with-param>
                            <xsl:with-param name="ref">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$ref"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="ver">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$ver"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="ann">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$ann"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$idval"/>
                        </xsl:call-template>
                    </xsl:element>

                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--end of template "pbcoreIdentifier"-->

    <xsl:template name="pbcoreTitle">
        <xsl:param name="dataNode" select="."/>
        <!--ADD ALL POSSIBLE PARAMETERS HERE-->
        <xsl:param name="ttyp"/>
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>
        <xsl:param name="tval"/>

        <xsl:choose>
            <xsl:when test="count($dataNode) &lt; 1 or $dataNode/text() = ''">
                <xsl:element name="pbcoreTitle">
                    <xsl:text>missing value</xsl:text>
                </xsl:element>

            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$dataNode">
                    <xsl:element name="pbcoreTitle">
                        <!--maxOccurs="unbounded" minOccurs="1"-->
                        <xsl:call-template name="titleStringType">
                            <xsl:with-param name="ttyp">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$ttyp"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="src">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$src"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="ref">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$ref"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="ver">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$ver"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="ann">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$ann"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="stim">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$stim"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="etim">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$etim"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="tann">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$tann"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$tval"/>
                        </xsl:call-template>
                    </xsl:element>

                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--end of template "pbcoreTitle"-->

    <xsl:template mode="pbcoreSubject" match="UOIS/WGBH_SUBJECT">
        <xsl:element name="pbcoreSubject">
            <!--maxOccurs="unbounded" minOccurs="0"-->
            <xsl:call-template name="subjectStringType">
                <xsl:with-param name="ann" select="@SUBJECT_NOTE"/>
                <xsl:with-param name="sbjt" select="@SUBJECT_TYPE"/>
                <xsl:with-param name="ref" select="@STANDARD"/>
                <xsl:with-param name="ver" select="@DISCIPLINE"/>
            </xsl:call-template>
            <xsl:value-of select="@SUBJECT"/>
        </xsl:element>

    </xsl:template>

    <xsl:template name="pbcoreDescription">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="dsval"/>
        <xsl:param name="dsann"/>
        <xsl:param name="dstyp"/>
        <xsl:param name="dstypsrc"/>
        <xsl:param name="dstypref"/>
        <xsl:param name="dstypver"/>
        <xsl:param name="dstypann"/>
        <xsl:param name="segtyp"/>
        <xsl:param name="segtypsrc"/>
        <xsl:param name="segtypref"/>
        <xsl:param name="segtypver"/>
        <xsl:param name="segtypann"/>
        <xsl:param name="etim"/>
        <xsl:param name="stim"/>
        <xsl:param name="tann"/>
        <xsl:choose>
            <xsl:when test="count($dataNode) &lt; 1 or text() = ''">
                <xsl:element name="pbcoreDescription">
                    <xsl:text>missing value</xsl:text>
                </xsl:element>

            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$dataNode">
                    <xsl:element name="pbcoreDescription">
                        <!--maxOccurs="unbounded" minOccurs="1"-->
                        <xsl:call-template name="descriptionStringType">
                            <xsl:with-param name="dsval">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$dsval"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="dsann">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$dsann"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="dstyp">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$dstyp"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="dstypsrc">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$dstypsrc"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="dstypref">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$dstypref"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="dstypver">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$dstypver"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="dstypann">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$dstypann"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="segtyp">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$segtyp"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="segtypsrc">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$segtypsrc"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="segtypref">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$segtypref"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="segtypver">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$segtypver"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="segtypann">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$segtypann"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="etim">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$etim"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="stim">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$stim"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="tann">
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$tann"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$dsval"/>
                        </xsl:call-template>
                    </xsl:element>

                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--end of template "pbcoreDescription"-->

    <xsl:template name="pbcoreGenre" mode="pbcoreGenre" match="UOIS/WGBH_TYPE_GENRE">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ann" select="'GENRE_NOTE'"/>
        <xsl:param name="ref" select="'STANDARD'"/>
        <xsl:param name="elementValue" select="'GENRE'"/>
        <xsl:for-each select="$dataNode">
            <xsl:element name="pbcoreGenre">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStartEndStringType">
                    <xsl:with-param name="ann">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$ann"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="ref">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$ref"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="thisThingValue">
                    <xsl:with-param name="s" select="$elementValue"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="pbcoreRelation" mode="pbcoreRelation"
        match="UOIS/WGBH_RELATION[@RELATION | @RELATION_TYPE]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="type_ann"/>
        <xsl:param name="type_ref"/>
        <xsl:param name="type_src"/>
        <xsl:param name="type_ver"/>
        <xsl:param name="type_val"/>

        <xsl:param name="id_ann"/>
        <xsl:param name="id_ref"/>
        <xsl:param name="id_src"/>
        <xsl:param name="id_ver"/>
        <xsl:param name="id_val"/>

        <xsl:for-each select="$dataNode">
            <xsl:element name="pbcoreRelation">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:element name="pbcoreRelationType">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="sourceVersionStringType">
                        <xsl:with-param name="ann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$type_ann"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="ref">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$type_ref"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="src">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$type_src"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="ver">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$type_ver"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="thisThingValue">
                        <xsl:with-param name="s" select="$type_val"/>
                    </xsl:call-template>
                </xsl:element>

                <xsl:element name="pbcoreRelationIdentifier">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="sourceVersionStringType">
                        <xsl:with-param name="ann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$id_ann"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="ref">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$id_ref"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="src">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$id_src"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="ver">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$id_ver"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="thisThingValue">
                        <xsl:with-param name="s" select="$id_val"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template mode="pbcoreCoverage" match="UOIS/WGBH_COVERAGE">
        <!--maxOccurs="unbounded" minOccurs="0"-->
        <xsl:if test="@EVENT_LOCATION != ''">
            <xsl:element name="pbcoreCoverage">
                <xsl:element name="coverage">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="sourceVersionStartEndStringType">
                        <xsl:with-param name="stim"/>
                        <xsl:with-param name="etim"/>
                        <xsl:with-param name="tann"/>
                        <xsl:with-param name="src"/>
                        <xsl:with-param name="ref" select="'EVENT_LOCATION'"/>
                        <xsl:with-param name="ver"/>
                        <xsl:with-param name="ann" select="@COVERAGE_NOTE"/>
                    </xsl:call-template>
                    <xsl:value-of select="@EVENT_LOCATION"/>
                </xsl:element>

                <xsl:element name="coverageType">
                    <!--maxOccurs="1" minOccurs="0"-->
                    <!--value must be either "Spatial" or "Temporal"-->
                    <xsl:value-of select="'Spatial'"/>
                </xsl:element>

            </xsl:element>

        </xsl:if>
        <xsl:if test="@DATE_PORTRAYED != ''">
            <xsl:element name="pbcoreCoverage">
                <xsl:element name="coverage">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="sourceVersionStartEndStringType">
                        <xsl:with-param name="stim"/>
                        <xsl:with-param name="etim"/>
                        <xsl:with-param name="tann"/>
                        <xsl:with-param name="src"/>
                        <xsl:with-param name="ref" select="'DATE_PORTRAYED'"/>
                        <xsl:with-param name="ver"/>
                        <xsl:with-param name="ann" select="@COVERAGE_NOTE"/>
                    </xsl:call-template>
                    <xsl:value-of select="@DATE_PORTRAYED"/>
                </xsl:element>

                <xsl:element name="coverageType">
                    <!--maxOccurs="1" minOccurs="0"-->
                    <!--value must be either "Spatial" or "Temporal"-->
                    <xsl:value-of select="'Temporal'"/>
                </xsl:element>

            </xsl:element>

        </xsl:if>
        <xsl:if test="@PRODUCTION_LOCATION != ''">
            <xsl:element name="pbcoreCoverage">
                <xsl:element name="coverage">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="sourceVersionStartEndStringType">
                        <xsl:with-param name="stim"/>
                        <xsl:with-param name="etim"/>
                        <xsl:with-param name="tann"/>
                        <xsl:with-param name="src"/>
                        <xsl:with-param name="ref" select="'PRODUCTION_LOCATION'"/>
                        <xsl:with-param name="ver"/>
                        <xsl:with-param name="ann" select="@COVERAGE_NOTE"/>
                    </xsl:call-template>
                    <xsl:value-of select="@PRODUCTION_LOCATION"/>
                </xsl:element>

                <xsl:element name="coverageType">
                    <!--maxOccurs="1" minOccurs="0"-->
                    <!--value must be either "Spatial" or "Temporal"-->
                    <xsl:value-of select="'Spatial'"/>
                </xsl:element>

            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end of template "pbcoreCoverage"-->

    <xsl:template mode="pbcoreAudienceLevel" match="UOIS/WGBH_AUDIENCE[@AUDIENCE_LEVEL]">
        <!--maxOccurs="unbounded" minOccurs="0"-->
        <xsl:element name="pbcoreAudienceLevel">
            <xsl:call-template name="sourceVersionStringType">
                <xsl:with-param name="ann">
                    <xsl:variable name="prettyValues">
                        <xsl:for-each select="attribute::node()[local-name() != 'AUDIENCE_LEVEL']">
                            <xsl:value-of select="concat('(',local-name(),'=', current(),'), ')"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($prettyValues,', ')">
                            <xsl:value-of
                                select="substring($prettyValues,1,string-length($prettyValues)-2)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prettyValues"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="ref"/>
                <xsl:with-param name="src"/>
                <xsl:with-param name="ver"/>
            </xsl:call-template>
            <xsl:value-of select="@AUDIENCE_LEVEL"/>
        </xsl:element>

    </xsl:template>

    <xsl:template mode="pbcoreAudienceRating" match="unmapped">
        <!--maxOccurs="unbounded" minOccurs="0"-->
        <xsl:element name="pbcoreAudienceRating">
            <xsl:call-template name="sourceVersionStringType">
                <xsl:with-param name="ann"/>
                <xsl:with-param name="ref"/>
                <xsl:with-param name="src"/>
                <xsl:with-param name="ver"/>
            </xsl:call-template>
            <xsl:value-of select="@foo"/>
        </xsl:element>

    </xsl:template>

    <!--special case where one sub-element iterates against another-->
    <xsl:template name="pbcoreCreator">
        <xsl:param name="dataNode" select="UOIS/WGBH_CREATOR"/>
        <!--note use of quoted strings for attribute-name parameters below-->
        <xsl:param name="creator_attributeName" select="'CREATOR_NAME'"/>
        <xsl:param name="role_attributeName" select="'CREATOR_ROLE'"/>
        <xsl:param name="affil_attributeName" select="'ORGANIZATION'"/>
        <xsl:param name="affref_attributeName"/>
        <xsl:param name="affann_attributeName"/>
        <xsl:param name="stim_attributeName"/>
        <xsl:param name="etim_attributeName"/>
        <xsl:param name="tann_attributeName"/>
        <xsl:param name="ann_attributeName" select="'CREATOR_NOTE'"/>
        <xsl:param name="ref_attributeName"/>
        <xsl:param name="src_attributeName"/>
        <xsl:param name="ver_attributeName"/>

        <xsl:param name="doneList" select="'&#10;'"/>
        <xsl:param name="nodeNum" select="1"/>
        <xsl:variable name="nextNodeNum" select="$nodeNum+1"/>
        <xsl:variable name="creatorValue">
            <xsl:call-template name="thisThingValue">
                <xsl:with-param name="s" select="$creator_attributeName"/>
                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
            </xsl:call-template>
            <!--<xsl:choose>
                <xsl:when test="$creator_attributeName = ''"/>
                <xsl:when test="$dataNode[$nodeNum]/attribute::node()[local-name(.)=$creator_attributeName]">
                    <xsl:value-of
                        select="$dataNode[$nodeNum]/attribute::node()[local-name(.)=$creator_attributeName]"/>
                </xsl:when>
                <xsl:when test="$dataNode[$nodeNum]/node()[local-name(.)=$creator_attributeName]">
                    <xsl:value-of
                        select="$dataNode[$nodeNum]/node()[local-name(.)=$creator_attributeName]/text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$creator_attributeName"/>
                </xsl:otherwise>
            </xsl:choose>-->
        </xsl:variable>
        <xsl:if
            test="$dataNode and not(contains($doneList,concat('&#10;',$creatorValue,'&#10;')))">
            <xsl:element name="pbcoreCreator">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:element name="creator">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="affiliatedStringType">
                        <xsl:with-param name="affil">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affil_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="affref">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affref_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="affann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affann_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="stim">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$stim_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="etim">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$etim_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="tann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$tann_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$creatorValue"/>
                </xsl:element>


                <!--now print all roles related to this-->
                <xsl:choose>
                    <xsl:when test="$creator_attributeName = ''"/>
                    <xsl:when
                        test="$dataNode[$nodeNum]/attribute::node()[local-name(.)=$creator_attributeName]">
                        <xsl:for-each
                            select="$dataNode[attribute::node()[local-name(.)=$creator_attributeName] = $creatorValue]">
                            <xsl:element name="creatorRole">
                                <!--maxOccurs="unbounded" minOccurs="0"-->
                                <xsl:call-template name="sourceVersionStringType">
                                    <xsl:with-param name="ann">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ann_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ref">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ref_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="src">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$src_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ver">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ver_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$role_attributeName"/>
                                </xsl:call-template>
                            </xsl:element>

                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when
                        test="$dataNode[$nodeNum]/node()[local-name(.)=$creator_attributeName]">
                        <xsl:for-each
                            select="$dataNode[node()[local-name(.)=$creator_attributeName] = $creatorValue]">
                            <xsl:element name="creatorRole">
                                <!--maxOccurs="unbounded" minOccurs="0"-->
                                <xsl:call-template name="sourceVersionStringType">
                                    <xsl:with-param name="ann">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ann_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ref">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ref_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="src">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$src_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ver">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ver_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$role_attributeName"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--then $creatorValue is the static string of $creator_attributeName, so nothing to iterate-->
                        <xsl:element name="creatorRole">
                            <!--maxOccurs="unbounded" minOccurs="0"-->
                            <xsl:call-template name="sourceVersionStringType">
                                <xsl:with-param name="ann">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ann_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="ref">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ref_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="src">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$src_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="ver">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ver_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$role_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:element>

                    </xsl:otherwise>
                </xsl:choose>
                <!--end printing all related roles-->

            </xsl:element>

        </xsl:if>
        <xsl:if test="$nodeNum &lt; count($dataNode)">
            <xsl:call-template name="pbcoreCreator">
                <xsl:with-param name="dataNode" select="$dataNode"/>
                <xsl:with-param name="creator_attributeName" select="$creator_attributeName"/>
                <xsl:with-param name="role_attributeName" select="$role_attributeName"/>
                <xsl:with-param name="affil_attributeName" select="$affil_attributeName"/>
                <xsl:with-param name="affref_attributeName" select="$affref_attributeName"/>
                <xsl:with-param name="affann_attributeName" select="$affann_attributeName"/>
                <xsl:with-param name="stim_attributeName" select="$stim_attributeName"/>
                <xsl:with-param name="etim_attributeName" select="$etim_attributeName"/>
                <xsl:with-param name="tann_attributeName" select="$tann_attributeName"/>
                <xsl:with-param name="ann_attributeName" select="$ann_attributeName"/>
                <xsl:with-param name="ref_attributeName" select="$ref_attributeName"/>
                <xsl:with-param name="src_attributeName" select="$src_attributeName"/>
                <xsl:with-param name="ver_attributeName" select="$ver_attributeName"/>
                <xsl:with-param name="doneList" select="concat($doneList,$creatorValue,'&#10;')"/>
                <xsl:with-param name="nodeNum" select="$nextNodeNum"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--end of template "pbcoreCreator"-->






    <!--special case where one sub-element iterates against another-->
    <xsl:template name="pbcoreContributor">
        <xsl:param name="dataNode" select="UOIS/WGBH_CONTRIBUTOR"/>
        <!--note use of quoted strings for attribute-name parameters below-->
        <xsl:param name="person_attributeName" select="'CONTRIBUTOR_NAME'"/>
        <xsl:param name="role_attributeName" select="'CONTRIBUTOR_ROLE'"/>
        <xsl:param name="affil_attributeName" select="'ORGANIZATION'"/>
        <xsl:param name="affref_attributeName"/>
        <xsl:param name="affann_attributeName"/>
        <xsl:param name="stim_attributeName"/>
        <xsl:param name="etim_attributeName"/>
        <xsl:param name="tann_attributeName"/>
        <xsl:param name="contrib_portrayal_attributeName"/>
        <xsl:param name="ann_attributeName" select="'CONTRIBUTOR_NOTE'"/>
        <xsl:param name="ref_attributeName"/>
        <xsl:param name="src_attributeName"/>
        <xsl:param name="ver_attributeName"/>

        <xsl:param name="doneList" select="'&#10;'"/>
        <xsl:param name="nodeNum" select="1"/>
        <xsl:variable name="nextNodeNum" select="$nodeNum+1"/>
        <xsl:variable name="contributorValue">
            <xsl:call-template name="thisThingValue">
                <xsl:with-param name="s" select="$person_attributeName"/>
                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if
            test="$dataNode and not(contains($doneList,concat('&#10;',$contributorValue,'&#10;')))">
            <xsl:element name="pbcoreContributor">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:element name="contributor">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="affiliatedStringType">
                        <xsl:with-param name="affil">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affil_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="affref">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affref_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="affann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affann_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="stim">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$stim_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="etim">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$etim_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="tann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$tann_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$contributorValue"/>
                </xsl:element>

                <!--now print all roles related to this-->
                <xsl:choose>
                    <xsl:when test="$person_attributeName = ''"/>
                    <xsl:when
                        test="$dataNode[$nodeNum]/attribute::node()[local-name(.)=$person_attributeName]">
                        <xsl:for-each
                            select="$dataNode[attribute::node()[local-name(.)=$person_attributeName] = $contributorValue]">
                            <xsl:element name="contributorRole">
                                <!--maxOccurs="unbounded" minOccurs="0"-->
                                <xsl:call-template name="contributorStringType">
                                    <xsl:with-param name="contrayal">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ann_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ref">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ref_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="src">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$src_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ver">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ver_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$role_attributeName"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$dataNode[$nodeNum]/node()[local-name(.)=$person_attributeName]">
                        <xsl:for-each
                            select="$dataNode[node()[local-name(.)=$person_attributeName] = $contributorValue]">
                            <xsl:element name="contributorRole">
                                <!--maxOccurs="unbounded" minOccurs="0"-->
                                <xsl:call-template name="contributorStringType">
                                    <xsl:with-param name="contrayal">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ann_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ref">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ref_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="src">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$src_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ver">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ver_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$role_attributeName"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--then $contributorValue is the static string of $person_attributeName, so nothing to iterate-->
                        <xsl:element name="contributorRole">
                            <!--maxOccurs="unbounded" minOccurs="0"-->
                            <xsl:call-template name="contributorStringType">
                                <xsl:with-param name="contrayal">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ann_attributeName"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="ref">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ref_attributeName"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="src">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$src_attributeName"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="ver">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ver_attributeName"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$role_attributeName"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <!--end printing all related roles-->
            </xsl:element>

        </xsl:if>
        <xsl:if test="$nodeNum &lt; count($dataNode)">
            <xsl:call-template name="pbcoreContributor">
                <xsl:with-param name="dataNode" select="$dataNode"/>
                <xsl:with-param name="person_attributeName" select="$person_attributeName"/>
                <xsl:with-param name="role_attributeName" select="$role_attributeName"/>
                <xsl:with-param name="affil_attributeName" select="$affil_attributeName"/>
                <xsl:with-param name="affref_attributeName" select="$affref_attributeName"/>
                <xsl:with-param name="affann_attributeName" select="$affann_attributeName"/>
                <xsl:with-param name="stim_attributeName" select="$stim_attributeName"/>
                <xsl:with-param name="etim_attributeName" select="$etim_attributeName"/>
                <xsl:with-param name="tann_attributeName" select="$tann_attributeName"/>
                <xsl:with-param name="contrib_portrayal_attributeName"
                    select="$contrib_portrayal_attributeName"/>
                <xsl:with-param name="ann_attributeName" select="$ann_attributeName"/>
                <xsl:with-param name="ref_attributeName" select="$ref_attributeName"/>
                <xsl:with-param name="src_attributeName" select="$src_attributeName"/>
                <xsl:with-param name="ver_attributeName" select="$ver_attributeName"/>
                <xsl:with-param name="doneList"
                    select="concat($doneList,$contributorValue,'&#10;')"/>
                <xsl:with-param name="nodeNum" select="$nextNodeNum"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--end of template "pbcoreContributor"-->



    <!--special case where one sub-element iterates against another-->
    <xsl:template name="pbcorePublisher">
        <xsl:param name="dataNode" select="UOIS/WGBH_PUBLISHER"/>
        <!--note use of quoted strings for attribute-name parameters below-->
        <xsl:param name="person_attributeName" select="'PUBLISHER'"/>
        <xsl:param name="role_attributeName" select="'PUBLISHER_TYPE'"/>
        <xsl:param name="affil_attributeName"/>
        <xsl:param name="affref_attributeName"/>
        <xsl:param name="affann_attributeName"/>
        <xsl:param name="stim_attributeName"/>
        <xsl:param name="etim_attributeName"/>
        <xsl:param name="tann_attributeName"/>
        <xsl:param name="ann_attributeName" select="'PUBLISHER_NOTE'"/>
        <xsl:param name="ref_attributeName"/>
        <xsl:param name="src_attributeName"/>
        <xsl:param name="ver_attributeName"/>

        <xsl:param name="doneList" select="'&#10;'"/>
        <xsl:param name="nodeNum" select="1"/>
        <xsl:variable name="nextNodeNum" select="$nodeNum+1"/>
        <xsl:variable name="publisherValue">
            <xsl:call-template name="thisThingValue">
                <xsl:with-param name="s" select="$person_attributeName"/>
                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if
            test="$dataNode and not(contains($doneList,concat('&#10;',$publisherValue,'&#10;')))">
            <xsl:element name="pbcorePublisher">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:element name="publisher">
                    <!--maxOccurs="1" minOccurs="1"-->
                    <xsl:call-template name="affiliatedStringType">
                        <xsl:with-param name="affil">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affil_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="affref">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affref_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="affann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$affann_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="stim">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$stim_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="etim">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$etim_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="tann">
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$tann_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$publisherValue"/>
                </xsl:element>


                <!--now print all roles related to this-->
                <xsl:choose>
                    <xsl:when test="$person_attributeName = ''"/>
                    <xsl:when
                        test="$dataNode[$nodeNum]/attribute::node()[local-name(.)=$person_attributeName]">
                        <xsl:for-each
                            select="$dataNode[attribute::node()[local-name(.)=$person_attributeName] = $publisherValue]">
                            <xsl:element name="publisherRole">
                                <!--maxOccurs="unbounded" minOccurs="0"-->
                                <xsl:call-template name="sourceVersionStringType">
                                    <xsl:with-param name="ann">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ann_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ref">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ref_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="src">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$src_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ver">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ver_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$role_attributeName"/>
                                </xsl:call-template>
                            </xsl:element>

                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$dataNode[$nodeNum]/node()[local-name(.)=$person_attributeName]">
                        <xsl:for-each
                            select="$dataNode[node()[local-name(.)=$person_attributeName] = $publisherValue]">
                            <xsl:element name="publisherRole">
                                <!--maxOccurs="unbounded" minOccurs="0"-->
                                <xsl:call-template name="sourceVersionStringType">
                                    <xsl:with-param name="ann">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ann_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ref">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ref_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="src">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$src_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="ver">
                                        <xsl:call-template name="thisThingValue">
                                            <xsl:with-param name="s" select="$ver_attributeName"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="thisThingValue">
                                    <xsl:with-param name="s" select="$role_attributeName"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--then $publisherValue is the static string of $person_attributeName, so nothing to iterate-->
                        <xsl:element name="publisherRole">
                            <!--maxOccurs="unbounded" minOccurs="0"-->
                            <xsl:call-template name="sourceVersionStringType">
                                <xsl:with-param name="ann">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ann_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="ref">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ref_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="src">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$src_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="ver">
                                    <xsl:call-template name="thisThingValue">
                                        <xsl:with-param name="s" select="$ver_attributeName"/>
                                        <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="thisThingValue">
                                <xsl:with-param name="s" select="$role_attributeName"/>
                                <xsl:with-param name="dn" select="$dataNode[$nodeNum]"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <!--end printing all related roles-->
            </xsl:element>
        </xsl:if>
        <xsl:if test="$nodeNum &lt; count($dataNode)">
            <xsl:call-template name="pbcorePublisher">
                <xsl:with-param name="dataNode" select="$dataNode"/>
                <xsl:with-param name="person_attributeName" select="$person_attributeName"/>
                <xsl:with-param name="role_attributeName" select="$role_attributeName"/>
                <xsl:with-param name="affil_attributeName" select="$affil_attributeName"/>
                <xsl:with-param name="affref_attributeName" select="$affref_attributeName"/>
                <xsl:with-param name="affann_attributeName" select="$affann_attributeName"/>
                <xsl:with-param name="stim_attributeName" select="$stim_attributeName"/>
                <xsl:with-param name="etim_attributeName" select="$etim_attributeName"/>
                <xsl:with-param name="tann_attributeName" select="$tann_attributeName"/>
                <xsl:with-param name="ann_attributeName" select="$ann_attributeName"/>
                <xsl:with-param name="ref_attributeName" select="$ref_attributeName"/>
                <xsl:with-param name="src_attributeName" select="$src_attributeName"/>
                <xsl:with-param name="ver_attributeName" select="$ver_attributeName"/>
                <xsl:with-param name="doneList"
                    select="concat($doneList,$publisherValue,'&#10;')"/>
                <xsl:with-param name="nodeNum" select="$nextNodeNum"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--end of template "pbcorePublisher"-->



    <xsl:template name="pbcoreRightsSummary" mode="pbcoreRightsSummary" match="UOIS/WGBH_RIGHTS">
        <xsl:param name="dataNode" select="."/>

        <!--<xsl:param name="rightSum_ann" select="'RIGHTS_NOTE'"/>-->
        <xsl:param name="rightSum_ann"/>
        <xsl:param name="rightSum_ref"/>
        <xsl:param name="rightSum_src"/>
        <xsl:param name="rightSum_ver"/>
        <!--<xsl:param name="rightSum_val" select="'RIGHTS'"/>-->
        <xsl:param name="rightSum_val"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <!--<xsl:param name="tann" select="'RIGHTS_COVERAGE'"/>-->
        <xsl:param name="tann"/>

        <xsl:param name="rightsLink_ann"/>
        <xsl:param name="rightsLink_val"/>

        <xsl:param name="rightsEmbedded_ann"/>
        <xsl:param name="rightsEmbedded_val" select="."/>


        <xsl:for-each select="$dataNode">
            <xsl:element name="pbcoreRightsSummary">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="rightsSummaryType">
                    <xsl:with-param name="rightSum_ann">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightSum_ann"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="rightSum_ref">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightSum_ref"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="rightSum_src">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightSum_src"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="rightSum_ver">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightSum_ver"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="rightSum_val">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightSum_val"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="stim">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$stim"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="etim">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$etim"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="tann">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$tann"/>
                        </xsl:call-template>
                    </xsl:with-param>




                    <xsl:with-param name="rightsLink_ann">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightsLink_ann"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="rightsLink_val">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightsLink_val"/>
                        </xsl:call-template>
                    </xsl:with-param>



                    <xsl:with-param name="rightsEmbedded_ann">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightsEmbedded_ann"/>
                        </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="rightsEmbedded_val">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$rightsEmbedded_val"/>
                        </xsl:call-template>
                    </xsl:with-param>

                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="complete_pbcoreInstantiation" mode="pbcoreInstantiation" match="UOIS">
        <!--use this to generate a single, complete pbcoreInstantiation with one (required) instantiationIdentifier element-->
        <xsl:element name="pbcoreInstantiation">
            <!--maxOccurs="unbounded" minOccurs="0"-->
            <xsl:call-template name="instantiationType">
                <xsl:with-param name="makeOptionalElementSets" select="true()"/>
                <xsl:with-param name="stim"/>
                <xsl:with-param name="etim"/>
                <xsl:with-param name="tann"/>

                <xsl:with-param name="id_src" select="'ArtesiaDAM UOI_ID'"/>
                <xsl:with-param name="id_ref"/>
                <xsl:with-param name="id_ver" select="@VERSION"/>
                <xsl:with-param name="id_ann"/>
                <xsl:with-param name="id_val" select="@UOI_ID"/>
            </xsl:call-template>
        </xsl:element>

    </xsl:template>

    <xsl:template name="pbcoreInstantiation">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="isPartType" select="false()"/>
        <xsl:choose>
            <xsl:when test="$isPartType = false()">

                <xsl:element name="pbcoreInstantiation">
                    <!--maxOccurs="unbounded" minOccurs="0"-->

                    <xsl:call-template name="instantiationType">
                        <xsl:with-param name="makeOptionalElementSets" select="false()"/>
                        <xsl:with-param name="stim"/>
                        <xsl:with-param name="etim"/>
                        <xsl:with-param name="tann"/>

                        <xsl:with-param name="id_src" select="'ArtesiaDAM UOI_ID'"/>
                        <xsl:with-param name="id_ref"/>
                        <xsl:with-param name="id_ver" select="UOIS/@VERSION"/>
                        <xsl:with-param name="id_ann"/>
                        <xsl:with-param name="id_val" select="UOIS/@UOI_ID"/>
                    </xsl:call-template>
                    <xsl:call-template name="instantiationIdentifier">
                        <!--call this template for each additional instantationID-->
                        <xsl:with-param name="id_src" select="'Original file name'"/>
                        <xsl:with-param name="id_ref"/>
                        <xsl:with-param name="id_ver" select=" UOIS/@VERSION"/>
                        <xsl:with-param name="id_ann"
                            select="concat('ArtesiaDAM user ID: ',UOIS/@IMPORT_USER_ID, ' imported ',UOIS/@IMPORT_DT)"/>
                        <xsl:with-param name="id_val" select=" UOIS/@NAME"/>
                    </xsl:call-template>

                    <!--articulate optional elements here-->

                    <!--instantiationDate-->
                    <xsl:apply-templates mode="instantiationDate"
                        select="UOIS/WGBH_DATE[@ITEM_DATE]"/>

                    <!--instantiationDimensions-->
                    <xsl:apply-templates mode="instantiationDimensions"
                        select="UOIS/WGBH_FORMAT[@DIMENSION_UNITS | @DIMENSIONS_HEIGHT | @DIMENSIONS_WIDTH]  | UOIS[@MASTER_OBJ_MIME_TYPE]"/>
                    <!--NOTE:  NAMED TEMPLATE 'instantiationDimensions' IS MODEL FOR MULTI-PURPOSE USE TO APPLY/MATCH OR CALL WITH PARAMS-->
                    <!--also, **beware** that templates applied with shared selection and mode may adversely affect each other to create duplicate output-->

                    <!--instantiationPhysical-->
                    <xsl:apply-templates mode="instantiationPhysical"
                        select="UOIS/WGBH_FORMAT[@ITEM_FORMAT != ''][1]"/>

                    <!--instantiationDigital-->
                    <xsl:apply-templates mode="instantiationDigital" select="UOIS"/>

                    <!--instantiationStandard-->
                    <xsl:apply-templates mode="instantiationStandard"
                        select="UOIS/WGBH_FORMAT[@BROADCAST_FORMAT != ''][1]"/>

                    <!--instantiationLocation called because it's a required element-->
                    <xsl:call-template name="instantiationLocation">
                        <xsl:with-param name="dataNode" select="UOIS/WGBH_HOLDINGS"/>
                    </xsl:call-template>

                    <!--instantiationMediaType-->
                    <xsl:apply-templates mode="instantiationMediaType"
                        select="UOIS/WGBH_TYPE[@MEDIA_TYPE != '']">
                        <xsl:with-param name="val" select="'MEDIA_TYPE'"/>
                    </xsl:apply-templates>


                    <!--instantiationGenerations-->
                    <xsl:apply-templates mode="instantiationGenerations" select="UOIS/WGBH_TYPE"/>

                    <!--instantiationFileSize-->
                    <xsl:apply-templates mode="instantiationFileSize" select="unmapped"/>

                    <!--instantiationTimeStart-->
                    <xsl:apply-templates mode="instantiationTimeStart"
                        select="UOIS/WGBH_DESCRIPTION[@DESCRIPTION_COVERAGE_IN][1]"/>

                    <!--instantiationDuration-->
                    <xsl:apply-templates mode="instantiationDuration"
                        select="UOIS/WGBH_FORMAT[@DURATION][1]"/>

                    <!--instantiationDataRate-->
                    <xsl:apply-templates mode="instantiationDataRate"
                        select="UOIS/WGBH_FORMAT[@SAMPLE_RATE][1]"/>

                    <!--instantiationColors-->
                    <xsl:apply-templates mode="instantiationColors"
                        select="UOIS/WGBH_FORMAT[@COLOR != ''][1]"/>

                    <!--instantiationTracks-->
                    <!--special case where unique values are collected and counted-->
                    <xsl:call-template name="instantiationTracks">
                        <xsl:with-param name="dataNode"
                            select="UOIS/WGBH_FORMAT_TRACKS[@TRACK_TYPE != '']"/>
                        <!--note use of quoted strings for attribute-name parameters below-->
                        <xsl:with-param name="trackType_attributeName" select="'TRACK_TYPE'"/>
                    </xsl:call-template>

                    <!--instantiationChannelConfiguration-->
                    <!--special case where unique values are collected from two fields-->
                    <xsl:call-template name="instantiationChannelConfiguration">
                        <xsl:with-param name="dataNode" select="UOIS/WGBH_FORMAT_TRACKS"/>
                        <!--note use of quoted strings for attribute-name parameters below-->
                        <xsl:with-param name="trackDesc_attributeName" select="'TRACK_DESCRIPTION'"/>
                        <xsl:with-param name="trackNote_attributeName" select="'TRACK_NOTE'"/>
                    </xsl:call-template>

                    <!--"instantiationLanguage" type="threeLetterStringType" maxOccurs="1"
                minOccurs="0"-->
                    <xsl:apply-templates mode="instantiationLanguage"
                        select="UOIS/WGBH_LANGUAGE[@LANGUAGE != ''][1]"/>

                    <!--instantiationAlternativeModes-->
                    <!--special case where unique values are collected from two fields-->
                    <xsl:call-template name="instantiationAlternativeModes">
                        <xsl:with-param name="dataNode"
                            select="UOIS/WGBH_FORMAT[ @DVS_YN != '' or @CC_YN != '']"/>
                        <!--note use of quoted strings for attribute-name parameters below-->
                        <xsl:with-param name="ccyn_attributeName" select="'CC_YN'"/>
                        <xsl:with-param name="dvsyn_attributeName" select="'DVS_YN'"/>
                    </xsl:call-template>

                    <!--     <xsl:template name="instantiationEssenceTrack" mode="instantiationEssenceTrack" match="UOIS/WGBH_FORMAT_TRACKS[@TRACK_TYPE != ''] | UOIS/WGBH_ANNOTATION[contains(@ANNOTATION_TYPE,'Quality')]">-->
                    <xsl:call-template name="instantiationEssenceTrack">
                        <xsl:with-param name="dataNode" select="UOIS/WGBH_ANNOTATION[@ANNOTATION_TYPE[contains(translate(.,'QUALITY','quality'),'quality')] and @ANNOTATION[ starts-with(.,'(') and contains(translate(.,'TRACK','track'),' track ')] ]"></xsl:with-param>
                    </xsl:call-template>

                    <!--instantiationRelation-->
                    <xsl:apply-templates mode="instantiationRelation" select="unmapped"/>

                    <!--instantiationRights-->
                    <xsl:apply-templates mode="instantiationRights" select="unmapped"/>

                    <!--instantiationAnnotation-->
                    <xsl:call-template name="instantiationAnnotation">
                        <xsl:with-param name="dataNode" select="UOIS/WGBH_HOLDINGS[@HOLDINGS_NOTE]"/>
                        <xsl:with-param name="elementValue" select="'HOLDINGS_NOTE'"/>
                        <xsl:with-param name="annotationType" select="'!HOLDINGS_NOTE'"/>
                    </xsl:call-template>

                    <!--instantiationPart-->
                    <xsl:apply-templates mode="instantiationPart" select="unmapped"/>

                    <!--instantiationExtension-->
                    <xsl:apply-templates mode="instantiationExtension" select="unmapped"/>


                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!--handle pbcorePart versions here-->
                <xsl:choose>
                    <xsl:when test="$isPartType = 'foo'">
                        <!--any elements used here must appear in specific order!-->
                        <!--
                            remember that these few elements are required
                            <xsl:call-template name="instantiationIdentifier"/>
                        -->
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="instantiationDate" mode="instantiationDate"
        match="UOIS/WGBH_DATE[@ITEM_DATE]">
        <xsl:param name="dtyp"/>
        <xsl:param name="elementValue" select="@ITEM_DATE"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationDate">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="dateStringType">
                    <xsl:with-param name="dtyp" select="$dtyp"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="instantiationDimensions" mode="instantiationDimensions"
        match="UOIS/WGBH_FORMAT[@DIMENSION_UNITS | @DIMENSIONS_HEIGHT | @DIMENSIONS_WIDTH] | UOIS[@MASTER_OBJ_MIME_TYPE]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="tech_ann">
            <xsl:if test="$dataNode/@DIMENSIONS_WIDTH != '' or $dataNode/@BITMAP_WIDTH != ''">
                <xsl:text>horizontal</xsl:text>
            </xsl:if>
            <xsl:if
                test="($dataNode/@DIMENSIONS_HEIGHT != '' and $dataNode/@DIMENSIONS_WIDTH != '') or ( $dataNode/@BITMAP_HEIGHT != '' and $dataNode/@BITMAP_WIDTH != '') ">
                <xsl:text> x </xsl:text>
            </xsl:if>
            <xsl:if test="$dataNode/@DIMENSIONS_HEIGHT != '' or $dataNode/@BITMAP_HEIGHT != ''">
                <xsl:text>vertical</xsl:text>
            </xsl:if>
        </xsl:param>
        <xsl:param name="units">
            <xsl:choose>
                <xsl:when test="$dataNode/@CONTENT_TYPE and $dataNode/@CONTENT_TYPE='BITMAP'">
                    <xsl:text>pixels</xsl:text>
                </xsl:when>
                <xsl:when test="not($dataNode/@DIMENSION_UNITS) or $dataNode/@DIMENSION_UNITS = ''">
                    <xsl:variable name="lc_mime"
                        select="translate(concat($dataNode/@MIME_TYPE,$dataNode/@MASTER_OBJ_MIME_TYPE),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                    <xsl:if test="contains($lc_mime,'video') or contains($lc_mime,'image')">
                        <xsl:text>pixels</xsl:text>
                    </xsl:if>
                    <!--#mime types
                        application
                        audio
                        chemical
                        image
                        message
                        model
                        multipart
                        text
                        video
                        x-conference
                    -->
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:param>
        <xsl:param name="elementValue">
            <xsl:value-of select="$dataNode/@DIMENSIONS_WIDTH | $dataNode/@BITMAP_WIDTH"/>
            <xsl:if
                test="($dataNode/@DIMENSIONS_HEIGHT != '' and $dataNode/@DIMENSIONS_WIDTH != '') or ($dataNode/@BITMAP_HEIGHT != '' and $dataNode/@BITMAP_WIDTH != '') ">
                <xsl:text> x </xsl:text>
            </xsl:if>
            <xsl:value-of select="$dataNode/@DIMENSIONS_HEIGHT | $dataNode/@BITMAP_HEIGHT"/>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationDimensions">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="technicalStringType">
                    <xsl:with-param name="tech_ann" select="$tech_ann"/>
                    <xsl:with-param name="units" select="$units"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationDimensions'-->

    <xsl:template name="instantiationPhysical" mode="instantiationPhysical"
        match="UOIS/WGBH_FORMAT[@ITEM_FORMAT != ''][1]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:param name="elementValue">
            <xsl:value-of select="$dataNode/@ITEM_FORMAT"/>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationPhysical">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$ann"/>
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="src" select="$src"/>
                    <xsl:with-param name="ver" select="$ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationPhysical'-->

    <xsl:template name="instantiationDigital" mode="instantiationDigital" match="UOIS">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:param name="elementValue">
            <xsl:choose>
                <xsl:when
                    test="$dataNode/WGBH_FORMAT[@DIGITAL_FORMAT] and $dataNode/WGBH_FORMAT/@DIGITAL_FORMAT != ''">
                    <xsl:value-of select="$dataNode/WGBH_FORMAT/@DIGITAL_FORMAT"/>
                </xsl:when>
                <xsl:when
                    test="$dataNode/WGBH_FORMAT[@MIME_TYPE] and $dataNode/WGBH_FORMAT/@MIME_TYPE != ''">
                    <xsl:value-of select="$dataNode/WGBH_FORMAT/@MIME_TYPE[1]"/>
                </xsl:when>
                <xsl:when
                    test="$dataNode/@MASTER_OBJ_MIME_TYPE and $dataNode/@MASTER_OBJ_MIME_TYPE !=''">
                    <xsl:value-of select="$dataNode/@MASTER_OBJ_MIME_TYPE"/>
                </xsl:when>
            </xsl:choose>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationDigital">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$ann"/>
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="src" select="$src"/>
                    <xsl:with-param name="ver" select="$ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationDigital'-->

    <xsl:template name="instantiationStandard" mode="instantiationStandard"
        match="UOIS/WGBH_FORMAT[@BROADCAST_FORMAT != ''][1]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="profile"/>
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:param name="elementValue" select="@BROADCAST_FORMAT"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationStandard">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="instantiationStandardStringType">
                    <xsl:with-param name="profile" select="$profile"/>
                    <xsl:with-param name="ann" select="$ann"/>
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="src" select="$src"/>
                    <xsl:with-param name="ver" select="$ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationStandard'-->


    <xsl:template name="instantiationLocation" mode="instantiationLocation"
        match="UOIS/WGBH_HOLDINGS">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="elementValue">
            <xsl:if test="$dataNode/@HOLDINGS_LOCATION and $dataNode/@HOLDINGS_LOCATION != ''">
                <xsl:value-of select="concat($dataNode/@HOLDINGS_LOCATION,', ')"/>
            </xsl:if>
            <xsl:if test="$dataNode/@HOLDINGS_DEPARTMENT and $dataNode/@HOLDINGS_DEPARTMENT != ''">
                <xsl:value-of select="concat($dataNode/@HOLDINGS_DEPARTMENT,' (department), ')"/>
            </xsl:if>
            <xsl:if test="$dataNode/@HOLDINGS_INSTITUTION and $dataNode/@HOLDINGS_INSTITUTION != ''">
                <xsl:value-of select="concat($dataNode/@HOLDINGS_INSTITUTION,' (institution), ')"/>
            </xsl:if>
            <xsl:if test="$dataNode/@HOLDINGS_TYPE and $dataNode/@HOLDINGS_TYPE != ''">
                <xsl:value-of select="concat($dataNode/@HOLDINGS_TYPE,' (type), ')"/>
            </xsl:if>
            <xsl:if test="$dataNode/@HOLDINGS_STATUS and $dataNode/@HOLDINGS_STATUS != ''">
                <xsl:value-of select="concat($dataNode/@HOLDINGS_STATUS,' (status), ')"/>
            </xsl:if>
            <xsl:if test="$dataNode/@HOLDINGS_NOTE and $dataNode/@HOLDINGS_NOTE != ''">
                <xsl:value-of select="concat($dataNode/@HOLDINGS_NOTE,' (note), ')"/>
            </xsl:if>
        </xsl:param>
        <xsl:element name="instantiationLocation">
            <!--maxOccurs="1" minOccurs="1"-->
            <xsl:choose>
                <xsl:when test="substring($elementValue,string-length($elementValue)-1,2) = ', '">
                    <xsl:value-of select="substring($elementValue,1,string-length($elementValue)-2)"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$elementValue"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

    </xsl:template>
    <!--end template 'instantiationLocation'-->

    <xsl:template name="instantiationMediaType" mode="instantiationMediaType" match="UOIS/WGBH_TYPE">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ann"/>
        <xsl:param name="val" select="'MEDIA_TYPE'"/>
        <xsl:if test="$val != '' or attribute::node()[local-name(.)=$val] != ''">
            <xsl:element name="instantiationMediaType">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$ann"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="thisThingValue">
                    <xsl:with-param name="s" select="$val"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="instantiationGenerations" mode="instantiationGenerations"
        match="UOIS/WGBH_TYPE[@GENERATION_TYPE]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:param name="elementValue">
            <xsl:choose>
                <xsl:when test="$dataNode/@GENERATION_TYPE and $dataNode/@GENERATION_TYPE != ''">
                    <xsl:value-of select="$dataNode/@GENERATION_TYPE"/>
                </xsl:when>
            </xsl:choose>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationGenerations">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$ann"/>
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="src" select="$src"/>
                    <xsl:with-param name="ver" select="$ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>


        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationGenerations'-->

    <xsl:template name="instantiationFileSize" mode="instantiationFileSize" match="unmapped[1]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="tech_ann"/>
        <xsl:param name="units"/>
        <xsl:param name="elementValue"> </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationFileSize">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="technicalStringType">
                    <xsl:with-param name="tech_ann" select="$tech_ann"/>
                    <xsl:with-param name="units" select="$units"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationFileSize'-->


    <xsl:template name="instantiationTimeStart" mode="instantiationTimeStart"
        match="UOIS/WGBH_DESCRIPTION[@DESCRIPTION_COVERAGE_IN][1]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="elementValue">
            <xsl:value-of select="$dataNode/@DESCRIPTION_COVERAGE_IN"/>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationTimeStart">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationTimeStart'-->

    <xsl:template name="instantiationDuration" mode="instantiationDuration"
        match="UOIS/WGBH_FORMAT[@DURATION][1]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="elementValue">
            <xsl:value-of select="$dataNode/@DURATION"/>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationDuration">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationDuration'-->

    <xsl:template name="instantiationDataRate" mode="instantiationDataRate"
        match="UOIS/WGBH_FORMAT[@SAMPLE_RATE]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="tech_ann"/>
        <xsl:param name="units"/>
        <xsl:param name="elementValue">
            <xsl:value-of select="$dataNode/@SAMPLE_RATE"/>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationDataRate">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="technicalStringType">
                    <xsl:with-param name="tech_ann" select="$tech_ann"/>
                    <xsl:with-param name="units" select="$units"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationDataRate'-->

    <xsl:template name="instantiationColors" mode="instantiationColors"
        match="UOIS/WGBH_FORMAT[@COLOR != ''][1]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:param name="elementValue">
            <xsl:value-of select="$dataNode/@COLOR"/>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationColors">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$ann"/>
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="src" select="$src"/>
                    <xsl:with-param name="ver" select="$ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationColors'-->


    <!--special case where unique values are collected from one source and counted by re-iterating template from within -->
    <xsl:template name="instantiationTracks">
        <xsl:param name="dataNode" select="UOIS/WGBH_FORMAT_TRACKS[@TRACK_TYPE != '']"/>
        <xsl:param name="elementValue">
            <xsl:value-of select="'&lt;instantiationTracks&gt;'"
                disable-output-escaping="yes"/>
        </xsl:param>
        <xsl:param name="doneList" select="'&#10;'"/>
        <xsl:param name="nodeNum" select="1"/>
        <!--note use of quoted strings for attribute-name parameter below-->
        <xsl:param name="trackType_attributeName" select="'TRACK_TYPE'"/>

        <xsl:variable name="nextNodeNum" select="$nodeNum+1"/>
        <xsl:choose>
            <xsl:when test="$nodeNum &lt; count($dataNode)">
                <xsl:call-template name="instantiationTracks">
                    <xsl:with-param name="dataNode" select="$dataNode"/>
                    <xsl:with-param name="doneList"
                        select="concat($doneList,$dataNode[$nodeNum]/attribute::node()[local-name()=$trackType_attributeName],'&#10;')"/>
                    <xsl:with-param name="nodeNum" select="$nextNodeNum"/>
                    <xsl:with-param name="elementValue">
                        <xsl:value-of select="$elementValue"/>
                        <xsl:choose>
                            <xsl:when
                                test="not(contains($doneList,concat('&#10;',$dataNode[$nodeNum]/attribute::node()[local-name()=$trackType_attributeName],'&#10;')))">
                                <xsl:value-of
                                    select="concat(count($dataNode[attribute::node()[local-name()=$trackType_attributeName]=$dataNode[$nodeNum]/attribute::node()[local-name()=$trackType_attributeName]]),'x ',$dataNode[$nodeNum]/attribute::node()[local-name()=$trackType_attributeName],', ')"
                                />
                            </xsl:when>
                        </xsl:choose>

                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="contains($elementValue,',')">
                    <xsl:value-of
                        select="concat( substring($elementValue,1,string-length($elementValue)-2),'&lt;/instantiationTracks&gt;',$lf)"
                        disable-output-escaping="yes"/>
                </xsl:if>

            </xsl:otherwise>

        </xsl:choose>


    </xsl:template>
    <!--end of template "instantiationTracks"-->


    <!--special case where unique values are collected from two sources by re-iterating template from within -->
    <xsl:template name="instantiationChannelConfiguration">
        <xsl:param name="dataNode"
            select="UOIS/WGBH_FORMAT_TRACKS[@TRACK_DESCRIPTION != '' | @TRACK_NOTE != '']"/>
        <xsl:param name="elementValue">
            <xsl:value-of select="'&lt;instantiationChannelConfiguration&gt;'"
                disable-output-escaping="yes"/>
        </xsl:param>
        <xsl:param name="doneList" select="'&#10;'"/>
        <xsl:param name="nodeNum" select="1"/>
        <!--note use of quoted strings for attribute-name parameter below-->
        <xsl:param name="trackDesc_attributeName" select="'TRACK_DESCRIPTION'"/>
        <xsl:param name="trackNote_attributeName" select="'TRACK_NOTE'"/>

        <xsl:variable name="nextNodeNum" select="$nodeNum+1"/>
        <xsl:choose>
            <xsl:when test="$nodeNum &lt; count($dataNode)">
                <xsl:call-template name="instantiationChannelConfiguration">
                    <xsl:with-param name="dataNode" select="$dataNode"/>
                    <xsl:with-param name="doneList"
                        select="concat($doneList,$dataNode[$nodeNum]/attribute::node()[local-name()=$trackDesc_attributeName],'&#10;',$dataNode[$nodeNum]/attribute::node()[local-name()=$trackNote_attributeName],'&#10;')"/>
                    <xsl:with-param name="nodeNum" select="$nextNodeNum"/>
                    <xsl:with-param name="elementValue">
                        <xsl:value-of select="$elementValue"/>

                        <xsl:if
                            test="not(contains($doneList,concat('&#10;',$dataNode[$nodeNum]/attribute::node()[local-name()=$trackDesc_attributeName],'&#10;')))">
                            <xsl:value-of
                                select="concat($dataNode[$nodeNum]/attribute::node()[local-name()=$trackDesc_attributeName],', ')"
                            />
                        </xsl:if>
                        <xsl:if
                            test="not(contains($doneList,concat('&#10;',$dataNode[$nodeNum]/attribute::node()[local-name()=$trackNote_attributeName],'&#10;')))">
                            <xsl:value-of
                                select="concat($dataNode[$nodeNum]/attribute::node()[local-name()=$trackNote_attributeName],', ')"
                            />
                        </xsl:if>

                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="contains($elementValue,',')">
                    <xsl:value-of
                        select="concat( substring($elementValue,1,string-length($elementValue)-2),'&lt;/instantiationChannelConfiguration&gt;',$lf)"
                        disable-output-escaping="yes"/>
                </xsl:if>

            </xsl:otherwise>

        </xsl:choose>


    </xsl:template>
    <!--end template 'instantiationChannelConfiguration'-->

    <xsl:template name="instantiationLanguage" mode="instantiationLanguage"
        match="UOIS/WGBH_LANGUAGE[@LANGUAGE != ''][1]">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:param name="elementValue">
            <xsl:value-of select="$dataNode/@LANGUAGE"/>
        </xsl:param>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="instantiationLanguage">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="threeLetterStringType">
                    <xsl:with-param name="ann" select="$ann"/>
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="src" select="$src"/>
                    <xsl:with-param name="ver" select="$ver"/>
                    <xsl:with-param name="someCode" select="$elementValue"/>
                </xsl:call-template>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template 'instantiationLanguage'-->

    <!--special case where unique values are collected from two sources by re-iterating template from within -->
    <xsl:template name="instantiationAlternativeModes">
        <xsl:param name="dataNode" select="UOIS/WGBH_FORMAT[ @DVS_YN != '' or @CC_YN != '']"/>
        <xsl:param name="elementValue">
            <xsl:value-of select="'&lt;instantiationAlternativeModes&gt;'"
                disable-output-escaping="yes"/>
            <!--maxOccurs="1" minOccurs="0"-->
        </xsl:param>
        <xsl:param name="doneList" select="'&#10;'"/>
        <xsl:param name="nodeNum" select="0"/>
        <!--note use of quoted strings for attribute-name parameter below-->
        <xsl:param name="ccyn_attributeName" select="'CC_YN'"/>
        <xsl:param name="dvsyn_attributeName" select="'DVS_YN'"/>

        <xsl:variable name="nextNodeNum" select="$nodeNum+1"/>

        <xsl:choose>
            <xsl:when test="$nodeNum &lt; count($dataNode)">
                <xsl:call-template name="instantiationAlternativeModes">
                    <xsl:with-param name="dataNode" select="$dataNode"/>
                    <xsl:with-param name="doneList">
                        <xsl:value-of select="$doneList"/>
                        <xsl:if
                            test="$dataNode[$nodeNum]/attribute::node()[local-name()=$ccyn_attributeName] and (string-length(translate($dataNode[$nodeNum]/attribute::node()[local-name()=$ccyn_attributeName],'NOno0 ','') &gt; 0))">
                            <xsl:value-of select="concat($ccyn_attributeName,'&#10;')"/>
                        </xsl:if>
                        <xsl:if
                            test="$dataNode[$nodeNum]/attribute::node()[local-name()=$dvsyn_attributeName] and (string-length(translate($dataNode[$nodeNum]/attribute::node()[local-name()=$dvsyn_attributeName],'NOno0 ','') &gt; 0))">
                            <xsl:value-of select="concat($dvsyn_attributeName,'&#10;')"/>
                        </xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="nodeNum" select="$nextNodeNum"/>
                    <xsl:with-param name="elementValue">
                        <xsl:value-of select="$elementValue"/>
                        <xsl:if
                            test="not(contains($doneList,concat('&#10;',$ccyn_attributeName,'&#10;')))">
                            <!--<xsl:value-of select="concat($dataNode[$nodeNum]/attribute::node()[local-name()=$ccyn_attributeName],', ')"/>-->
                            <xsl:text>Closed Captioned.  </xsl:text>
                            <!--<xsl:for-each select="UOIS/WGBH_FORMAT_CC/attribute::node()">
                                <xsl:value-of select="concat(local-name(.),'=','&quot;',.,'&quot;',', ')"/>
                                </xsl:for-each>-->
                        </xsl:if>
                        <xsl:if
                            test="not(contains($doneList,concat('&#10;',$dvsyn_attributeName,'&#10;')))">
                            <!--<xsl:value-of select="concat($dataNode[$nodeNum]/attribute::node()[local-name()=$dvsyn_attributeName],', ')"/>-->
                            <xsl:text>Described Video.  </xsl:text>
                            <!--<xsl:for-each select="UOIS/WGBH_FORMAT_DVS/attribute::node()">
                                <xsl:value-of select="concat(local-name(.),'=','&quot;',.,'&quot;',', ')"/>
                                </xsl:for-each>-->
                        </xsl:if>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="contains($elementValue,' ')">
                    <xsl:variable name="extraInfo">
                        <xsl:for-each select="UOIS/WGBH_FORMAT_CC/attribute::node()">
                            <xsl:value-of
                                select="concat(local-name(.),':','&quot;',.,'&quot;','; ')"
                            />
                        </xsl:for-each>
                        <xsl:for-each select="UOIS/WGBH_FORMAT_DVS/attribute::node()">
                            <xsl:value-of
                                select="concat(local-name(.),':','&quot;',.,'&quot;','; ')"
                            />
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$extraInfo != ''">
                            <xsl:value-of
                                select=" normalize-space(concat($elementValue,'(',substring($extraInfo,1,string-length($extraInfo)-2),')','&lt;/instantiationAlternativeModes&gt;'))"
                                disable-output-escaping="yes"/>

                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="concat(normalize-space($elementValue),'&lt;/instantiationAlternativeModes&gt;',$lf)"
                                disable-output-escaping="yes"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--end template 'instantiationAlternativeModes'-->


    <!--special case where an element value potentially iterates across other nodes & templates-->
    <xsl:template name="instantiationEssenceTrack">
        <xsl:param name="dataNode" select="."/>

        <xsl:param name="doneList" select="'&#10;'"/>
        <xsl:param name="nodeNum" select="1"/>
        <xsl:variable name="nextNodeNum" select="$nodeNum+1"/>

        <xsl:choose>
            <xsl:when test="local-name($dataNode) = 'WGBH_FORMAT'">
                
                <xsl:element name="instantiationEssenceTrack">
                    <!--essenceTrackAspectRatio?-->
                    <xsl:call-template name="essenceTrackAspectRatio">
                        <xsl:with-param name="elementValue" select="$dataNode/@ASPECT_RATIO"/>
                    </xsl:call-template>
                    <!--essenceTrackFrameRate?-->
                    <xsl:call-template name="essenceTrackFrameRate">
                        <xsl:with-param name="elementValue" select="$dataNode/@FRAME_RATE"/>
                    </xsl:call-template>
                </xsl:element>    
            </xsl:when>
            
            
            <xsl:when test="local-name($dataNode) = 'WGBH_ANNOTATION'">
                <xsl:variable name="trackName"
                select=" substring-before(substring-after($dataNode[$nodeNum]/@ANNOTATION,'('),')')"/>
                <xsl:if
                    test="$dataNode[$nodeNum]/@ANNOTATION and not(contains($doneList,concat('&#10;',$trackName,'&#10;')))">
                    <xsl:element name="instantiationEssenceTrack">
                        <!--maxOccurs="unbounded" minOccurs="0"-->

                        <xsl:call-template name="essenceTrackType">
                            <xsl:with-param name="tracktype"
                                select="substring-before($trackName,' ')"/>
                        </xsl:call-template>
                        <xsl:call-template name="essenceTrackIdentifier">
                            <xsl:with-param name="elementValue" select="$trackName"/>
                        </xsl:call-template>
                        <!--essenceTrackStandard?-->
                        <xsl:call-template name="essenceTrackEncoding">
                            <xsl:with-param name="elementValue">
                                <xsl:value-of
                                    select=" normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and contains(.,'compression format')]][1]/@ANNOTATION,':'))"
                                />
                            </xsl:with-param>
                        </xsl:call-template>
                        <!--essenceTrackDataRate?-->
                        <!--essenceTrackFrameRate?-->


                        <xsl:if test="contains(translate($trackName,'VIDEO','video'),'video')">
                            <xsl:call-template name="essenceTrackPlaybackSpeed">
                                <xsl:with-param name="units">
                                    <xsl:value-of
                                        select=" normalize-space(substring-after(substring-before($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and contains(.,' per ')]][1]/@ANNOTATION,':'),concat('(',$trackName,')')))"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="elementValue">
                                    <xsl:value-of
                                        select=" normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and contains(.,' per ')]][1]/@ANNOTATION,':'))"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if
                            test="contains(translate($trackName,'AUDIO','audio'),'audio') or contains(translate($trackName,'SOUND','sound'),'sound')">
                            <xsl:call-template name="essenceTrackSamplingRate">
                                <xsl:with-param name="units">
                                    <xsl:value-of
                                        select=" normalize-space(substring-after(substring-before($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and contains(.,' per ')]][1]/@ANNOTATION,':'),concat('(',$trackName,')')))"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="elementValue">
                                    <xsl:value-of
                                        select=" normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and contains(.,' per ')]][1]/@ANNOTATION,':'))"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>


                        <xsl:call-template name="essenceTrackBitDepth">
                            <xsl:with-param name="elementValue">
                                <!--NOTE:  the following assumes delimiters ':' and '/', header substrings 'bits' and 'depth', formatted like 'header1/header2 : value1/value2'-->
                                <xsl:variable name="headersString"
                                    select="normalize-space(substring-after(substring-before($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,'depth') or contains(.,'bits'))]][1]/@ANNOTATION,':'),concat('(',$trackName,')')))"/>
                                <xsl:variable name="headerKeyword">
                                    <!--NOTE: this assumes keywords ('depth','bits', etc.) appear singularly and separately (not together) in the headersString -->
                                    <xsl:choose>
                                        <xsl:when test="contains($headersString,'depth')">
                                            <!--it is a video item-->
                                            <xsl:text>depth</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>bits</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="whatNum">
                                    <xsl:call-template name="countThisCharacter">
                                        <xsl:with-param name="someString"
                                            select="substring-before($headersString,$headerKeyword)"
                                        />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="valuesString"
                                    select="normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,$headerKeyword) )]][1]/@ANNOTATION,':'))"/>
                                <xsl:variable name="valueString">
                                    <xsl:call-template name="substringNum">
                                        <xsl:with-param name="someString" select="$valuesString"/>
                                        <xsl:with-param name="stopNum" select="$whatNum"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--finally, print out the value here-->
                                <xsl:value-of select="normalize-space($valueString)"/>
                            </xsl:with-param>
                        </xsl:call-template>

                        <!--essenceTrackFrameSize?-->
                        <xsl:call-template name="essenceTrackFrameSize">
                            <xsl:with-param name="elementValue">
                                <!--NOTE:  the following assumes source data delimiters ':' and '/', header substrings 'width' and 'height', formatted like 'header1/header2 : value1/value2'-->
                                <xsl:variable name="headersString"
                                    select="normalize-space(substring-after(substring-before($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,'width') and contains(.,'height'))]][1]/@ANNOTATION,':'),concat('(',$trackName,')')))"/>
                                <xsl:variable name="valueString">
                                    <xsl:call-template name="substringNum">
                                        <xsl:with-param name="someString"
                                            select="normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,'width') )]][1]/@ANNOTATION,':'))"/>
                                        <xsl:with-param name="stopNum">
                                            <xsl:call-template name="countThisCharacter">
                                                <xsl:with-param name="someString"
                                                  select="substring-before($headersString,'width')"
                                                />
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:if test="$headersString != ''">
                                        <xsl:value-of select="' x '"/>
                                    </xsl:if>
                                    <xsl:call-template name="substringNum">
                                        <xsl:with-param name="someString"
                                            select="normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,'height') )]][1]/@ANNOTATION,':'))"/>
                                        <xsl:with-param name="stopNum">
                                            <xsl:call-template name="countThisCharacter">
                                                <xsl:with-param name="someString"
                                                  select="substring-before($headersString,'height')"
                                                />
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--finally, print out the value here-->
                                <xsl:value-of select="normalize-space($valueString)"/>
                            </xsl:with-param>
                            <xsl:with-param name="trackframesize_ann" select="'width x height'"/>
                        </xsl:call-template>

                        <!--essenceTrackAspectRatio?-->
                        <xsl:call-template name="essenceTrackAspectRatio">
                            <xsl:with-param name="elementValue">
                                <!--NOTE:  the following assumes delimiters ':' and '/', header substrings 'width' and 'height', formatted like 'header1/header2 : value1/value2'-->
                                <xsl:variable name="headersString"
                                    select="normalize-space(substring-after(substring-before($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,'width') and contains(.,'height'))]][1]/@ANNOTATION,':'),concat('(',$trackName,')')))"/>
                                <xsl:variable name="width">
                                    <xsl:variable name="width" select="'foo'"/>
                                    <xsl:call-template name="substringNum">
                                        <xsl:with-param name="someString"
                                            select="normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,'width') )]][1]/@ANNOTATION,':'))"/>
                                        <xsl:with-param name="stopNum">
                                            <xsl:call-template name="countThisCharacter">
                                                <xsl:with-param name="someString"
                                                  select="substring-before($headersString,'width')"
                                                />
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="height">
                                    <xsl:call-template name="substringNum">
                                        <xsl:with-param name="someString"
                                            select="normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and (contains(.,'height') )]][1]/@ANNOTATION,':'))"/>
                                        <xsl:with-param name="stopNum">
                                            <xsl:call-template name="countThisCharacter">
                                                <xsl:with-param name="someString"
                                                  select="substring-before($headersString,'height')"
                                                />
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="ratioNumString"
                                    select="substring($width div $height,1,4)"/>
                                <xsl:choose>
                                    <xsl:when
                                        test="$ratioNumString = '2.39' or $ratioNumString = '2.40' or $ratioNumString = '1.85'">
                                        <!--a current widescreen cinema standard-->
                                        <xsl:value-of select="concat($ratioNumString,':1')"/>
                                    </xsl:when>
                                    <xsl:when
                                        test="($ratioNumString = '1.77') or  ($ratioNumString = '1.78') ">
                                        <!--HD video standard-->
                                        <xsl:value-of select="'16:9'"/>
                                    </xsl:when>
                                    <xsl:when test="$ratioNumString = '1.66' ">
                                        <!--common European widescreen standard; native Super 16mm film-->
                                        <xsl:value-of select="'5:3'"/>
                                    </xsl:when>
                                    <xsl:when test="$ratioNumString = '1.5'">
                                        <!--35mm film-->
                                        <xsl:value-of select="'3:2'"/>
                                    </xsl:when>
                                    <xsl:when test="$ratioNumString = '1.33'">
                                        <!--HD video standard-->
                                        <xsl:value-of select="'3:2'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$width * $height &gt; 0 ">
                                            <xsl:value-of select="concat($ratioNumString,':1')"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                            <xsl:with-param name="trackaspectratio_ann" select="'width:height'"/>
                        </xsl:call-template>

                        <!--essenceTrackTimeStart?-->
                        <xsl:call-template name="essenceTrackTimeStart">
                            <xsl:with-param name="elementValue">
                                <xsl:value-of
                                    select=" normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and contains(.,'start time')]][1]/@ANNOTATION,':'))"
                                />
                            </xsl:with-param>
                        </xsl:call-template>

                        <!--essenceTrackDuration?-->
                        <xsl:call-template name="essenceTrackDuration">
                            <xsl:with-param name="elementValue">
                                <xsl:value-of
                                    select=" normalize-space(substring-after($dataNode[@ANNOTATION[ starts-with(.,concat('(',$trackName,')')) and contains(.,'duration')]][1]/@ANNOTATION,':'))"
                                />
                            </xsl:with-param>
                        </xsl:call-template>

                        <!--essenceTrackLanguage?-->

                        <!--essenceTrackAnnotation?-->

                        <!--essenceTrackExtension?-->


                    </xsl:element>

                </xsl:if>
                <xsl:if test="$nodeNum &lt; count($dataNode)">
                    <xsl:call-template name="instantiationEssenceTrack">
                        <xsl:with-param name="dataNode" select="$dataNode"/>
                        <!---->
                        <xsl:with-param name="doneList"
                            select="concat($doneList,$trackName,'&#10;')"/>
                        <xsl:with-param name="nodeNum" select="$nextNodeNum"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>

        </xsl:choose>
    </xsl:template>
    <!--end of template "instantiationEssenceTrack"-->


    <xsl:template name="instantiationRelation" mode="instantiationRelation" match="unmapped">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="type_ann"/>
        <xsl:param name="type_ref"/>
        <xsl:param name="type_src"/>
        <xsl:param name="type_ver"/>
        <xsl:param name="id_ann"/>
        <xsl:param name="id_ref"/>
        <xsl:param name="id_src"/>
        <xsl:param name="id_ver"/>
        <xsl:element name="instantiationRelation">
            <!--maxOccurs="unbounded" minOccurs="0"-->

            <xsl:element name="instantiationRelationType">
                <!--maxOccurs="1" minOccurs="1"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$dataNode/@foo"/>
                    <xsl:with-param name="ref"/>
                    <xsl:with-param name="src"/>
                    <xsl:with-param name="ver"/>
                </xsl:call-template>
                <xsl:value-of select="$dataNode/@RELATION_TYPE"/>
            </xsl:element>

            <xsl:element name="instantiationRelationIdentifier">
                <!--maxOccurs="1" minOccurs="1"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$dataNode/@foo"/>
                    <xsl:with-param name="ref"/>
                    <xsl:with-param name="src"/>
                    <xsl:with-param name="ver"/>
                </xsl:call-template>
                <xsl:value-of select="$dataNode/@bar"/>
            </xsl:element>

        </xsl:element>

    </xsl:template>
    <!--end template instantiationRelation-->

    <xsl:template name="instantiationRights" mode="instantiationRights" match="unmapped">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="rightSum_ann"/>
        <xsl:param name="rightSum_ref"/>
        <xsl:param name="rightSum_src"/>
        <xsl:param name="rightSum_ver"/>
        <xsl:param name="rightSum_val"/>

        <xsl:param name="rightsLink_ann"/>
        <xsl:param name="rightsLink_val"/>

        <xsl:param name="rightsEmbedded_ann"/>
        <xsl:param name="rightsEmbedded_val"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>

        <xsl:element name="instantiationRights">
            <!-- maxOccurs="unbounded" minOccurs="0"-->
            <xsl:call-template name="rightsSummaryType">
                <xsl:with-param name="rightSum_ann" select="$rightSum_ann"/>
                <xsl:with-param name="rightSum_ref" select="$rightSum_ref"/>
                <xsl:with-param name="rightSum_src" select="$rightSum_src"/>
                <xsl:with-param name="rightSum_ver" select="$rightSum_ver"/>
                <xsl:with-param name="rightSum_val" select="$rightSum_val"/>
                <xsl:with-param name="stim" select="$stim"/>
                <xsl:with-param name="etim" select="$etim"/>
                <xsl:with-param name="tann" select="$tann"/>

                <xsl:with-param name="rightsLink_ann" select="$rightsLink_ann"/>
                <xsl:with-param name="rightsLink_val" select="$rightsLink_val"/>

                <xsl:with-param name="rightsEmbedded_ann" select="$rightsEmbedded_ann"/>
                <xsl:with-param name="rightsEmbedded_val" select="$rightsEmbedded_val"/>

            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <!--end template instantiationRights-->


    <!--instantiationAnnotation-->
    <xsl:template name="instantiationAnnotation" mode="instantiationAnnotation" match="unmapped">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="annotationType"/>
        <xsl:param name="ref"/>
        <xsl:param name="elementValue"/>

        <xsl:for-each select="$dataNode">
            <xsl:element name="instantiationAnnotation">
                <!--maxOccurs="unbounded" minOccurs="0" -->
                <xsl:call-template name="annotationStringType">
                    <xsl:with-param name="ref">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$ref"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="annotationType">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$annotationType"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="thisThingValue">
                    <xsl:with-param name="s" select="$elementValue"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!--end template instantiationAnnotation-->


    <xsl:template name="instantiationPart" mode="instantiationPart" match="unmapped">
        <xsl:param name="dataNode" select="."/>
        <xsl:element name="instantiationPart">
            <!--maxOccurs="unbounded" minOccurs="0"-->
            <xsl:call-template name="instantiationType">
                <xsl:with-param name="makeOptionalElementSets" select="false()"/>
                <xsl:with-param name="stim"/>
                <xsl:with-param name="etim"/>
                <xsl:with-param name="tann"/>

                <xsl:with-param name="id_src"/>
                <xsl:with-param name="id_ref"/>
                <xsl:with-param name="id_ver"/>
                <xsl:with-param name="id_ann"/>
                <xsl:with-param name="id_val"/>
            </xsl:call-template>
        </xsl:element>

    </xsl:template>
    <!--end template instantiationPart-->


    <xsl:template name="instantiationExtension" mode="instantiationExtension" match="unmapped">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="annotationType"/>
        <xsl:param name="ref"/>
        <xsl:param name="embeddedType_ann"/>
        <xsl:if test="$dataNode and count($dataNode) &gt; 0">
            <xsl:for-each select="$dataNode">
                <xsl:element name="instantiationExtension">
                    <!--maxOccurs="unbounded" minOccurs="0"-->
                    <xsl:call-template name="extensionType">
                        <xsl:with-param name="dataNode" select="$dataNode"/>
                        <xsl:with-param name="extensionAuthorityUsed" select="'WGBH'"/>
                    </xsl:call-template>
                </xsl:element>

            </xsl:for-each>

        </xsl:if>
    </xsl:template>
    <!--end template "instantiationExtension"-->


    <xsl:template name="pbcoreAnnotation">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="ref"/>
        <xsl:param name="annotationType"/>
        <xsl:param name="elementValue"/>

        <xsl:for-each select="$dataNode">
            <xsl:element name="pbcoreAnnotation">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="annotationStringType">
                    <xsl:with-param name="ref">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$ref"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="annotationType">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$annotationType"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="thisThingValue">
                    <xsl:with-param name="s" select="$elementValue"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>








    <xsl:template name="pbcorePart" mode="pbcorePart" match="unmapped">
        <xsl:param name="dataNode" select="."/>

        <xsl:element name="pbcorePart">
            <!--maxOccurs="unbounded" minOccurs="0"-->
            <xsl:call-template name="pbcorePartType">
                <xsl:with-param name="stim"/>
                <xsl:with-param name="etim"/>
                <xsl:with-param name="tann"/>
            </xsl:call-template>
        </xsl:element>

    </xsl:template>

    <xsl:template name="pbcoreExtension" mode="pbcoreExtension" match="unmapped">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="extensionType" select="'extensionEmbedded'"/>
        <!--alternative extensionType is 'extensionWrap'-->
        <xsl:param name="annotationType"/>
        <xsl:param name="embeddedType_ann"/>
        <xsl:if
            test="contains($extensionType,'extensionEmbedded') or contains($extensionType,'extensionWrap')">
            <xsl:if test="$dataNode and count($dataNode) &gt; 0">
                <xsl:for-each select="$dataNode">
                    <xsl:element name="pbcoreExtension">
                        <!--maxOccurs="unbounded" minOccurs="0"-->
                        <xsl:call-template name="extensionType">
                            <xsl:with-param name="dataNode" select="$dataNode"/>
                            <xsl:with-param name="extensionType" select="$extensionType"/>
                            <xsl:with-param name="embeddedType_ann" select="$embeddedType_ann"/>
                            <xsl:with-param name="extensionAuthorityUsed" select="'WGBH'"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!--end template "pbcoreExtension"-->






















































































































    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->
    <!--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-->

    <!--begin section, named definitions of attribute group primitives-->

    <xsl:template name="instantiationType">
        <!--call this after starting a pbcoreInstantiation wrapper element to generate a valid, complete instantiation-->
        <xsl:param name="makeOptionalElementSets" select="false()"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>

        <xsl:param name="id_src"/>
        <xsl:param name="id_ref"/>
        <xsl:param name="id_ver"/>
        <xsl:param name="id_ann"/>
        <xsl:param name="id_val" select="'missing required value'"/>

        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="stim">
                <xsl:value-of select="$stim"/>
            </xsl:with-param>
            <xsl:with-param name="etim">
                <xsl:value-of select="$etim"/>
            </xsl:with-param>
            <xsl:with-param name="tann">
                <xsl:value-of select="$tann"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="instantiationIdentifier">
            <xsl:with-param name="id_src" select="$id_src"/>
            <xsl:with-param name="id_ref" select="$id_ref"/>
            <xsl:with-param name="id_ver" select="$id_ver"/>
            <xsl:with-param name="id_ann" select="$id_ann"/>
            <xsl:with-param name="id_val" select="$id_val"/>
        </xsl:call-template>
        <xsl:if test="$makeOptionalElementSets">
            <!--generate optional element sets from here-->
            <xsl:apply-templates mode="instantiationTypeOptionalElements" select="*"/>
        </xsl:if>
    </xsl:template>


    <xsl:template name="instantiationIdentifier">
        <xsl:param name="id_src"/>
        <xsl:param name="id_ref"/>
        <xsl:param name="id_ver"/>
        <xsl:param name="id_ann"/>
        <xsl:param name="id_val" select="'missing required value'"/>
        <xsl:element name="instantiationIdentifier">
            <!--maxOccurs="unbounded" minOccurs="1"-->
            <xsl:call-template name="requiredSourceVersionStringType">
                <xsl:with-param name="src" select="$id_src"/>
                <xsl:with-param name="ref" select="$id_ref"/>
                <xsl:with-param name="ver" select="$id_ver"/>
                <xsl:with-param name="ann" select="$id_ann"/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="$id_val = ''">
                    <xsl:text>missing required value</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$id_val"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

    </xsl:template>


    <xsl:template name="essenceTrackType">
        <xsl:param name="tracktype"/>
        <xsl:if test="$tracktype != ''">
            <xsl:element name="essenceTrackType">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:value-of select="$tracktype"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>
    <!--end template "essenceTrackType"-->

    <xsl:template name="essenceTrackIdentifier">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="trackid_ann"/>
        <xsl:param name="trackid_ref"/>
        <xsl:param name="trackid_src"/>
        <xsl:param name="trackid_ver"/>
        <xsl:param name="elementValue"/>
        <xsl:choose>
            <xsl:when test="$elementValue != ''">
                <xsl:element name="essenceTrackIdentifier">
                    <!--maxOccurs="unbounded" minOccurs="0"-->
                    <xsl:call-template name="sourceVersionStringType">
                        <xsl:with-param name="ann" select="$trackid_ann"/>
                        <xsl:with-param name="ref" select="$trackid_ref"/>
                        <xsl:with-param name="src" select="$trackid_src"/>
                        <xsl:with-param name="ver" select="$trackid_ver"/>
                    </xsl:call-template>
                    <xsl:value-of select="$elementValue"/>
                </xsl:element>


            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$dataNode">
                    <xsl:element name="essenceTrackIdentifier">
                        <!--maxOccurs="unbounded" minOccurs="0"-->
                        <xsl:call-template name="sourceVersionStringType">
                            <xsl:with-param name="ann" select="$trackid_ann"/>
                            <xsl:with-param name="ref" select="$trackid_ref"/>
                            <xsl:with-param name="src" select="$trackid_src"/>
                            <xsl:with-param name="ver" select="$trackid_ver"/>
                        </xsl:call-template>
                        <xsl:choose>
                            <xsl:when test="./text() != ''">
                                <xsl:value-of select="./text()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>

                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--end template "essenceTrackIdentifier"-->

    <xsl:template name="essenceTrackStandard">
        <xsl:param name="trackstd_ann"/>
        <xsl:param name="trackstd_ref"/>
        <xsl:param name="trackstd_src"/>
        <xsl:param name="trackstd_ver"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackStandard">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$trackstd_ann"/>
                    <xsl:with-param name="ref" select="$trackstd_ref"/>
                    <xsl:with-param name="src" select="$trackstd_src"/>
                    <xsl:with-param name="ver" select="$trackstd_ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackEncoding">
        <xsl:param name="trackencod_ann"/>
        <xsl:param name="trackencod_ref"/>
        <xsl:param name="trackencod_src"/>
        <xsl:param name="trackencod_ver"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackEncoding">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$trackencod_ann"/>
                    <xsl:with-param name="ref" select="$trackencod_ref"/>
                    <xsl:with-param name="src" select="$trackencod_src"/>
                    <xsl:with-param name="ver" select="$trackencod_ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackDataRate">
        <xsl:param name="tech_ann"/>
        <xsl:param name="units"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackDataRate">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="technicalStringType">
                    <xsl:with-param name="tech_ann" select="$tech_ann"/>
                    <xsl:with-param name="units" select="$units"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackFrameRate">
        <xsl:param name="tech_ann"/>
        <xsl:param name="units"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackFrameRate">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="technicalStringType">
                    <xsl:with-param name="tech_ann" select="$tech_ann"/>
                    <xsl:with-param name="units" select="$units"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackPlaybackSpeed">
        <xsl:param name="tech_ann"/>
        <xsl:param name="units"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackPlaybackSpeed">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="technicalStringType">
                    <xsl:with-param name="tech_ann" select="$tech_ann"/>
                    <xsl:with-param name="units" select="$units"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackSamplingRate">
        <xsl:param name="tech_ann"/>
        <xsl:param name="units"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackSamplingRate">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="technicalStringType">
                    <xsl:with-param name="tech_ann" select="$tech_ann"/>
                    <xsl:with-param name="units" select="$units"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackBitDepth">
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackBitDepth">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackFrameSize">
        <xsl:param name="trackframesize_ann"/>
        <xsl:param name="trackframesize_ref"/>
        <xsl:param name="trackframesize_src"/>
        <xsl:param name="trackframesize_ver"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackFrameSize">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$trackframesize_ann"/>
                    <xsl:with-param name="ref" select="$trackframesize_ref"/>
                    <xsl:with-param name="src" select="$trackframesize_src"/>
                    <xsl:with-param name="ver" select="$trackframesize_ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackAspectRatio">
        <xsl:param name="trackaspectratio_ann"/>
        <xsl:param name="trackaspectratio_ref"/>
        <xsl:param name="trackaspectratio_src"/>
        <xsl:param name="trackaspectratio_ver"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackAspectRatio">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="sourceVersionStringType">
                    <xsl:with-param name="ann" select="$trackaspectratio_ann"/>
                    <xsl:with-param name="ref" select="$trackaspectratio_ref"/>
                    <xsl:with-param name="src" select="$trackaspectratio_src"/>
                    <xsl:with-param name="ver" select="$trackaspectratio_ver"/>
                </xsl:call-template>
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackTimeStart">
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackTimeStart">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackDuration">
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackDuration">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:value-of select="$elementValue"/>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackLanguage">
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:param name="elementValue"/>
        <xsl:if test="$elementValue != ''">
            <xsl:element name="essenceTrackLanguage">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:call-template name="threeLetterStringType">
                    <xsl:with-param name="ann" select="$ann"/>
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="src" select="$src"/>
                    <xsl:with-param name="ver" select="$ver"/>
                    <xsl:with-param name="someCode" select="$elementValue"/>
                </xsl:call-template>
            </xsl:element>

        </xsl:if>
    </xsl:template>

    <xsl:template name="essenceTrackAnnotation">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="annotationType"/>
        <xsl:param name="ref"/>
        <xsl:param name="elementValue"/>

        <xsl:for-each select="$dataNode">
            <xsl:element name="essenceTrackAnnotation">
                <!--maxOccurs="unbounded" minOccurs="0"-->
                <xsl:call-template name="annotationStringType">
                    <xsl:with-param name="ref">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$ref"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="annotationType">
                        <xsl:call-template name="thisThingValue">
                            <xsl:with-param name="s" select="$annotationType"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="thisThingValue">
                    <xsl:with-param name="s" select="$elementValue"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!--end template "essenceTrackAnnotation"-->


    <xsl:template name="essenceTrackExtension">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="annotationType"/>
        <xsl:param name="extensionType" select="'extensionEmbedded'"/>
        <!--alternative extensionType is 'extensionWrap'-->
        <xsl:param name="embeddedType_ann"/>
        <xsl:if
            test="contains($extensionType,'extensionEmbedded') or contains($extensionType,'extensionWrap')">
            <xsl:if test="$dataNode and count($dataNode) &gt; 0">
                <xsl:for-each select="$dataNode">
                    <xsl:element name="essenceTrackExtension">
                        <!--maxOccurs="unbounded" minOccurs="0"-->
                        <xsl:call-template name="extensionType">
                            <xsl:with-param name="dataNode" select="$dataNode"/>
                            <xsl:with-param name="extensionAuthorityUsed" select="'WGBH'"/>
                            <xsl:with-param name="extensionType" select="$extensionType"/>
                        </xsl:call-template>
                    </xsl:element>

                </xsl:for-each>

            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!--end template "essenceTrackExtension"-->






















    <xsl:template name="extensionType">
        <xsl:param name="dataNode"/>
        <xsl:param name="extensionType" select="'extensionEmbedded'"/>
        <!--alternative extensionType is 'extensionWrap'-->

        <xsl:param name="extensionAuthorityUsed"/>
        <xsl:param name="embeddedType_ann"/>

        <xsl:choose>
            <xsl:when test="$extensionType='extensionWrap'">
                <xsl:for-each select="$dataNode">
                    <xsl:element name="extensionElement">
                        <xsl:value-of select="local-name(.)"/>
                    </xsl:element>
                    <xsl:element name="extensionValue">
                        <xsl:choose>
                            <xsl:when test="text() != ''">
                                <xsl:value-of select="./text()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'(empty value'"/>
                                <xsl:variable name="prettyValues">
                                    <xsl:if test="count(attribute::node()) > 0">
                                        <xsl:value-of
                                            select="concat(', ',count(attribute::node()),' attribute')"
                                        />
                                    </xsl:if>
                                    <xsl:if test="count(attribute::node()) &gt; 1">
                                        <xsl:text>s</xsl:text>
                                    </xsl:if>
                                    <xsl:text>)</xsl:text>
                                    <xsl:if test="count(attribute::node()) > 0">
                                        <xsl:text>:  </xsl:text>
                                    </xsl:if>
                                    <xsl:for-each select="attribute::node()">
                                        <xsl:value-of
                                            select="concat('(',local-name(),'=', current(),'), ')"/>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="contains($prettyValues,', ')">
                                        <xsl:value-of
                                            select="substring($prettyValues,1,string-length($prettyValues)-2)"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$prettyValues"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="extensionAuthorityUsed">
                        <xsl:value-of select="$extensionAuthorityUsed"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>

            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="count($dataNode) &gt; 0">
                        <xsl:for-each select="$dataNode">
                            <xsl:element name="extensionEmbedded">
                                <!--                maxOccurs="unbounded" minOccurs="1" type="embeddedType"-->
                                <xsl:call-template name="embeddedType">
                                    <xsl:with-param name="embeddedType_ann"
                                        select="$embeddedType_ann"/>
                                </xsl:call-template>

                                <xsl:copy-of select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--the parent element has already been committed; this child is required and can be null-->
                        <xsl:element name="extensionEmbedded">
                            <!--                maxOccurs="unbounded" minOccurs="1" type="embeddedType"-->
                            <xsl:call-template name="embeddedType">
                                <xsl:with-param name="embeddedType_ann"/>
                            </xsl:call-template>
                            <xsl:copy-of select="."/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--end template extensionType-->


    <xsl:template name="pbcorePartType">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="isPartType"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>


        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="stim">
                <xsl:value-of select="$stim"/>
            </xsl:with-param>
            <xsl:with-param name="etim">
                <xsl:value-of select="$etim"/>
            </xsl:with-param>
            <xsl:with-param name="tann">
                <xsl:value-of select="$tann"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="pbcoreDescriptionDocumentType">
            <xsl:with-param name="dataNode" select="$dataNode"/>
            <xsl:with-param name="isPartType" select="$isPartType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="dateStringType">
        <xsl:param name="dtyp"/>
        <xsl:if test="$dtyp != ''">
            <xsl:attribute name="dateType">
                <xsl:value-of select="$dtyp"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="sourceVersionStringType">
        <!--this looks dumb but follows the XSD-->
        <xsl:param name="ann"/>
        <xsl:param name="ref"/>
        <xsl:param name="src"/>
        <xsl:param name="ver"/>
        <xsl:call-template name="sourceVersionGroup">
            <xsl:with-param name="ann" select="$ann"/>
            <xsl:with-param name="ref" select="$ref"/>
            <xsl:with-param name="src" select="$src"/>
            <xsl:with-param name="ver" select="$ver"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="requiredSourceVersionStringType">
        <xsl:param name="src" select="'missing value'"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>
        <xsl:attribute name="source">
            <xsl:choose>
                <xsl:when test="$src != ''">
                    <xsl:value-of select="$src"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>missing value, null provided</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:if test="$ref != ''">
            <xsl:attribute name="ref">
                <xsl:value-of select="$ref"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$ver != ''">
            <xsl:attribute name="version">
                <xsl:value-of select="$ver"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$ann != ''">
            <xsl:attribute name="annotation">
                <xsl:value-of select="$ann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="titleStringType">
        <xsl:param name="ttyp"/>
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>
        <xsl:attribute name="titleType">
            <xsl:value-of select="$ttyp"/>
        </xsl:attribute>
        <xsl:call-template name="sourceVersionGroup">
            <xsl:with-param name="src">
                <xsl:value-of select="$src"/>
            </xsl:with-param>
            <xsl:with-param name="ref">
                <xsl:value-of select="$ref"/>
            </xsl:with-param>
            <xsl:with-param name="ver">
                <xsl:value-of select="$ver"/>
            </xsl:with-param>
            <xsl:with-param name="ann">
                <xsl:value-of select="$ann"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="stim">
                <xsl:value-of select="$stim"/>
            </xsl:with-param>
            <xsl:with-param name="etim">
                <xsl:value-of select="$etim"/>
            </xsl:with-param>
            <xsl:with-param name="tann">
                <xsl:value-of select="$tann"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subjectStringType">
        <xsl:param name="sbjt"/>
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>
        <xsl:if test="$sbjt != ''">
            <xsl:attribute name="subjectType">
                <xsl:value-of select="$sbjt"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="sourceVersionGroup">
            <xsl:with-param name="ann" select="$ann"/>
            <xsl:with-param name="src" select="$src"/>
            <xsl:with-param name="ref" select="$ref"/>
            <xsl:with-param name="ver" select="$ver"/>
        </xsl:call-template>
        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="stim" select="$stim"/>
            <xsl:with-param name="etim" select="$etim"/>
            <xsl:with-param name="tann" select="$tann"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="descriptionStringType">
        <xsl:param name="dsann"/>
        <xsl:param name="dstyp"/>
        <xsl:param name="dstypsrc"/>
        <xsl:param name="dstypref"/>
        <xsl:param name="dstypver"/>
        <xsl:param name="dstypann"/>
        <xsl:param name="segtyp"/>
        <xsl:param name="segtypsrc"/>
        <xsl:param name="segtypref"/>
        <xsl:param name="segtypver"/>
        <xsl:param name="segtypann"/>
        <xsl:param name="etim"/>
        <xsl:param name="stim"/>
        <xsl:param name="tann"/>

        <xsl:if test="$dsann != ''">
            <xsl:attribute name="annotation">
                <xsl:value-of select="$dsann"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="descriptionTypeSourceVersionGroup">
            <xsl:with-param name="dstyp" select="$dstyp"/>
            <xsl:with-param name="dstypsrc" select="$dstypsrc"/>
            <xsl:with-param name="dstypref" select="$dstypref"/>
            <xsl:with-param name="dstypver" select="$dstypver"/>
            <xsl:with-param name="dstypann" select="$dstypann"/>
        </xsl:call-template>
        <xsl:call-template name="segmentTypeSourceVersionGroup">
            <xsl:with-param name="segtyp" select="$segtyp"/>
            <xsl:with-param name="segtypsrc" select="$segtypsrc"/>
            <xsl:with-param name="segtypref" select="$segtypref"/>
            <xsl:with-param name="segtypver" select="$segtypver"/>
            <xsl:with-param name="segtypann" select="$segtypann"/>
        </xsl:call-template>
        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="etim" select="$etim"/>
            <xsl:with-param name="stim" select="$stim"/>
            <xsl:with-param name="tann" select="$tann"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="sourceVersionStartEndStringType">
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>

        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="etim" select="$etim"/>
            <xsl:with-param name="stim" select="$stim"/>
            <xsl:with-param name="tann" select="$tann"/>
        </xsl:call-template>
        <xsl:call-template name="sourceVersionGroup">
            <xsl:with-param name="ann" select="$ann"/>
            <xsl:with-param name="src" select="$src"/>
            <xsl:with-param name="ref" select="$ref"/>
            <xsl:with-param name="ver" select="$ver"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="affiliatedStringType">
        <xsl:param name="affil"/>
        <xsl:param name="affref"/>
        <xsl:param name="affann"/>
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>

        <xsl:if test="$affil != ''">
            <xsl:attribute name="affiliation">
                <xsl:value-of select="$affil"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$affref != ''">
            <xsl:attribute name="ref">
                <xsl:value-of select="$affref"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$affann != ''">
            <xsl:attribute name="annotation">
                <xsl:value-of select="$affann"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="etim" select="$etim"/>
            <xsl:with-param name="stim" select="$stim"/>
            <xsl:with-param name="tann" select="$tann"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="contributorStringType">
        <xsl:param name="contrib_portrayal"/>
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>

        <xsl:if test="$contrib_portrayal != ''">
            <xsl:attribute name="portrayal">
                <xsl:value-of select="$contrib_portrayal"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="sourceVersionGroup">
            <xsl:with-param name="ann" select="$ann"/>
            <xsl:with-param name="src" select="$src"/>
            <xsl:with-param name="ref" select="$ref"/>
            <xsl:with-param name="ver" select="$ver"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="technicalStringType">
        <xsl:param name="units" select="'missing value'"/>
        <xsl:param name="tech_ann"/>
        <xsl:choose>
            <xsl:when test="$units != ''">
                <xsl:attribute name="unitsOfMeasure">
                    <xsl:value-of select="$units"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="unitsOfMeasure">
                    <xsl:value-of select="'missing value'"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>


        <xsl:if test="$tech_ann != ''">
            <xsl:attribute name="annotation">
                <xsl:value-of select="$tech_ann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="instantiationStandardStringType">
        <xsl:param name="profile"/>
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>

        <xsl:if test="$profile != ''">
            <xsl:attribute name="profile">
                <xsl:value-of select="$profile"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="sourceVersionGroup">
            <xsl:with-param name="ann" select="$ann"/>
            <xsl:with-param name="src" select="$src"/>
            <xsl:with-param name="ref" select="$ref"/>
            <xsl:with-param name="ver" select="$ver"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="annotationStringType">
        <xsl:param name="annotationType"/>
        <xsl:param name="ref"/>
        <xsl:if test="$annotationType != ''">
            <xsl:attribute name="annotationType">
                <xsl:value-of select="$annotationType"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$ref != ''">
            <xsl:attribute name="ref">
                <xsl:value-of select="$ref"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="rightsSummaryType">
        <!--The rights can be expressed as a summary OR a link OR an embedded XML record. These can also contain time relations-->
        <xsl:param name="rightSum_ann"/>
        <xsl:param name="rightSum_ref"/>
        <xsl:param name="rightSum_src"/>
        <xsl:param name="rightSum_ver"/>
        <xsl:param name="rightSum_val"/>

        <xsl:param name="rightsLink_ann"/>
        <xsl:param name="rightsLink_val"/>

        <xsl:param name="rightsEmbedded_ann"/>
        <!--<xsl:param name="rightsEmbedded_val"/>-->
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>

        <xsl:call-template name="startEndTimeGroup">
            <xsl:with-param name="stim">
                <xsl:value-of select="$stim"/>
            </xsl:with-param>
            <xsl:with-param name="etim">
                <xsl:value-of select="$etim"/>
            </xsl:with-param>
            <xsl:with-param name="tann">
                <xsl:value-of select="$tann"/>
            </xsl:with-param>
        </xsl:call-template>

        <xsl:choose>
            <xsl:when test="$rightSum_val != ''">
                <xsl:element name="rightsSummary">
                    <!--maxOccurs="1" minOccurs="0"-->
                    <xsl:call-template name="sourceVersionStringType">
                        <xsl:with-param name="ann" select="$rightSum_ann"/>
                        <xsl:with-param name="ref" select="$rightSum_ref"/>
                        <xsl:with-param name="src" select="$rightSum_src"/>
                        <xsl:with-param name="ver" select="$rightSum_ver"/>
                    </xsl:call-template>
                    <xsl:value-of select="$rightSum_val"/>
                    <!--This is an all-purpose container field to identify information about copyrights and property rights held
                    in and over a media item, whether they are open access or restricted in some way.  
                    If dates, times and availability periods are associated with a right, include them. 
                    End user permissions, constraints and obligations may also be identified, as needed.-->
                </xsl:element>

            </xsl:when>
            <xsl:when test="$rightsLink_val != ''">
                <!--maxOccurs="1" minOccurs="0"-->
                <xsl:element name="rightsLink">
                    <xsl:call-template name="rightsLinkType">
                        <xsl:with-param name="rightsLink_ann" select="$rightsLink_ann"/>
                    </xsl:call-template>
                    <xsl:value-of select="$rightsLink_val"/>
                    <!--this would be a URI pointing to a declaration of rights-->
                </xsl:element>

            </xsl:when>
            <xsl:otherwise>
                <!--                <xsl:if test="$rightsEmbedded_val != ''">-->
                <xsl:element name="rightsEmbedded">
                    <!--maxOccurs="1" minOccurs="0"-->
                    <xsl:call-template name="embeddedType">
                        <xsl:with-param name="embeddedType_ann" select="$rightsEmbedded_ann"/>
                    </xsl:call-template>
                    <xsl:copy-of select="."/>
                    <!--<xsl:value-of select="$rightsEmbedded_val"/>-->
                    <!--this would be XML data-->
                </xsl:element>

                <!--                </xsl:if>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="rightsLinkType">
        <xsl:param name="rightsLink_ann"/>
        <xsl:if test="$rightsLink_ann != ''">
            <xsl:attribute name="annotation">
                <xsl:value-of select="$rightsLink_ann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="embeddedType">
        <xsl:param name="embeddedType_ann"/>
        <xsl:if test="$embeddedType_ann != ''">
            <xsl:attribute name="annotation">
                <xsl:value-of select="$embeddedType_ann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="threeLetterStringType">
        <xsl:param name="someCode"/>
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>

        <xsl:call-template name="sourceVersionGroup">
            <xsl:with-param name="ann" select="$ann"/>
            <xsl:with-param name="src" select="$src"/>
            <xsl:with-param name="ref" select="$ref"/>
            <xsl:with-param name="ver" select="$ver"/>
        </xsl:call-template>
        <xsl:call-template name="threeLetterCode">
            <xsl:with-param name="someCodeString" select="$someCode"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="threeLetterCode">
        <xsl:param name="someCodeString"/>
        <!-- from the XSD:           ([a-z]{3}((;[a-z]{3})?)*)?-->
        <xsl:variable name="stringTest"
            select="string-length((translate($someCodeString,'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz ','')) = 0) and (string-length(translate($someCodeString,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz')) = 3)"/>
        <!--forgives extra spaces but enforces count of 3 letters-->
        <xsl:if test="$stringTest = true()">
            <xsl:value-of
                select="translate($someCodeString,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ','abcdefghijklmnopqrstuvwxyz')"/>
            <!--returns only 3 lower-case letters-->
        </xsl:if>
    </xsl:template>

    <xsl:template name="descriptionTypeSourceVersionGroup">
        <xsl:param name="dstyp" select="$dstyp"/>
        <xsl:param name="dstypsrc" select="$dstypsrc"/>
        <xsl:param name="dstypref" select="$dstypref"/>
        <xsl:param name="dstypver" select="$dstypver"/>
        <xsl:param name="dstypann" select="$dstypann"/>

        <xsl:if test="$dstyp != ''">
            <xsl:attribute name="descriptionType">
                <xsl:value-of select="$dstyp"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$dstypsrc != ''">
            <xsl:attribute name="descriptionTypeSource">
                <xsl:value-of select="$dstypsrc"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$dstypref != ''">
            <xsl:attribute name="descriptionTypeRef">
                <xsl:value-of select="$dstypref"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$dstypver != ''">
            <xsl:attribute name="descriptionTypeVersion">
                <xsl:value-of select="$dstypver"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$dstypann != ''">
            <xsl:attribute name="descriptionTypeAnnotation">
                <xsl:value-of select="$dstypann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="sourceVersionGroup">
        <xsl:param name="src"/>
        <xsl:param name="ref"/>
        <xsl:param name="ver"/>
        <xsl:param name="ann"/>
        <xsl:if test="$src != ''">
            <xsl:attribute name="source">
                <xsl:value-of select="$src"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$ref != ''">
            <xsl:attribute name="ref">
                <xsl:value-of select="$ref"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$ver != ''">
            <xsl:attribute name="version">
                <xsl:value-of select="$ver"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$ann != ''">
            <xsl:attribute name="annotation">
                <xsl:value-of select="$ann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="startEndTimeGroup">
        <xsl:param name="stim"/>
        <xsl:param name="etim"/>
        <xsl:param name="tann"/>
        <xsl:if test="$stim !=''">
            <xsl:attribute name="startTime">
                <xsl:value-of select="$stim"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$etim !=''">
            <xsl:attribute name="endTime">
                <xsl:value-of select="$etim"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$tann != ''">
            <xsl:attribute name="timeAnnotation">
                <xsl:value-of select="$tann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="segmentTypeSourceVersionGroup">
        <xsl:param name="segtyp" select="$segtyp"/>
        <xsl:param name="segtypsrc" select="$segtypsrc"/>
        <xsl:param name="segtypref" select="$segtypref"/>
        <xsl:param name="segtypver" select="$segtypver"/>
        <xsl:param name="segtypann" select="$segtypann"/>

        <xsl:if test="$segtyp != ''">
            <xsl:attribute name="segmentType">
                <xsl:value-of select="$segtyp"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$segtypsrc != ''">
            <xsl:attribute name="segmentTypeSource">
                <xsl:value-of select="$segtypsrc"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$segtypref != ''">
            <xsl:attribute name="segmentTypeRef">
                <xsl:value-of select="$segtypref"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$segtypver != ''">
            <xsl:attribute name="segmentTypeVersion">
                <xsl:value-of select="$segtypver"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$segtypann != ''">
            <xsl:attribute name="segmentTypeAnnotation">
                <xsl:value-of select="$segtypann"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="substringNum">
        <xsl:param name="delimiterString" select="'/'"/>
        <xsl:param name="someString"/>
        <xsl:param name="loopNum" select="1"/>
        <xsl:param name="stopNum" select="1"/>
        <xsl:choose>
            <xsl:when test="$loopNum &gt; $stopNum">
                <xsl:choose>
                    <xsl:when test="contains($someString,$delimiterString)">
                        <xsl:value-of select="substring-before($someString,$delimiterString)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$someString"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$loopNum = $stopNum">
                <xsl:choose>
                    <xsl:when
                        test="substring-before(substring-after($someString,$delimiterString),$delimiterString) = ''">
                        <xsl:value-of select="substring-after($someString,$delimiterString)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="substring-before(substring-after($someString,$delimiterString),$delimiterString)"
                        />
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="substringNum">
                    <xsl:with-param name="delimiterString" select="$delimiterString"/>
                    <xsl:with-param name="stopNum" select="$stopNum"/>
                    <xsl:with-param name="loopNum" select="$loopNum + 1"/>
                    <xsl:with-param name="someString"
                        select="substring-after($someString,$delimiterString)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="countThisCharacter">
        <xsl:param name="someString"/>
        <xsl:param name="someCharacter" select="'/'"/>
        <xsl:param name="charNum" select="1"/>
        <xsl:param name="charCount" select="0"/>
        <xsl:choose>
            <xsl:when test="$charNum &gt; string-length($someString)">
                <xsl:value-of select="number($charCount)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="addNumber">
                    <xsl:choose>
                        <xsl:when test="substring($someString,$charNum,1) = $someCharacter">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="countThisCharacter">
                    <xsl:with-param name="someString" select="$someString"/>
                    <xsl:with-param name="someCharacter" select="$someCharacter"/>
                    <xsl:with-param name="charNum" select="$charNum + 1"/>
                    <xsl:with-param name="charCount" select="$charCount + $addNumber"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="processLinks" match="/TEAMS_ASSET_FILE/LINKS/LINK[@SOURCE]">
        <!--this returns a line-delimited string of all values sought-->
        <xsl:param name="returnValue" select="'entity'"/>
        <xsl:param name="searchUOID"/>
        <xsl:if test="$searchUOID != ''">
            <xsl:variable name="queryString">
                <xsl:value-of select="unparsed-entity-uri(@SOURCE)"/>
                <!--<xsl:value-of select="unparsed-entity-uri(@SOURCE)"/>-->
                <!--substitute (@DESTINATION)-->
            </xsl:variable>
            <xsl:variable name="uoidString">
                <xsl:value-of
                    select="substring-after($queryString,'teams:/query-uoi?uois:uoi_id:eq:')"/>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$returnValue != 'entity'">
                    <xsl:value-of select="concat($uoidString,'&#10;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$searchUOID = $uoidString">
                        <xsl:value-of select="concat(@SOURCE,'&#10;')"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!--    <xsl:template name="thisThingValue">
        <xsl:param name="dataNode" select="."/>
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="$s = ''"/>
            <xsl:when test="$dataNode/attribute::node()[local-name(.)=$s]">
                <xsl:value-of select="$dataNode/attribute::node()[local-name(.)=$s]"
                />
            </xsl:when>
            <xsl:when test="$dataNode/node()[local-name(.)=$s]">
                <xsl:value-of select="$dataNode/node()[local-name(.)=$s]/text()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$s"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    <xsl:template name="thisThingValue">
        <xsl:param name="dn" select="."/>
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="$s = ''"/>
            <xsl:when test="$dn/attribute::node()[local-name(.)=$s]">
                <xsl:value-of select="$dn/attribute::node()[local-name(.)=$s]"/>
            </xsl:when>
            <xsl:when test="$dn/node()[local-name(.)=$s]">
                <xsl:value-of select="$dn/node()[local-name(.)=$s]/text()"/>
            </xsl:when>
            <xsl:otherwise>
                <!--NOTE: STRING LITERAL VALUES MUST BE SPECIALLY FORMATTED TO BEGIN WITH "!"-->
                <xsl:value-of select="substring-after($s,'!')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>




</xsl:stylesheet>
