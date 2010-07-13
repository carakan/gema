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
   * Para presentar formulario AJAX
   */
  $('a.ajax').live("click", function(e) {
    var id = (new Date).getTime().toString();
    $(this).attr('data-ajax_id', id);
    var div = document.createElement('div');
    $(div).attr( 'id', (new Date).getTime.toString() ).addClass('ajax-modal').css( { 'z-index': 1000 } ).attr('data-ajax_id', id);
    $(div).load( $(this).attr("href") );
    $(div).dialog({ 'width': 800, 'height' : 400, 'modal': true, 'resizable' : false });

    e.stopPropagation();
    return false;
    // Crear formulario  llenarlo
  });

  /**
   * Hace submit de un formulario
   */
  $('div.ajax-modal form').live('submit', function() {

    var data = serializeFormElements(this);
    var el = this;

    $.ajax({
      'url': $(el).attr('action'),
//      'cache': false,
      'context':el,
      'data':data,
      'type': (data['_method'] || 'post'),
      'success': function(resp) {
      },
      'complete': function(resp) {
        var p = $(el).parents('div.ajax-modal');
        var id = $(p).attr('data-ajax_id');
        $(p).dialog('destroy');
        $(p).remove();
        $('body').trigger('ajax:completed', [id]);
      },
      'error': function(resp) {
        alert('Existen errores en su formulario por favor corrija los errores');
      }
    });

    return false;
  });

  /***************************/

  // Date select, progressive enhancement
  $.datepicker._defaults.dateFormat = 'dd M yy';

  

  $('input.text-date').live('change', function() {
    var d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val() );
    $(this).prev('input').val( [ d.getFullYear(), (d.getMonth() + 1), d.getDate() ].join("-") );
  });

  /*****************************/

  /**
   * Llama a todas las funciones que deben realizarse cuando se carga el DOM normalmente o AJAX
   */
  function callFunctions() {
    addDatePicker();
  }

  callFunctions();

  /* AJAX configuration*/

  $('body').ajaxComplete(function() {
    callFunctions();
  });


  $('a.delete').live("click", function(e) {
    $(this).parents("tr:first").addClass('marked');
    if(confirm('Esta seguro de borrar el item seleccionado')) {
      var url = $(this).attr('href');
      var el = this;

      $.ajax({
        'url': url,
        'type': 'delete',
        'context': el,
        'success': function() {
          $(el).parents("tr:first").remove();

          $('body').trigger('ajax:delete', url);
        },
        'error': function() {
          alert('Existio un error al borrar');
        }
      });

    }else{
      $(this).parents("tr:first").removeClass('marked');
      e.stopPropagation();
    }

    return false;
  });

  /****************/
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
/*jQuery*/
/*****************************************************************/

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
 * Adiciona un datePicker a todos los elementos con clase date
 */
function addDatePicker() {
  $('input.date').each(function(i, el) {
    if(!$(el).hasClass('hasDate')) {

      var input = document.createElement('input');

      $(input).attr({'type': 'text', 'class': 'ui-date-text'});
      $(el).addClass('hasDate hide').after(input);
 //     $(el).hide().attr({'type': 'hidden'});

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
      try{
        var d = $.datepicker.parseDate('yy-mm-dd', $(el).val() );
        d = $.datepicker.formatDate($.datepicker._defaults.dateFormat, d);
        $(input).datepicker('setDate', d);
      }catch(e) {}
    }
  });
}

/**
 * Mark
 * @param String // jQuery selector
 * @param Integer velocity
 */
function mark(selector, velocity, val) {
  val = val || 0;
  $(selector).css({'background': 'rgb(255,255,'+val+')'});
  if(val >= 255)
    return false;
  setTimeout(function() {
    val+=5;
    mark(selector, velocity, val);
  }, velocity);
}
