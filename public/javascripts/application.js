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

  /**
   * Serializa los datos de un formulario para hacer submit mediante AJAX
   */
  function serializeFormElements(elem) {
    var params = {};

    $(elem).find('input, select, textarea').each(function(i, el) {
      params[ $(el).attr('name') ] = $(el).val();
    });

    return params;
  }

  /**
   * Para presentar formulario AJAX
   */
  $('a.ajax').live("click", function(e) {
    var div = document.createElement('div');
    $(div).attr( 'id', 'prueba' ).addClass('ajax-modal').css( { 'z-index': 1000 } );
    $(div).load( $(this).attr("href") );
    $(div).dialog({ 'width': 800, 'height' : 400, 'modal': true, 'resizable' : false });

    e.stopPropagation();
    return false;
    // Crear formulario  llenarlo
  });

  $('div.ajax-modal form').live('submit', function() {

    var data = serializeFormElements(this);
    $.ajax({
      'url': $(this).attr('action') + '.json',
      'data':data,
      'type': data['_method'] || 'post',
      'success': function(resp, textStatus, xhr) {
        console.log("%o, %o, %o", resp, textStatus, xhr);
      },
      'failure': function() {
        alert('Existio un error por favor intente de nuevo');
      },
      'error': function() {
        console.log(arguments);
        var prin;
        for(k in json) {
          if( typeof(json[k]) == 'object' ){
            prin = k;
            break;            
          }
        }
        alert('Existen errores en su formulario por favor corrija los errores');
      }
    });

    return false;
  });

  /***************************/

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

  $('input.text-date').live('change', function() {
    var d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val() );
    $(this).prev('input').val( [ d.getFullYear(), (d.getMonth() + 1), d.getDate() ].join("-") );
  });

    /**
     * Sets the date for each select with the date selected with datepicker
     */
    /*
    $('input.ui-date-text').live('change', function() {
        var sels = $(this).siblings("select:lt(3)");
        var d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val() );
        
        $(sels[0]).val(d.getFullYear());
        $(sels[1]).val(d.getMonth() + 1);
        $(sels[2]).val(d.getDate());
    });
    */
    
    /**
     * Replaces the date or datetime field with jquey-ui datepicker
     */
    /*
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
    */
});
