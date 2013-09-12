Blacklight.do_facet_expand_contract_behavior.selector = "#facets h3"
Blacklight.facet_expand_contract = ->
  $(this).next("ul, div").each ->
    f_content = $(this)
    $(f_content).prev("h5").addClass "twiddle twiddle-open"
  
    # attach the toggle behavior to the h3 tag
    $("h3", f_content.parent()).click ->
    
      # toggle the content
      $(this).toggleClass "twiddle-open"
      $(this).find('i').toggleClass ->
        if $(this).is(".icon-caret-down")
          "icon-caret-right"
        else
          "icon-caret-down"
      $(f_content).slideToggle()
$ ->
        
  $(".media_only input:checkbox").change ->
    $(this).parent().submit()
  
  $('#sort_form input').hide();
  $("#sort_form select").change ->
    $(this).parent().submit()
  
  $('#browse input').hide();
  $('#browse .categories select').bind 'change', ->
    $(this).closest('form').submit()
    
  $(" .collections select").bind 'change', (e) ->
    e.preventDefault()
    console.log $(this).val()
    window.location = '/collection/'+$(this).val()
    
  $('body').on "click", '.mobile-filters', (e) ->
    e.preventDefault()
    $('#sidebar').show()
  
  $('body').on "click", '.cancel-show', (e) ->
    e.preventDefault()
    $('#sidebar').hide()