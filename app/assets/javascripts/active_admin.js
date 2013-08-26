//= require active_admin/base
//= require activeadmin-sortable
//= require bootstrap-wysihtml5
$(function() {
  $('.wysihtml5').each(function(i, elem) {
    $(elem).wysihtml5();
  });
});
