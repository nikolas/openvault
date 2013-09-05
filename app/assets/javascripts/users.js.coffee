# Users pages functions
$ ->
  # $('.wysihtml5bio').each (i, elem) ->
#       $(elem).wysihtml5()
  showUserPasswordChange()
  newUserButtonClick()
  
showUserPasswordChange = ->
  $('.change_password_edit_link').on "click", (e) ->
    e.preventDefault()
    $('#password_change_container').slideDown()
    $(this).remove()
    
newUserButtonClick = ->
  $('button.choose_avatar_btn').on "click", (e) ->
    e.preventDefault()
    $('#user_avatar').show().trigger("click").hide()