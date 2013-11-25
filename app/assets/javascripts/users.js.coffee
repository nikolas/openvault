# Users pages functions
$ ->
  showUserPasswordChange()
  newUserButtonClick()
  collectionTabs()
  moreBioLink()
  
showUserPasswordChange = ->
  $('.change_password_edit_link').on "click", (e) ->
    e.preventDefault()
    $('#password_change_container').slideDown()
    $(this).remove()
    
newUserButtonClick = ->
  $('button.choose_avatar_btn').on "click", (e) ->
    e.preventDefault()
    $('#user_avatar').show().trigger("click").hide()
    
collectionTabs = ->
  $('#collectionTabs a').on "click", (e) ->
    e.preventDefault()
    $(this).tab('show')
    
moreBioLink = ->
  $('body').on "click", '.more_bio_link', (e) ->
    e.preventDefault()
    $('p.short-bio').hide()
    $('p.long-bio').show()