# Users pages functions
$ ->
  showUserPasswordChange()
  newUserButtonClick()
  collectionTabs()
  
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