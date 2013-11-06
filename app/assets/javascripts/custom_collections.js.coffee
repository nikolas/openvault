# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
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
    
  $('.blacklight-custom_collections-edit .wysihtml5').each (i, elem) ->
      $(elem).wysihtml5()