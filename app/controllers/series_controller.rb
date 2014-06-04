class SeriesController < CatalogController

  def browse_by_title
    @series_results = Blacklight.solr.select(params: {q: "has_model_ssim:*Series*", rows: 10000})['response']['docs']

    # You can sort using Solr, but it defaults to being case sensitive, and putting numbers before letters.
    # This custom sort puts letters before numbers and is case insensitive.
    @series_results.sort! do |a, b|
      cmp_a = (a['title_tesim'].nil? || a['title_tesim'].empty?) ? '' : a['title_tesim'].first
      cmp_b = (b['title_tesim'].nil? || b['title_tesim'].empty?) ? '' : b['title_tesim'].first

      case
      # push titles beginning with numbers to the end
      when (/^[0-9]/ =~ cmp_a) && !(/^[0-9]/ =~ cmp_b)
        1
      when !(/^[0-9]/ =~ cmp_a) && (/^[0-9]/ =~ cmp_b)
        -1
      else
        cmp_a.upcase <=> cmp_b.upcase
      end
    end

    respond_to do |format|
      format.html {render :browse_by_title}
    end
  end

  def show
    @response, @document = get_solr_response_for_doc_id params[:id]

    @series = Series.find params[:id]

    respond_to do |format|
      #format.html {setup_next_and_previous_documents}
      format.html #show.html.erb
      #format.jpg { send_data File.read(@document.thumbnail.path(params)), :type => 'image/jpeg', :disposition => 'inline' }

      # Add all dynamically added (such as by document extensions)
      # export formats.
      @document.export_formats.each_key do | format_name |
        # It's important that the argument to send be a symbol;
        # if it's a string, it makes Rails unhappy for unclear reasons.
        format.send(format_name.to_sym) { render :text => @document.export_as(format_name), :layout => false }
      end
    end
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

  protected
  def get_only_solr_document_by_slug(slug=nil)
    q = "slug:#{slug}"
    solr_params = {
      :defType => "edismax",   # need boolean for OR
      :q => q,
    }
    solr_response = find('document', self.solr_search_params().merge(solr_params) )
    document_list = solr_response.docs.collect{|doc| SolrDocument.new(doc, solr_response) }
    document_list.first
  end

  def get_programs(document=nil)
    progs = []

    unless document[:programs_ssm].nil?
      document[:programs_ssm].each do |prog_id|
        response, document = get_solr_response_for_doc_id prog_id
        progs << document
      end
    end
    progs
  end

  def get_videos(document=nil)
    vids = []
    unless document[:videos_ssm].nil?
      document[:videos_ssm].each do |vid_id|
        response, document = get_solr_response_for_doc_id vid_id
        vids << document
      end
    end
    vids
  end

  def get_images(document=nil)
    imgs = []
    unless document[:images_ssm].nil?
      document[:images_ssm].each do |img|
        imgs << get_only_solr_document_by_slug(img.to_s)
      end
    end
    imgs
  end
end
