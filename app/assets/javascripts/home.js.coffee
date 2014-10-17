$ ->
  $(window).scroll ->
    scrolled = $(window).scrollTop()
    if scrolled > 5
      $('#header').addClass('scrolled')
    else
      $('#header').removeClass('scrolled')
      
  $('body').on "click", '#mobile-header .action-menu', (e) ->
    e.preventDefault()
    $('#mobile-header .search-dropdown').hide()
    $('#mobile-header .action-dropdown-menu').slideToggle("fast")
    
  $('body').on "click", '#mobile-header .search-icon', (e) ->
    e.preventDefault()
    $('#mobile-header .action-dropdown-menu').hide()
    $('#mobile-header .search-dropdown').slideToggle("fast")
    
  $('body').on "click", ".sign_in_link", (e) ->
    if $('#signin-dropdown').length > 0
      e.preventDefault()
      $('#signin-dropdown').toggle("fast")
  
  $('body').on "click", ".cancel_signin", (e) ->
    e.preventDefault()
    $('#signin-dropdown .error').text('')
    $('#signin-dropdown').hide()
    
  $("form#new_session").bind "ajax:error", (event, request, settings) ->
    $('form#new_session .error').text(request.status == 500 ? 'Error' : request.responseText)

  $("form#new_session").bind "ajax:success", (evt, data, status, xhr) ->
    location.reload()
    
  $('body').on "click", '.more_meta', (e) ->
    e.preventDefault();
    $('.metadata .advanced').toggle()
    
  # collections_timer = null
#   $("#collections .document").hide().first().show()
#   $("#collections .document").each (i) ->
#     $("<a class=\"page\" href=\"#collections\">" + i + "</a>").bind("click", (e) ->
#       e.preventDefault()
#       $("#collections .document").hide().eq(i).show()
#       $(".page.active", "#collections").removeClass "active"
#       $(this).addClass "active"
#       startCollectionsTimer()
#     ).appendTo $("#collections .pagination")
# 
#   $("#collections .pagination .page").first().addClass "active"
#   $("<a href=\"#collections\" class=\"pause\">||</a>").bind("click", ->
#     window.clearTimeout collections_timer
#     $("#collections").addClass "paused"
#     $(this).hide()
#     $(".play", "#collections").show()
#     false
#   ).prependTo $("#collections .pagination")
#   $("<a href=\"#collections\" class=\"play\">&gt;</a>").bind("click", ->
#     $("#collections").removeClass "paused"
#     startCollectionsTimer()
#     $(this).hide()
#     $(".pause", "#collections").show()
#     false
#   ).hide().prependTo $("#collections .pagination")
#   
#   startCollectionsTimer = ->
#     window.clearTimeout collections_timer
#     collections_timer = window.setTimeout(->
#       next = $(".page.active", "#collections .pagination").next()
#       next = $(".page", "#collections .pagination").first()  if next.length is 0
#       next.click()
#     , 10000)
# 
#   $("#collections").bind "mouseenter", ->
#     window.clearTimeout collections_timer
# 
#   $("#collections").bind "mouseleave", ->
#     return  if $(this).is(".paused")
#     startCollectionsTimer()
# 
#   startCollectionsTimer()