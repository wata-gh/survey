class @SurveyEdit
  constructor: ->
    Handlebars.registerHelper 'select', (v, o) ->
      $el = $('<select />').html(o.fn(this))
      $el.find('[value="' + v + '"]').attr {'selected': 'selected'}
      $el.html()
    Handlebars.registerHelper 'resize_image_url', (url, opt) ->
      return '' if url == null
      url.replace(':dw', opt.hash.dw).replace(':dh', opt.hash.dh)

  init: =>
    that = @
    $(document).on 'click', '.ui.button.del-a', ->
      $(@).parents('.fields').remove()
    $(document).on 'click', '.ui.button.add-a', ->
      $(this).parents('.field').siblings('.add-a-pos').before($(JST['survey/single']()).removeAttr('style'))
    $('#form').on 'submit', ->
      $(@).find('.ui.clearing.segment').each ->
        $(@).find('div.fields:hidden,div.field:hidden').remove()
        json = $.map $(@).find('.fields.single,.fields.multiple').find('input[type=text]'), (v, idx) ->
          {value: "" + (idx + 1), text: $(v).val()}
        $(@).find('input[type=hidden][name="surveys[questions_attributes][][value]"]').val(JSON.stringify(json))
    $('.small-del-button.del').on 'touchend', @show_delete_modal
    $('.ui.button.red.del').on 'click', @show_delete_modal
    $(document).on 'change', 'select[name^="surveys[questions_attributes]"]', ->
      s = $ @
      s.parents('.question.segment').find('.single,.multiple,.date,.free').hide()
      s.parents('.question.segment').find(".#{s.val()}").show()
    $('.add-q').on 'click', @add_question
    $(document).on 'click', '.del-q', ->
      id = $(@).data 'id'
      if id
        $("#q-#{id}").find('input[name="surveys[questions_attributes][][_destroy]"]').val('true')
        $("#q-#{id}").fadeOut 200
      else
        $(@).parents('.question').fadeOut 200, ->
          $(@).remove()
    $(document).on 'click', '.del-qi', ->
      $(@).parents('.question-image').transition('jiggle').transition('scale')
        .parent().find('input[name="surveys[questions_attributes][][remove_image]"]').val(true)
    $('.survey-image').dimmer {on: 'hover'}
    $(document).on 'click', '.del-i', ->
      $(@).parents('.survey-image').transition('jiggle').transition('scale')
        .parent().find('input[name="surveys[remove_image]"]').val(true)

  show_delete_modal: ->
    sid = $(@).data 'sid'
    $ '.ui.basic.modal.del'
      .modal {
        closable: false,
        onApprove: ->
          hash_key = $('#hash_key').val()
          $('#destroy-form').submit()
      }
      .modal 'show'

  add_question: (v) =>
    $('#add-q-pos').append(JST['survey/question'] v)
    $('select').dropdown()
    $('select[name^="surveys[questions_attributes]"]', '#q-' + v.id).trigger('change', [true])
    $('.question-image', '#q-' + v.id).dimmer {on: 'hover'}
