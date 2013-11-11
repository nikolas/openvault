//= require active_admin/base
//= require activeadmin-sortable
//= require bootstrap-wysihtml5
$(function() {
  $('.active_admin .wysihtml5').each(function(i, elem) {
    $(elem).wysihtml5();
  });
});
