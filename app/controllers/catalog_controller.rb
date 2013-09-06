# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Blacklight::Solr::Document::MoreLikeThis
  
  # include BlacklightOaiProvider::ControllerExtension
  # include BlacklightOembed::ControllerExtension
  # 
  # include BlacklightHighlight::ControllerExtension
  # 
  # include BlacklightMoreLikeThis::ControllerExtension
  # 
  # include BlacklightFacetExtras::Query::ControllerExtension
  # include BlacklightFacetExtras::Tag::ControllerExtension
  # include BlacklightFacetExtras::Hierarchy::ControllerExtension
  # include BlacklightFacetExtras::Filter::ControllerExtension
  # 
  # include Openvault::SolrHelper::DefaultSort
  # include Openvault::SolrHelper::BoostMedia
  # include Openvault::SolrHelper::Restrictions
  
  # These before_filters apply the hydra access controls
  #before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  #CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  
  ### Need to figure out why this is breaking search
  # This applies appropriate access controls to all solr queries
  #CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic += [:exclude_unwanted_models]
  
  caches_action :show, :expires_in => 1.day, :if => proc { |c|
    current_user.nil? 
  }
  caches_action :home, :expires_in => 1.hour, :if => proc { |c| current_user.nil? }

  
  
  configure_blacklight do |config|
    config.default_solr_params = { 
      :qt => 'search',
      :rows => 10,
      :defType => 'edismax',
      :qf => 'text'
    }
    
    config.index.show_link = 'title_clip_ssm'
    config.add_index_field 'asset_date_ssm', :label => 'Date Created'
    config.add_index_field 'series_ssm', :label => 'Program'
    
# 
#     # solr field configuration for document/show views
    config.show.html_title = 'title_clip_ssm'
    config.show.heading = 'title_clip_ssm'
    config.show.display_type = 'has_model_ssim'
    config.add_show_field 'subject_name_ssm', :label => 'Topics:'

# 
#     # solr fields that will be treated as facets by the blacklight application
#     #   The ordering of the field names is the order of the display
#     #
#     # Setting a limit will trigger Blacklight's 'more' facet values link.
#     # * If left unset, then all facet values returned by solr will be displayed.
#     # * If set to an integer, then "f.somefield.facet.limit" will be added to
#     # solr request, with actual solr request being +1 your configured limit --
#     # you configure the number of items you actually want _tsimed_ in a page.    
#     # * If set to 'true', then no additional parameters will be sent to solr,
#     # but any 'sniffed' request limit parameters will be used for paging, with
#     # paging at requested limit -1. Can sniff from facet.limit or 
#     # f.specific_field.facet.limit solr request params. This 'true' config
#     # can be used if you set limits in :default_solr_params, or as defaults
#     # on the solr side in the request handler itself. Request handler defaults
#     # sniffing requires solr requests to be made with "echoParams=all", for
#     # app code to actually have it echo'd back to see it.  
#     #
#     # :show may be set to false if you don't want the facet to be drawn in the 
#     # facet bar
    config.add_facet_field solr_name('category', :facetable), :label => "Categories"
    config.add_facet_field solr_name('subject_facet', :facetable), :label => 'Topics'
    config.add_facet_field solr_name('series', :facetable), :label => 'Series'
    config.add_facet_field solr_name('program_facet', :facetable), :label => 'Program'    
    config.add_facet_field solr_name('people', :facetable), :label => "People"
    # config.add_facet_field solr_name('pub_date', :facetable), :label => 'Publication Year' 
    # config.add_facet_field solr_name('subject_topic', :facetable), :label => 'Topic', :limit => 20 
    # config.add_facet_field solr_name('language', :facetable), :label => 'Language', :limit => true 
    # config.add_facet_field solr_name('lc1_letter', :facetable), :label => 'Call Number' 
    # config.add_facet_field solr_name('subject_geo', :facetable), :label => 'Region' 
    # config.add_facet_field solr_name('subject_era', :facetable), :label => 'Era'  
