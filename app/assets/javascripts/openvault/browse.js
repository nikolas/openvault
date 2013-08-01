$(function() {
  // $('.collections input').hide();
  // $('.categories input').hide();
  $('#browse input').hide();
   $('#browse select').bind('change', function() {
     $(this).closest('form').submit();
   });
});

