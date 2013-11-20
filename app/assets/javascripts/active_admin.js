//= require active_admin/base
//= require bootstrap-wysihtml5
//= require active_admin_sortable
$(function() {
  $('.active_admin .wysihtml5').each(function(i, elem) {
    $(elem).wysihtml5();
  });
});
