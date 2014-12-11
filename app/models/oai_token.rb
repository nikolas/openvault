class OaiToken
  def initialize(start)
    @start = start
  end
  def to_xml
    "<resumptionToken>#{@start}</resumptionToken>"
  end
end