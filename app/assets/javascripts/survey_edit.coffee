class @SurveyEdit
  constructor: ->
    @q_h = Handlebars.compile($('#q-tmpl').html())
    @a_s_h = Handlebars.compile($('#a-single-tmpl').html())
    @a_m_h = Handlebars.compile($('#a-multiple-tmpl').html())
    Handlebars.registerPartial 'a-single', $('#a-single-tmpl').html()
    Handlebars.registerPartial 'a-multiple', $('#a-multiple-tmpl').html()
    Handlebars.registerHelper 'select', (v, o) ->
      $el = $('<select />').html(o.fn(this))
      $el.find('[value="' + v + '"]').attr {'selected': 'selected'}
      $el.html()
    Handlebars.registerHelper 'select', (v, o) ->
      $el = $('<select />').html(o.fn(this))
      $el.find('[value="' + v + '"]').attr {'selected': 'selected'}
      $el.html()

  init: =>
    that = @
    $(document).on 'click', '.ui.button.del-a', ->
      $(@).parents('.fields').remove()
    $(document).on 'click', '.ui.button.add-a', ->
      $(this).parents('.field').siblings('.add-a-pos').before($(that.a_s_h()).removeAttr('style'))
    $('#form').on 'submit', ->
      $(@).find('.ui.clearing.segment').each ->
        json = []
        $(@).find('div.fields:hidden,div.field:hidden').remove()
        $(@).find('.fields.single,.fields.multiple').each ->
          val = {}
          idx = 0
          $(@).find('input[type=text]').each ->
            if idx % 2 == 0
              val = {}
              val['value'] = $(@).val()
            else if idx % 2 == 1
              val['text'] = $(@).val()
              json.push val
            idx++
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
      $("#q-#{id}").find('input[name="surveys[questions_attributes][][_destroy]"]').val('true')
      $("#q-#{id}").fadeOut 200

  show_delete_modal: ->
    sid = $(@).data 'sid'
    $ '.ui.basic.modal.del'
      .modal {
        closable: false,
        onApprove: ->
          hash_key = $('#hash_key').val()
          $('#destroy-form').submit()
          #location.href = "destroy?hash_key=#{hash_key}"
      }
      .modal 'show'

  add_question: (v) =>
    $('#add-q-pos').append(@q_h v)
    $('select').dropdown()
    $('select[name^="surveys[questions_attributes]"]', '#q-' + v.id).trigger('change', [true])
