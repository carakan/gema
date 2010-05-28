// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {

  var speed = 300;
  // Mostrar ocultar detalle
  $('a.more').live("click", function() {
    $(this).html("Ver menos").removeClass('more').addClass('less').next('.hidden').show(speed);
  });
  $('a.less').live("click", function() {
    $(this).html("Ver mas").removeClass('less').addClass('more').next('.hidden').hide(speed);
  });

});
