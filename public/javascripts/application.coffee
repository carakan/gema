$(document).ready(->
  # Velocidad en milisegundos
  speed = 300
  # csfr
  csfr_token = $('meta[name=csfr-token]').attr('content')
  # Date format
  $.datepicker._defaults.dateFormat = 'dd M yy'

  # Parsea la fecha con formato seleciando a un objeto Date
  parsearFecha = (fecha)->
    fecha = $.datepicker.parseDate($.datepicker._defaults.dateFormat, fecha )
    [ fecha.getFullYear(), fecha.getMonth() + 1, fecha.getDate() ]

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
  $('[alt]').live('mouseover mouseout', (e)->
    div = '#tooltip'
    if($(this).hasClass('error') )
      div = '#tooltip-error'
    
    if(e.type == 'mouseover') 
      pos = $(this).position()

      $(div).css(
        'top': (pos.top + 90) + 'px'
        'left': (e.clientX + 20) + 'px'
      ).html( $(this).attr('alt') )
      $(div).show()
    else
      $(div).hide()
    
  )

  # Para poder presentar mas o menos
  $('a.more').live("click", ->
    $(this).html('Ver menos').removeClass('more').addClass('less').next('.hidden').show(speed)
  )
  $('a.less').live('click', ->
    $(this).html('Ver mas').removeClass('less').addClass('more').next('.hidden').hide(speed)
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

  # Presentar formulario AJAX
  $('a.ajax').live("click", (e)->
    id = (new Date).getTime().toString()
    $(this).attr('data-ajax_id', id)
    div = document.createElement('div')
    $(div).attr( 'id', (new Date).getTime.toString() )
    .addClass('ajax-modal').css( { 'z-index': 1000 } ).attr('data-ajax_id', id)
    $(div).load( $(this).attr("href") )
    $(div).dialog({ 'width': 800, 'height' : 400, 'modal': true, 'resizable' : false })
    e.stopPropagation()
    false
  )

  # Hacer submit de un formulario AJAX
  $('div.ajax-modal form').live('submit', ->

    data = serializeFormElements(this)
    el = this

    $.ajax(
      'url': $(el).attr('action')
      # 'cache': false
      'context':el
      'data':data
      'type': (data['_method'] || 'post')
      'success': (resp)->
      'complete': (resp)->
        p = $(el).parents('div.ajax-modal')
        id = $(p).attr('data-ajax_id')
        $(p).dialog('destroy')
        $(p).remove()
        $('body').trigger('ajax:completed', [id])
      'error': (resp)->
        alert('Existen errores en su formulario por favor corrija los errores')
    )

    false
  )

  # Adicionar datepicker
  addDatePicker = ->
    $('input.date').each( (i, el)->
      if(!$(el).hasClass('hasDate'))

        input = document.createElement('input')

        $(input).attr({'type': 'text', 'class': 'ui-date-text'})
        $(el).addClass('hasDate hide').after(input)
        #$(el).hide().attr({'type': 'hidden'})

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


  # cambiar valores para datepiscker con sibling input:text
  $('input.date').live('change', ->
    d = parsearFecha( $(this).val() )
    $(this).prev('input').val( [ d[0], d[1], d[2] ].join("-") )
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
    val = val || 0
    $(selector).css({'background': 'rgb(255,255,'+val+')'})
    if(val >= 255)
      return false
    setTimeout(->
      val += 5
      mark(selector, velocity, val)
    , velocity)

  iniciar = ->
    transformarDateSelect()
    addDatePicker()

  iniciar()
)

getTarget = (e)->
  return e.target || e.srcElement