# 
#     # Have BL send all facet field names to Solr, which has been the default
#     # previously. Simply remove these lines if you'd rather use Solr request
#     # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
#     #use this instead if you don't want to query facets marked :show=>false
#     #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys
# 
# 
#     # solr fields to be displayed in the index (search results) view
#     #   The ordering of the field names is the order of the display 
#     config.add_index_field solr_name('title', :stored_searchable, type: :string), :label => 'Title:' 
#     config.add_index_field solr_name('title_vern', :stored_searchable, type: :string), :label => 'Title:' 
#     config.add_index_field solr_name('author', :stored_searchable, type: :string), :label => 'Author:' 
#     config.add_index_field solr_name('author_vern', :stored_searchable, type: :string), :label => 'Author:' 
#     config.add_index_field solr_name('format', :symbol), :label => 'Format:' 
#     config.add_index_field solr_name('language', :stored_searchable, type: :string), :label => 'Language:'
#     config.add_index_field solr_name('published', :stored_searchable, type: :string), :label => 'Published:'
#     config.add_index_field solr_name('published_vern', :stored_searchable, type: :string), :label => 'Published:'
#     config.add_index_field solr_name('lc_callnum', :stored_searchable, type: :string), :label => 'Call number:'
# # 
# #     # solr fields to be displayed in the show (single result) view
# #     #   The ordering of the field names is the order of the display 
#     config.add_show_field solr_name('title', :stored_searchable, type: :string), :label => 'Title:' 
#     config.add_show_field solr_name('title_vern', :stored_searchable, type: :string), :label => 'Title:' 
#     config.add_show_field solr_name('subtitle', :stored_searchable, type: :string), :label => 'Subtitle:' 
#     config.add_show_field solr_name('subtitle_vern', :stored_searchable, type: :string), :label => 'Subtitle:' 
#     config.add_show_field solr_name('author', :stored_searchable, type: :string), :label => 'Author:' 
#     config.add_show_field solr_name('author_vern', :stored_searchable, type: :string), :label => 'Author:' 
#     config.add_show_field solr_name('format', :symbol), :label => 'Format:' 
#     config.add_show_field solr_name('url_fulltext_tsim', :stored_searchable, type: :string), :label => 'URL:'
#     config.add_show_field solr_name('url_suppl_tsim', :stored_searchable, type: :string), :label => 'More Information:'
#     config.add_show_field solr_name('language', :stored_searchable, type: :string), :label => 'Language:'
#     config.add_show_field solr_name('published', :stored_searchable, type: :string), :label => 'Published:'
#     config.add_show_field solr_name('published_vern', :stored_searchable, type: :string), :label => 'Published:'
#     config.add_show_field solr_name('lc_callnum', :stored_searchable, type: :string), :label => 'Call number:'
#     config.add_show_field solr_name('isbn', :stored_searchable, type: :string), :label => 'ISBN:'
# 
#     # "fielded" search configuration. Used by pulldown among other places.
#     # For supported keys in hash, see rdoc for Blacklight::SearchFields
#     #
#     # Search fields will inherit the :qt solr request handler from
#     # config[:default_solr_parameters], OR can specify a different one
#     # with a :qt key/value. Below examples inherit, except for subject
#     # that specifies the same :qt as default for our own internal
#     # testing purposes.
#     #
#     # The :key is what will be used to identify this BL search field internally,
#     # as well as in URLs -- so changing it after deployment may break bookmarked
#     # urls.  A display label will be automatically calculated from the :key,
#     # or can be specified manually to be different. 
# 
#     # This one uses all the defaults set by the solr request handler. Which
#     # solr request handler? The one set in config[:default_solr_parameters][:qt],
#     # since we aren't specifying it otherwise. 
#     
    config.add_search_field 'all_fields', :label => 'All Fields'
