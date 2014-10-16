class ActiveFedoraProxy

  attr_reader :config
  attr_accessor :target_object

  def initialize(target_object)
    @target_object = target_object
    
    # default configuration
    config.get_solr_id_using = :solr_id
    config.get_fedora_pid_using = :fedora_pid
    config.solr_service = ActiveFedora::SolrService
    config.active_fedora = ActiveFedora::Base
  end

  def config
    @config ||= OpenStruct.new
  end

  def fedora_pid
    if config.get_fedora_pid_using.respond_to? :to_sym
      target_object.send(config.get_fedora_pid_using.to_sym)
    elsif config.get_fedora_pid_using.respond_to?(:call)
      config.get_fedora_pid_using.call(self)
    else
      raise MissingConfig, "No method for getting the fedora pid has been specified. To specify, use #{self.class}#config.get_fedora_pid_using = {GETTER}, where {GETTER} is a callable thing (e.g. a Proc), or is a symbol representing a method on the target object."
    end
  end

  def fedora_object
    @fedora_object ||= fetch_fedora_object
  end

  def fetch_fedora_object
    begin
      fetch_fedora_object!
    rescue ActiveFedora::ObjectNotFoundError => e
      nil
    end
  end

  def fetch_fedora_object!
    config.active_fedora.find fedora_pid
  end

  def solr_id
    if config.get_solr_id_using.respond_to? :to_sym
      target_object.send(config.get_solr_id_using.to_sym)
    elsif config.get_solr_id_using.respond_to? :call
      config.get_solr_id_using.call(self)
    else
      raise MissingConfig, "No method for getting the solr id has been specified. To specify, use #{self.class}#config.get_solr_id_using = {GETTER}, where {GETTER} is a callable thing (e.g. a Proc), or is a symbol representing a method on the target object."
    end
  end

  def solr_doc
    @solr_doc ||= fetch_solr_doc
  end

  def fetch_solr_doc
    begin
      fetch_solr_doc!
    rescue SolrDocNotFound => e
      nil
    end
  end

  def fetch_solr_doc!
    response = config.solr_service.query("id:#{solr_id}")['response']
    return response['docs'].first if response['docs'].count == 1
    raise SolrDocNotFound, "No solr document found with id = #{solr_id}"
  end

  class MissingConfig < StandardError; end
  class SolrDocNotFound < StandardError; end


end