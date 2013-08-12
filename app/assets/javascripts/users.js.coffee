# Users pages functions
$ ->
  # $('.wysihtml5bio').each (i, elem) ->
#       $(elem).wysihtml5()
  showUserPasswordChange()
  
showUserPasswordChange = ->
  $('.change_password_edit_link').on "click", (e) ->
    e.preventDefault()
    $('#password_change_container').slideDown()
    $(this).remove()