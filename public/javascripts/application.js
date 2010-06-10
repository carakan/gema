// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(function($) {

  var speed = 300,
     csfr_token = $('meta[name=csfr-token]').attr('content');

  // Mostrar ocultar detalle
  $('a.more').live("click", function() {
    $(this).html('Ver menos').removeClass('more').addClass('less').next('.hidden').show(speed);
  });
  $('a.less').live('click', function() {
    $(this).html('Ver mas').removeClass('less').addClass('more').next('.hidden').hide(speed);
  });

  // Para presentar formulario AJAX
  $('a.ajax').live("click", function() {
    // Crear formulario  llenarlo
  });


    // Date select, progressive enhancement
    $.datepicker._defaults.dateFormat = 'dd M yy';


    // Ocultar y crear a partir de un input text
    $('input.date').each(function(i, el) {
      var input = document.createElement('input');
      $(input).attr({'type': 'text', 'class': 'ui-date-text'});
      $(el).hide().after(input);
      var d = $.datepicker.parseDate('yy-mm-dd', $(el).val() );
      d = $.datepicker.formatDate($.datepicker._defaults.dateFormat, d);
      var id = '#' + el.id;

      $(input).datepicker({
        'altFormat': 'yy-mm-dd',
        'altField': id,
        'showOtherMonths': true, 
        'selectOtherMonths': true, 
        'buttonImage': '/images/icons/calendar.gif',
        'showOn': 'button',
        'buttonImageOnly': true
      });
      $(input).datepicker('setDate', d);
    });

      
    // Menu
    //$('ul.menu li');

    $('input.text-date').live('change', function() {
      var d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val() );
      $(this).prev('input').val( [ d.getFullYear(), (d.getMonth() + 1), d.getDate() ].join("-") );
    });

    /**
     * Sets the date for each select with the date selected with datepicker
     */
    $('input.ui-date-text').live('change', function() {
        var sels = $(this).siblings("select:lt(3)");
        var d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val() );
        
        $(sels[0]).val(d.getFullYear());
        $(sels[1]).val(d.getMonth() + 1);
        $(sels[2]).val(d.getDate());
    });
    
    /**
     * Replaces the date or datetime field with jquey-ui datepicker
     */
    $('.date, .datetime').each(function(i, el) {
        var input = document.createElement('input');
        $(input).attr({'type': 'text', 'class': 'ui-date-text'});
        // Insert the input:text before the first select
        $(el).find("select:first").before(input);
        $(el).find("select:lt(3)").hide();
        // Set the input with the value of the selects
        var values = [];
        $(input).siblings("select:lt(3)").each(function(i, el) {
            var val = $(el).val();
            if(val != '')
                values.push(val);
        });
        if( values.length > 1) {
            d = new Date(values[2], parseInt(values[1]) - 1, values[0] );
            $(input).val( $.datepicker.formatDate($.datepicker._defaults.dateFormat, d) );
        }

        $(input).datepicker({
          'showOtherMonths': true, 
          'selectOtherMonths': true, 
          'buttonImage': '/images/icons/calendar.gif',
          'showOn': 'button',
    			'buttonImageOnly': true
        }).attr('size', '14');
    });

});
