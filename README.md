# Open Vault

### Rebasing the old Open Vault site onto a shiny new hydra head

[![Build Status](https://travis-ci.org/afred/openvault.png)](https://travis-ci.org/afred/openvault)

#### Homepage sprites will be rebuilt when new files are in the mosaic folder in images and the sass file is changed and saved

**To import and parse pbcore XML file**

	ng = Nokogiri::XML(open('PATH/TO/FILE'))
	
	all_docs = ng.xpath("//x:pbcoreDescriptionDocument", "x" => "http://www.pbcore.org/PBCore/PBCoreNamespace.html")
	
	all_docs.each do |doc|
		ov = OpenvaultAsset.new
		ov.apply_depositor_metadata '1123@me.com'
		ov.pbcore.ng_xml = doc
		ov.save
	end

**To import a folder of xml files**

	Dir.foreach('/Users/josh_wilcox/Desktop/demo_xml') do |item|
	  next if item == '.' or item == '..'
	  ng = Nokogiri::XML(open("/Users/josh_wilcox/Desktop/demo_xml/#{item}"))
	  ov = OpenvaultAsset.new
	  ov.apply_depositor_metadata '123@me.com'
	  ov.pbcore.ng_xml = ng
	  ov.save
	end
  