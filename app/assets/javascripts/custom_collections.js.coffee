# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  add_to_collection()
  remove_from_collection()  
  video_playlist()
  playlist_scroller()
  ccImageGal()
  pdfjs_tab_fix()
  $(".tabbable.responsive").resptabs();

add_to_collection = ->
  $('.add_to_collection a').on "click", (e) ->
    e.preventDefault()
    that = $(this)
    ccid = $(this).data('ccid')
    itemid = $(this).data('assetid')
    cctype = $(this).data('cctype')
    console.log ccid
    $.ajax
      url: '/custom_collections/'+ccid+'/add_item'
      dataType: 'json'
      data: {asset_id: itemid, kind: cctype}
      success: (data) ->
        that.text('added to your collection!')
      error: (data) ->
        console.log(data)
    
  $('.blacklight-custom_collections .wysihtml5').each (i, elem) ->
      $(elem).wysihtml5
        image: false
        
remove_from_collection = ->
  $('.blacklight-custom_collections .remove_item').on "click", (e) ->
    e.preventDefault()
    that = $(this)
    url = $(this).attr('href')
    $.ajax
      url: url
      dataType: 'json'
      success: (data) ->
        that.parent().remove()
      error: (data) ->
        alert('Sorry there was an error, please try again')

video_playlist = ->
  $('#cc_video_thumbnail_list .v_thumbnail img').on "click", (e) ->
    e.preventDefault()
    vid = $(this).parent().data('videourl')   
    title = $(this).attr('alt') 
    vid_obj = _V_("cc_player")
    #hide the current loaded poster
    $("img.vjs-poster").hide()
    vid_obj.ready ->
      # hide the video UI
      $("#cc_player_html5_api").hide()
      # and stop it from playing
      vid_obj.pause()
      # assign the targeted videos to the source nodes
      $("video:nth-child(1)").attr("src",vid)
      # replace the poster source
      # reset the UI states
      #$(".vjs-big-play-button").show()
      $("#cc_player").removeClass("vjs-playing").addClass("vjs-paused")
      $('#cc_video_player .video_title').html(title)
      # load the new sources
      vid_obj.load()
      $("#cc_player_html5_api").show()
      vid_obj.play()
 
playlist_scroller = ->  
  $("a.media-link[data-toggle=\"tab\"]").on "shown", (e) ->
    $('.jTscrollerPrevButton').hide()
    c = $('.jTscroller')
    cheight = $('.jTscroller').outerHeight(true)
    cpos = $('.jTscroller').position().top
    count = $('.jTscroller a').length
    paneCount = Math.ceil((count / 3))
    curPane = 1
    $('.jTscrollerNextButton').on "click", (e) ->
      e.preventDefault()
      paneh = ((cheight / count) * 3) * curPane
      console.log "Next Before: "+curPane
      c.animate({top: "-"+paneh})
      if (curPane + 1) == paneCount
        $(this).hide()
        curPane = curPane + 1
      else
        curPane = curPane + 1
      console.log "Next After: "+curPane
      if (curPane > 1)
        $('.jTscrollerPrevButton').show()
      else
        $('.jTscrollerPrevButton').hide()
    
    $('.jTscrollerPrevButton').on "click", (e) ->
      e.preventDefault()
      paneh = ((cheight / count) * 3)
      curPos = $('.jTscroller').position().top
      console.log "Prev Before: "+curPane
      c.animate({top: "-"+(Math.abs(curPos) - paneh)})
      if (curPane - 1) == 1
        $(this).hide()
        curPane = curPane - 1
      else
        curPane = curPane - 1
      console.log "Prev After: "+curPane
      if (curPane < paneCount)
        $('.jTscrollerNextButton').show()
      else
        $('.jTscrollerNextButton').hide()

ccImageGal = ->
  $("a.images-link[data-toggle=\"tab\"]").on "shown", (e) ->
      $('#carousel').flexslider
        animation: "slide",
        controlNav: false,
        animationLoop: false,
        slideshow: false,
        itemWidth: 150,
        itemMargin: 5,
        prevText: " ",
        nextText: " ",
        asNavFor: '#imageslider'
   
      $('#imageslider').flexslider
        animation: "slide",
        controlNav: false,
        animationLoop: false,
        slideshow: false,
        sync: "#carousel"

pdfjs_tab_fix = ->
  $('a.article-content-link[data-toggle="tab"]').on "shown", (e) ->
    filename = $('#article-content').data('article')
    PDFView.open(filename)
    PDFView.initialize()