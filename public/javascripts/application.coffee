$(document).ready(->
  # Velocidad en milisegundos
  speed = 300
  # csfr
  csfr_token = $('meta[name=csfr-token]').attr('content')
  # Date format
  $.datepicker._defaults.dateFormat = 'dd M yy'
  # Parsea la fecha con formato seleciando a un objeto Date
  # @param String fecha
  # @param String tipo : Tipo de dato a devolver
  parsearFecha = (fecha, tipo)->
    fecha = $.datepicker.parseDate($.datepicker._defaults.dateFormat, fecha )
    d = [ fecha.getFullYear(), fecha.getMonth() + 1, fecha.getDate() ]
    if 'string' == tipo
      d.join("-")
    else
      d

  # Asignar la fecha a los elementos siblings del campo con datepicker
  # cuando los campos son select
  setFechaDateSelect = (el)->
    fecha = parsearFecha( $(el).val() )
    $(el).siblings('select[name*=1i]').val(fecha[0])
    $(el).siblings('select[name*=2i]').val(fecha[1])
    $(el).siblings('select[name*=3i]').val(fecha[2])

  # Transforma un campo dateselect de rails a uno de jQueryUI
  transformarDateSelect = ->
    $('li.date, div.date').each((i, el)->
      # Ocultar los campos
      input = document.createElement('input')
      $(input).attr({ 'class': 'date-transform', 'type': 'text'})
      year = $(el).find('select[name*=1i]').hide().val()
      month = parseInt( $(el).find('select[name*=2i]').hide().val() ) - 1
      day = $(el).find('select[name*=3i]').hide().after( input ).val()
      # Solo despues de haber adicionado al DOM hay que 
      # usar datepicker si se define el boton
      $(input).datepicker(
        'showOn': 'button',
        'buttonImage': '/images/icons/calendar.gif'
        'buttonImageOnly': true
      ).change((e)->
        setFechaDateSelect(this)
      )
      $(input).datepicker("setDate", new Date(year, month, day))
    )

  # Presenta un tooltip
  $('[tooltip]').live('mouseover mouseout', (e)->
    div = '#tooltip'
    if($(this).hasClass('error') )
      div = '#tooltip-error'

    if(e.type == 'mouseover')
      pos = $(this).position()

      $(div).css(
        'top': pos.top + 'px'
        'left': (e.clientX + 20) + 'px'
      ).html( $(this).attr('tooltip') )
      $(div).show()
    else
      $(div).hide()

  )

  # Para poder presentar mas o menos
  $('a.more').live("click", ->
    $(this).html('Ver menos').removeClass('more').addClass('less').next('.hidden').show(speed)
  )
  $('a.less').live('click', ->
    $(this).html('Ver más').removeClass('less').addClass('more').next('.hidden').hide(speed)
  )

  # Para presentar imagenes con tamaño original
  $('img.mini').live('click', ->
    lista = $(this).attr("src").split("/")
    l = lista.length - 1
    lista[l] = lista[l].replace(/^mini/, 'original')
    div = document.createElement('div')
    $(div).html(['<img', ' src=', '"', lista.join("/") , '"', " />"].join("") )

    $(div).dialog(
        'width': 700, 'height': 500
        'close': (e, ui)->
          $(div).dialog('destroy')
    )
  )

  # Retorna el titulo desde un uri
  # @param String uri
  getDataTitle = (uri)->
    if /data-title=/.test( uri )
      uri.match(/^.*(data-title=)([^&]+).*$/)[2].replace(/\+/g, ' ')
    else
      ''
  # Crea un dialogo y retorna el id con el que fue creado
  createDialog = (params)->
    params = $.extend({
      'id': new Date().getTime(), 'title': '', 'width': 800, 'height' : 400, 'modal': true, 'resizable' : false
    }, params)
    div = document.createElement('div')
    $(div).attr( { 'id': params['id'], 'title': params['title'], 'data-ajax_id': params['id'] } )
    .addClass('ajax-modal').css( { 'z-index': 1000 } )
    delete(params['id'])
    delete(params['title'])
    $(div).dialog( params )
    div

  #$.fn.createDialog = createDialog

  # Presentar formulario AJAX
  $('a.ajax').live("click", (e)->
    id = new Date().getTime().toString()
    $(this).attr('data-ajax_id', id)

    div = createDialog( { 'title': $(this).attr('data-title') } )
    $(div).load( $(this).attr("href"), (e)->
      $(div).find('a.new[href*=/], a.edit[href*=/], a.list[href*=/]').hide()
    )
    e.stopPropagation()
    false
  )

  # Para redondear decimales
  roundVal = (val, dec)->
  	dec = dec or 2
	  Math.round(val*Math.pow(10,dec))/Math.pow(10,dec)

  $.roundVal = $.fn.roundVal = roundVal

  # presenta en bytes la dimension
  toByteSize = (bytes)->
    switch true
      when bytes < 1024 then bytes + " bytes"
      when bytes < Math.pow(1024, 2) then roundVal( bytes/Math.pow(1024, 1) ) + " Kb"
      when bytes < Math.pow(1024, 3) then roundVal( bytes/Math.pow(1024, 2) ) + " MB"
      when bytes < Math.pow(1024, 4) then roundVal( bytes/Math.pow(1024, 3) ) + " GB"
      when bytes < Math.pow(1024, 5) then roundVal( bytes/Math.pow(1024, 4) ) + " TB"
      when bytes < Math.pow(1024, 6) then roundVal( bytes/Math.pow(1024, 5) ) + " PB"
      else
        roundVal( bytes/ Math.pow(1024, 6)) + " EB"

  $.toByteSize = $.fn.toByteSize = toByteSize

  #$.fn.nuevoPost = nuevoPost
  setIframePostEvents = (iframe, created)->
    iframe.onload = ->
      html = $(iframe).contents().find('body').html()
      if $(html).find('form').length <= 0 and created
        $('#posts ul:first').prepend(html)
        mark('#posts ul li:first')
        posts = parseInt($('#posts ul:first>li').length)
        postsSize = parseInt($('#posts').attr("data-posts_size") )
        if(posts > postsSize)
          $('#posts ul:first>li:last').remove()
        $('#create_post_dialog').dialog('close')
      else
        created = true
        $('#create_post_dialog').html(html)

  # Metodos para poder hacer submit de formularios
  $('a.post').live('click', ->
    if $('iframe#post_iframe').length <= 0
      iframe = $('<iframe />').attr({ 'id': 'post_iframe', 'name': 'post_iframe', 'style': 'display:none;' })[0]
      $('body').append(iframe)
      setIframePostEvents(iframe, false)
      div = createDialog({'id':'create_post_dialog', 'title': 'Crear comentario'})
    else
      div = $('#create_post_dialog').dialog("open").html("")

    $(div).load( $(this).attr("href") )

    false
  )


  # Hacer submit de un formulario AJAX que permite crear nuevos datos
  # Si al retornar no hay formulario significa que reenvia a una vista
  # y que la transaccion a sido completada
  $('div.ajax-modal form[enctype!=multipart/form-data]').live('submit', ->

    data = serializeFormElements(this)
    el = this

    $.ajax(
      'url': $(el).attr('action')
      'cache': false
      'context':el
      'data':data
      'type': (data['_method'] || $(this).attr('method') )
      'success': (resp, status, xhr)->
        if $(resp).find('input:submit').length <= 0
          p = $(el).parents('div.ajax-modal')
          id = $(p).attr('data-ajax_id')
          $(p).dialog('destroy')
          #$(p).remove()
          $('body').trigger('ajax:complete', [resp])
        else
          $(el).parents('div.ajax-modal:first').html(resp)
      'error': (resp)->
        alert('Existen errores en su formulario por favor corrija los errores')
    )

    false
  )


  # Adicionar datepicker a un elemento input
  addDatePicker = ->
    $('input.date').each( (i, el)->
      if(!$(el).hasClass('hasDate'))

        input = document.createElement('input')

        $(input).attr({'type': 'text', 'class': 'ui-date-text'})
        $(el).addClass('hasDate hide').after(input)

        id = '#' + el.id

        $(input).datepicker(
          'altFormat': 'yy-mm-dd'
          'altField': id
          'showOtherMonths': true
          'selectOtherMonths': true
          'buttonImage': '/images/icons/calendar.gif'
          'showOn': 'button'
          'buttonImageOnly': true
        )
        try
          d = $.datepicker.parseDate('yy-mm-dd', $(el).val() )
          d = $.datepicker.formatDate($.datepicker._defaults.dateFormat, d)
          $(input).datepicker('setDate', d)
        catch e
          e

    )
  #fin datePicker

  # Cambiar icono para more y less
  $('ul.menu>li').live('mouseover mouseout', (e)->
    $span = $(this).find('.more, .less')
    if(e.type == 'mouseover')
      $span.removeClass('more').addClass('less')
    else
      $span.removeClass('less').addClass('more')
  )

  # cambiar valores para datepiscker con sibling input:text
  $('input.date').live('change', ->
    $(this).prev('input').val( parsearFecha( $(this).val(), 'string' ) )
  )

  # Para borrar algum item
  $('a.delete').live("click", (e)->
    $(this).parents("tr:first, li:first").addClass('marked')
    if(confirm('Esta seguro de borrar el item seleccionado')) 
      url = $(this).attr('href')
      el = this

      $.ajax(
        'url': url
        'type': 'delete'
        'context': el
        'success': ->
          $(el).parents("tr:first, li:first").remove()
          $('body').trigger('ajax:delete', url)
        'error': ->
          alert('Existio un error al borrar')
      )

    else
      $(this).parents("tr:first, li:first").removeClass('marked')
      e.stopPropagation()

    return false
  )

  # Serializa los valores de un formulario para hacer AJAX requests
  serializeFormElements = (elem)->
    params = {}

    $(elem).find('input, select, textarea').each((i, el)->
      params[ $(el).attr('name') ] = $(el).val()
    )

    return params

  $.serializeFormElements = $.fn.serializeFormElements = serializeFormElements

  # Adiciona un datePicker a todos los elementos con clase date
  addDatePicker = ->
    $('input.date').each( (i, el)->
      if( !$(el).hasClass('hasDate') )

        input = document.createElement('input')

        $(input).attr({'type': 'text', 'class': 'ui-date-text'})
        $(el).addClass('hasDate hide').after(input)
        # $(el).hide().attr({'type': 'hidden'})

        id = '#' + el.id

        $(input).datepicker(
          'altFormat': 'yy-mm-dd'
          'altField': id
          'showOtherMonths': true
          'selectOtherMonths': true
          'buttonImage': '/images/icons/calendar.gif'
          'showOn': 'button'
          'buttonImageOnly': true
        )

        try
          d = $.datepicker.parseDate('yy-mm-dd', $(el).val() )
          d = $.datepicker.formatDate($.datepicker._defaults.dateFormat, d)
          $(input).datepicker('setDate', d)
        catch e
          e
    )


  # Mark
  # @param String // jQuery selector
  # @param Integer velocity
  mark = (selector, velocity, val)->
    val = val or 0
    velocity = velocity or 7
    $(selector).css({'background': 'rgb(255,255,'+val+')'})
    if(val >= 255)
      $(selector).attr("style", "")
      return false
    setTimeout(->
      val += 5
      mark(selector, velocity, val)
    , velocity)

  $.mark = $.fn.mark = mark

  iniciar = ->
    transformarDateSelect()
    addDatePicker()

  iniciar()
)