#     
# 
#     # Now we see how to over-ride Solr request handler defaults, in this
#     # case for a BL "search field", which is really a dismax aggregate
#     # of Solr search fields. 
#     
#     config.add_search_field('title') do |field|
#       # solr_parameters hash are sent to Solr as ordinary url query params. 
#       field.solr_parameters = { :'spellcheck.dictionary' => 'title' }
# 
#       # :solr_local_parameters will be sent using Solr LocalParams
#       # syntax, as eg {! qf=$title_qf }. This is neccesary to use
#       # Solr parameter de-referencing like $title_qf.
#       # See: http://wiki.apache.org/solr/LocalParams
#       field.solr_local_parameters = { 
#         :qf => '$title_qf',
#         :pf => '$title_pf'
#       }
#     end
#     
#     config.add_search_field('author') do |field|
#       field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
#       field.solr_local_parameters = { 
#         :qf => '$author_qf',
#         :pf => '$author_pf'
#       }
#     end
#     
#     # Specifying a :qt only to show it's possible, and so our internal automated
#     # tests can test it. In this case it's the same as 
#     # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
#     config.add_search_field('subject') do |field|
#       field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
#       field.qt = 'search'
#       field.solr_local_parameters = { 
#         :qf => '$subject_qf',
#         :pf => '$subject_pf'
#       }
#     end
      config.more_like_this = {
        :qt => 'mlt',
        :'mlt.fl' => "title_tesim, summary_tesim",
        :'mlt.mintf' => 1,
        :'mlt.mindf' => 1,
        :'mlt.match.include' => false,
        :'mlt.count' => 3,
        :'mlt.maxqt' => 50
      }
# 
#     # "sort results by" select (pulldown)
#     # label in pulldown is followed by the name of the SOLR field to sort by and
#     # whether the sort is ascending or descending (it must be asc or desc
#     # except in the relevancy case).
      config.add_sort_field 'score desc', :label => 'relevance'
      config.add_sort_field 'title_ssm asc, asset_date_ssm desc', :label => 'title'
      config.add_sort_field 'asset_date_ssm desc, title_ssm asc', :label => 'year'
