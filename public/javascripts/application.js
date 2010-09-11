(function() {
  $(document).ready(function() {
    var addDatePicker, createDialog, csfr_token, getDataTitle, iniciar, mark, parsearFecha, roundVal, serializeFormElements, setFechaDateSelect, setIframePostEvents, speed, toByteSize, transformarDateSelect;
    speed = 300;
    csfr_token = $('meta[name=csfr-token]').attr('content');
    $.datepicker._defaults.dateFormat = 'dd M yy';
    parsearFecha = function(fecha, tipo) {
      var d;
      fecha = $.datepicker.parseDate($.datepicker._defaults.dateFormat, fecha);
      d = [fecha.getFullYear(), fecha.getMonth() + 1, fecha.getDate()];
      return 'string' === tipo ? d.join("-") : d;
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
      if ($(this).hasClass('error')) {
        div = '#tooltip-error';
      }
      if (e.type === 'mouseover') {
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
      return $(this).html('Ver más').removeClass('less').addClass('more').next('.hidden').hide(speed);
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
    getDataTitle = function(uri) {
      return /data-title=/.test(uri) ? uri.match(/^.*(data-title=)([^&]+).*$/)[2].replace(/\+/g, ' ') : '';
    };
    createDialog = function(params) {
      var div;
      params = $.extend({
        'id': new Date().getTime(),
        'title': '',
        'width': 800,
        'height': 400,
        'modal': true,
        'resizable': false
      }, params);
      div = document.createElement('div');
      $(div).attr({
        'id': params['id'],
        'title': params['title'],
        'data-ajax_id': params['id']
      }).addClass('ajax-modal').css({
        'z-index': 1000
      });
      delete (params['id']);
      delete (params['title']);
      $(div).dialog(params);
      return div;
    };
    $('a.ajax').live("click", function(e) {
      var div, id;
      id = new Date().getTime().toString();
      $(this).attr('data-ajax_id', id);
      div = createDialog({
        'title': $(this).attr('data-title')
      });
      $(div).load($(this).attr("href"), function(e) {
        return $(div).find('a.new[href*=/], a.edit[href*=/], a.list[href*=/]').hide();
      });
      e.stopPropagation();
      return false;
    });
    roundVal = function(val, dec) {
      dec = dec || 2;
      return Math.round(val * Math.pow(10, dec)) / Math.pow(10, dec);
    };
    $.roundVal = ($.fn.roundVal = roundVal);
    toByteSize = function(bytes) {
      if (true === (bytes < 1024)) {
        return bytes + " bytes";
      } else if (true === (bytes < Math.pow(1024, 2))) {
        return roundVal(bytes / Math.pow(1024, 1)) + " Kb";
      } else if (true === (bytes < Math.pow(1024, 3))) {
        return roundVal(bytes / Math.pow(1024, 2)) + " MB";
      } else if (true === (bytes < Math.pow(1024, 4))) {
        return roundVal(bytes / Math.pow(1024, 3)) + " GB";
      } else if (true === (bytes < Math.pow(1024, 5))) {
        return roundVal(bytes / Math.pow(1024, 4)) + " TB";
      } else if (true === (bytes < Math.pow(1024, 6))) {
        return roundVal(bytes / Math.pow(1024, 5)) + " PB";
      } else {
        return roundVal(bytes / Math.pow(1024, 6)) + " EB";
      }
    };
    $.toByteSize = ($.fn.toByteSize = toByteSize);
    setIframePostEvents = function(iframe, created) {
      return (iframe.onload = function() {
        var html, posts, postsSize;
        html = $(iframe).contents().find('body').html();
        if (($(html).find('form').length <= 0) && created) {
          $('#posts ul:first').prepend(html);
          mark('#posts ul li:first');
          posts = parseInt($('#posts ul:first>li').length);
          postsSize = parseInt($('#posts').attr("data-posts_size"));
          if (posts > postsSize) {
            $('#posts ul:first>li:last').remove();
          }
          return $('#create_post_dialog').dialog('close');
        } else {
          created = true;
          return $('#create_post_dialog').html(html);
        }
      });
    };
    $('a.post').live('click', function() {
      var div, iframe;
      if ($('iframe#post_iframe').length <= 0) {
        iframe = $('<iframe />').attr({
          'id': 'post_iframe',
          'name': 'post_iframe',
          'style': 'display:none;'
        })[0];
        $('body').append(iframe);
        setIframePostEvents(iframe, false);
        div = createDialog({
          'id': 'create_post_dialog',
          'title': 'Crear comentario'
        });
      } else {
        div = $('#create_post_dialog').dialog("open").html("");
      }
      $(div).load($(this).attr("href"));
      return false;
    });
    $('div.ajax-modal form[enctype!=multipart/form-data]').live('submit', function() {
      var data, el;
      data = serializeFormElements(this);
      el = this;
      $.ajax({
        'url': $(el).attr('action'),
        'cache': false,
        'context': el,
        'data': data,
        'type': (data['_method'] || $(this).attr('method')),
        'success': function(resp) {
          var id, p;
          if ($(resp).find('form').length <= 0) {
            p = $(el).parents('div.ajax-modal');
            id = $(p).attr('data-ajax_id');
            $(p).dialog('destroy');
            $(p).remove();
            return $('body').trigger('ajax:completed', [id, resp]);
          } else {
            return $(el).parents('div.ajax-modal:first').html(resp);
          }
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
        if (!$(el).hasClass('hasDate')) {
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
      return $(this).prev('input').val(parsearFecha($(this).val(), 'string'));
    });
    $('a.delete').live("click", function(e) {
      var el, url;
      $(this).parents("tr:first, li:first").addClass('marked');
      if (confirm('Esta seguro de borrar el item seleccionado')) {
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
    $.serializeFormElements = ($.fn.serializeFormElements = serializeFormElements);
    addDatePicker = function() {
      return $('input.date').each(function(i, el) {
        var d, id, input;
        if (!$(el).hasClass('hasDate')) {
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
      velocity = velocity || 7;
      $(selector).css({
        'background': 'rgb(255,255,' + val + ')'
      });
      if (val >= 255) {
        $(selector).attr("style", "");
        return false;
      }
      return setTimeout(function() {
        val += 5;
        return mark(selector, velocity, val);
      }, velocity);
    };
    $.mark = ($.fn.mark = mark);
    iniciar = function() {
      transformarDateSelect();
      return addDatePicker();
    };
    return iniciar();
  });
})();
