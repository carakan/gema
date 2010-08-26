(function() {
  var getTarget;
  $(document).ready(function() {
    var addDatePicker, csfr_token, iniciar, mark, parsearFecha, serializeFormElements, setFechaDateSelect, speed, transformarDateSelect;
    speed = 300;
    csfr_token = $('meta[name=csfr-token]').attr('content');
    $.datepicker._defaults.dateFormat = 'dd M yy';
    parsearFecha = function(fecha) {
      fecha = $.datepicker.parseDate($.datepicker._defaults.dateFormat, fecha);
      return [fecha.getFullYear(), fecha.getMonth() + 1, fecha.getDate()];
    };
    setFechaDateSelect = function(el) {
      var fecha;
      fecha = parsearFecha($(el).val());
      $(el).siblings('select[name*=1i]').val(fecha[0]);
      $(el).siblings('select[name*=2i]').val(fecha[1]);
      return $(el).siblings('select[name*=3i]').val(fecha[2]);
    };
    transformarDateSelect = function() {
      return $('li.date, div.date').each(function(i, el) {
        var day, input, month, year;
        input = document.createElement('input');
        $(input).attr({
          'class': 'date-transform',
          'type': 'text'
        });
        year = $(el).find('select[name*=1i]').hide().val();
        month = parseInt($(el).find('select[name*=2i]').hide().val()) - 1;
        day = $(el).find('select[name*=3i]').hide().after(input).val();
        $(input).datepicker({
          'showOn': 'button',
          'buttonImage': '/images/icons/calendar.gif',
          'buttonImageOnly': true
        }).change(function(e) {
          return setFechaDateSelect(this);
        });
        return $(input).datepicker("setDate", new Date(year, month, day));
      });
    };
    $('[alt]').live('mouseover mouseout', function(e) {
      var div, pos;
      div = '#tooltip';
      if (($(this).hasClass('error'))) {
        div = '#tooltip-error';
      };
      if ((e.type === 'mouseover')) {
        pos = $(this).position();
        $(div).css({
          'top': pos.top + 'px',
          'left': (e.clientX + 20) + 'px'
        }).html($(this).attr('alt'));
        return $(div).show();
      } else {
        return $(div).hide();
      }
    });
    $('a.more').live("click", function() {
      return $(this).html('Ver menos').removeClass('more').addClass('less').next('.hidden').show(speed);
    });
    $('a.less').live('click', function() {
      return $(this).html('Ver mas').removeClass('less').addClass('more').next('.hidden').hide(speed);
    });
    $('img.mini').live('click', function() {
      var div, l, lista;
      lista = $(this).attr("src").split("/");
      l = lista.length - 1;
      lista[l] = lista[l].replace(/^mini/, 'original');
      div = document.createElement('div');
      $(div).html(['<img', ' src=', '"', lista.join("/"), '"', " />"].join(""));
      return $(div).dialog({
        'width': 700,
        'height': 500,
        'close': function(e, ui) {
          return $(div).dialog('destroy');
        }
      });
    });
    $('a.ajax').live("click", function(e) {
      var div, id;
      id = (new Date()).getTime().toString();
      $(this).attr('data-ajax_id', id);
      div = document.createElement('div');
      $(div).attr('id', (new Date()).getTime.toString()).addClass('ajax-modal').css({
        'z-index': 1000
      }).attr('data-ajax_id', id);
      $(div).load($(this).attr("href"));
      $(div).dialog({
        'width': 800,
        'height': 400,
        'modal': true,
        'resizable': false
      });
      e.stopPropagation();
      return false;
    });
    $('div.ajax-modal form').live('submit', function() {
      var data, el;
      data = serializeFormElements(this);
      el = this;
      $.ajax({
        'url': $(el).attr('action'),
        'context': el,
        'data': data,
        'type': (data['_method'] || 'post'),
        'success': function(resp) {},
        'complete': function(resp) {
          var id, p;
          p = $(el).parents('div.ajax-modal');
          id = $(p).attr('data-ajax_id');
          $(p).dialog('destroy');
          $(p).remove();
          return $('body').trigger('ajax:completed', [id]);
        },
        'error': function(resp) {
          return alert('Existen errores en su formulario por favor corrija los errores');
        }
      });
      return false;
    });
    addDatePicker = function() {
      return $('input.date').each(function(i, el) {
        var d, id, input;
        if ((!$(el).hasClass('hasDate'))) {
          input = document.createElement('input');
          $(input).attr({
            'type': 'text',
            'class': 'ui-date-text'
          });
          $(el).addClass('hasDate hide').after(input);
          id = '#' + el.id;
          $(input).datepicker({
            'altFormat': 'yy-mm-dd',
            'altField': id,
            'showOtherMonths': true,
            'selectOtherMonths': true,
            'buttonImage': '/images/icons/calendar.gif',
            'showOn': 'button',
            'buttonImageOnly': true
          });
          try {
            d = $.datepicker.parseDate('yy-mm-dd', $(el).val());
            d = $.datepicker.formatDate($.datepicker._defaults.dateFormat, d);
            return $(input).datepicker('setDate', d);
          } catch (e) {
            return e;
          }
        }
      });
    };
    $('ul.menu>li').live('mouseover mouseout', function(e) {
      var $span;
      $span = $(this).find('.more, .less');
      return (e.type === 'mouseover') ? $span.removeClass('more').addClass('less') : $span.removeClass('less').addClass('more');
    });
    $('input.date').live('change', function() {
      var d;
      d = parsearFecha($(this).val());
      return $(this).prev('input').val([d[0], d[1], d[2]].join("-"));
    });
    $('a.delete').live("click", function(e) {
      var el, url;
      $(this).parents("tr:first, li:first").addClass('marked');
      if ((confirm('Esta seguro de borrar el item seleccionado'))) {
        url = $(this).attr('href');
        el = this;
        $.ajax({
          'url': url,
          'type': 'delete',
          'context': el,
          'success': function() {
            $(el).parents("tr:first, li:first").remove();
            return $('body').trigger('ajax:delete', url);
          },
          'error': function() {
            return alert('Existio un error al borrar');
          }
        });
      } else {
        $(this).parents("tr:first, li:first").removeClass('marked');
        e.stopPropagation();
      }
      return false;
    });
    serializeFormElements = function(elem) {
      var params;
      params = {};
      $(elem).find('input, select, textarea').each(function(i, el) {
        return (params[$(el).attr('name')] = $(el).val());
      });
      return params;
    };
    addDatePicker = function() {
      return $('input.date').each(function(i, el) {
        var d, id, input;
        if ((!$(el).hasClass('hasDate'))) {
          input = document.createElement('input');
          $(input).attr({
            'type': 'text',
            'class': 'ui-date-text'
          });
          $(el).addClass('hasDate hide').after(input);
          id = '#' + el.id;
          $(input).datepicker({
            'altFormat': 'yy-mm-dd',
            'altField': id,
            'showOtherMonths': true,
            'selectOtherMonths': true,
            'buttonImage': '/images/icons/calendar.gif',
            'showOn': 'button',
            'buttonImageOnly': true
          });
          try {
            d = $.datepicker.parseDate('yy-mm-dd', $(el).val());
            d = $.datepicker.formatDate($.datepicker._defaults.dateFormat, d);
            return $(input).datepicker('setDate', d);
          } catch (e) {
            return e;
          }
        }
      });
    };
    mark = function(selector, velocity, val) {
      val = val || 0;
      $(selector).css({
        'background': 'rgb(255,255,' + val + ')'
      });
      if ((val >= 255)) {
        return false;
      }
      return setTimeout(function() {
        val += 5;
        return mark(selector, velocity, val);
      }, velocity);
    };
    iniciar = function() {
      transformarDateSelect();
      return addDatePicker();
    };
    return iniciar();
  });
  getTarget = function(e) {
    return e.target || e.srcElement;
  };
})();
