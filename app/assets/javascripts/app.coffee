$ ->
  $.ajaxPrefilter( (options, originalOptions, xhr) ->
    if !options.crossDomain
      token = $('meta[name="csrf-token"]').attr 'content'
      if token
        xhr.setRequestHeader 'X-CSRF-Token', token
  )
  $('select').dropdown()
  $('.ui.checkbox').checkbox()
  $('.ui.toggle.button').on 'click', ->
    b = $(this)
    b.addClass 'active'
      .siblings()
      .removeClass 'active'
    val = b.data 'val'
    value = b.parent().data 'value'
    b.parent().find('input[type=hidden]').val(val)

  $('.message .close').on 'click', ->
    $(this).closest('.message').transition 'fade'

  reg = false
  sid = null

  $('.ui.modal.reg').modal 'setting', {
    onHide: ->
      if reg
        h = $('#hash_key').val()
        h = "?hash_key=#{h}" if h != ''
        location.href = "#{location.href}survey/#{sid}/edit#{h}"
    onApprove: ->
      n = $('#name').val()
      s = false
      if $('#is_result_secret').prop('checked')
        s = true
      $.post 'survey', {surveys: {name: n, is_result_secret: s, hash_key: ''}}
        .done (r) ->
          if r.is_success != 1
            alert 'validate error'
            return
          reg = r.is_success == 1
          survey = r.results
          sid = survey.id
          if survey.is_result_secret
            $('#hash_key').val r.results.hash_key
          $ '.ui.modal'
            .modal 'hide'
      false
  }
  $('.new').on 'click', ->
    $('.ui.modal.reg').modal('show')

  $('.completed.step').on 'click', ->
    location.href = $(this).data('url')