# 
#     # If there are more than this many search results, no spelling ("did you 
#     # mean") suggestion is offered.
      config.spell_max = 5

  end
  
  def index
    delete_or_assign_search_session_params

    @search_context = 'result' if view_context.has_search_parameters?
    # extra_head_content << view_context.auto_discovery_link_tag(:rss, url_for(params.merge(:format => 'rss')), :title => "RSS for results")
    # extra_head_content << view_context.auto_discovery_link_tag(:atom, url_for(params.merge(:format => 'atom')), :title => "Atom for results")
    # extra_head_content << view_context.auto_discovery_link_tag(:unapi, unapi_url, {:type => 'application/xml',  :rel => 'unapi-server', :title => 'unAPI' })
    (@response, @document_list) = get_search_results
    @filters = params[:f] || []
    search_session[:total] = @response.total unless @response.nil?
    respond_to do |format|
      format.html { 
        render 'no_results_found' and return if @document_list.empty?
        save_current_search_params 
      }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
      format.json { render :json => @document_list }
    end
  end
  
  # get single document from the solr index
  def show
    # extra_head_content << view_context.auto_discovery_link_tag(:unapi, unapi_url, {:type => 'application/xml',  :rel => 'unapi-server', :title => 'unAPI' })
    @response, @document = get_solr_document_by_slug(params[:id])    
    #@repspones, @document = get_solr_response_for_doc_id
    
    @rel = get_related_content(params[:id])
    
    redirect_to(collection_url(params[:id])) and return if @document.get(:format) == 'collection' and params[:controller] == 'catalog'
    
    if current_user #or stale?(:last_modified => @document['system_modified_dtsi'])
      respond_to do |format|
        format.html {setup_next_and_previous_documents}
        format.jpg { send_data File.read(@document.thumbnail.path(params)), :type => 'image/jpeg', :disposition => 'inline' }
    
        # Add all dynamically added (such as by document extensions)
        # export formats.
        @document.export_formats.each_key do | format_name |
          # It's important that the argument to send be a symbol;
          # if it's a string, it makes Rails unhappy for unclear reasons. 
          format.send(format_name.to_sym) { render :text => @document.export_as(format_name), :layout => false }
        end
      end
    end
  end
  
  def home
    # pids = open(File.join(Rails.root, 'config', 'home.csv')).read.split(",").map(&:strip)
    # response, @document_list = get_solr_response_for_field_values("pid_s",pids, :rows => 90, :fl => 'id,pid_s,title_display', :sort => 'random_1234 desc')
    # @sprite = Sprite.new(:home_mosaic, @document_list)
    # @sprite.generate! true

    # if current_user or stale?(:last_modified => Time.new.beginning_of_week, :etag => pids)
    #   render :layout => 'home'
    # end
    @collections = Collection.where(:display_in_carousel => true).order('position ASC')
    @custom_collections = CustomCollection.limit(6).order('created_at ASC')
    @scholars = User.scholars
    @tweets = Twitter.user_timeline('wgbharchives', :count => 5)
    @mosaic_items = MosaicItem.find(:all, :limit => Rails.application.config.mosaic_size)
    #render :layout => 'home'
  end

  def print
    @response, @document = get_solr_response_for_doc_id    
    respond_to do |format|
      format.html {setup_next_and_previous_documents}
    end
  end

  def embed
    @response, @document = get_solr_response_for_doc_id    
    @width = params[:width].try(:to_i) || 640
    @height = params[:height].try(:to_i) || (3 * @width / 4)
    respond_to do |format|
      format.html {render :layout => 'embed' }
      
      # Add all dynamically added (such as by document extensions)
      # export formats.
      @document.export_formats.each_key do | format_name |
        # It's important that the argument to send be a symbol;
        # if it's a string, it makes Rails unhappy for unclear reasons. 
        format.send(format_name.to_sym) { render :text => @document.export_as(format_name) }
      end
      
    end
  end

  def cite
    @response, @document = get_solr_response_for_doc_id    
    respond_to do |format|
      format.html {render :layout => 'blank'}
    end
  end
  
  # when a request for /catalog/BAD_SOLR_ID is made, this method is executed...
  # def invalid_solr_id_error
  #   response, documents = get_solr_response_for_field_values("pid_s",params[:id])
  #   redirect_to url_for(:id => documents.first.id), :status=>301 and return if documents.length > 0
  # 
  #   response, documents = get_solr_response_for_field_values("pid_short_s",params[:id])
  #   redirect_to url_for(:id => documents.first.id), :status=>301 and return if documents.length > 0
  # 
  #   if Rails.env == "development"
  #     render # will give us the stack trace
  #   else
  #   #  flash[:notice] = "Sorry, you have requested a record that doesn't exist."
  #   #  redirect_to root_path, :status => 404
  #     render(:file => "#{Rails.root}/public/404.html", :layout => false, :status => 404)
  #   end
  #   
  # end

  def image
    @response, @document = get_solr_response_for_doc_id    
    style = params[:style] || 'preview'
    redirect_to @document.thumbnail.url(:style => style.to_sym) and return
  end
  
  def get_related_content(slug=nil)
    q = "slug:#{slug}"
    solr_params = { 
      :q => q,
      :'mlt.count' => 3,
      :mlt => true,
      :'mlt.fl' => "title_tesim, summary_tesim",
    }
    #response = find('mlt', self.solr_search_params().merge(solr_params))
    response = Blacklight.solr.select :params => solr_params
    id = response['response']['docs'][0]['id']
    document_list = response['moreLikeThis'][id]['docs'].collect{|doc| SolrDocument.new(doc, response) }
    document_list
  end
  
  def get_solr_document_by_slug(slug=nil)
    q = "slug:#{slug}"
    solr_params = {
      :defType => "edismax",   # need boolean for OR
      :q => q,
      :fl => "*",  
      :facet => 'false',
      :spellcheck => 'false',
      :mlt => 'true',
      :'mlt.fl' => "title_ssm, summary_ssm",
      :'mlt.count' => 3
    }

    solr_response = find('document', self.solr_search_params().merge(solr_params) )
    document_list = solr_response.docs.collect{|doc| SolrDocument.new(doc, solr_response) }
    [solr_response, document_list.first]
  end

end 
