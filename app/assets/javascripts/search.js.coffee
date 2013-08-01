$ ->
  $(".media_only input:checkbox").change ->
    $(this).parent().submit()
  $("#sort_form select").change ->
    $(this).parent().submit()
  $('#browse input').hide();
  $('#browse select').bind 'change', ->
    $(this).closest('form').submit()