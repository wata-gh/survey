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
  hash = null

  $('.ui.modal.reg').modal 'setting', {
    onHide: ->
      return unless reg
      h = if hash then "?hash_key=#{hash}" else ''
      location.href = "#{location.href}survey/#{sid}/edit#{h}"
    onApprove: ->
      s = $('#is_result_secret').prop('checked')
      $.post 'survey', {surveys: {name: $('#name').val(), is_result_secret: s, hash_key: ''}}
        .done (r) ->
          return alert 'アンケートのタイトルを入れてください' if r.is_success != 1
          reg = true
          survey = r.results
          sid = survey.id
          hash = r.results.hash_key if survey.is_result_secret
          $('.ui.modal.reg').modal 'hide'
      false
  }
  $('.new').on 'click', ->
    $('.ui.modal.reg').modal 'show'

  $('.completed.step').on 'click', ->
    location.href = $(this).data 'url'
