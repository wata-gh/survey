$ ->
  Survey.question = {}
  $(document).on 'click', '.ui.button.del-a', ->
    $(this).parents('.fields').remove()
  $(document).on 'click', '.ui.button.add-a', ->
    $(this).parents('.field').siblings('.add-a-pos').before($(a_s_h()).removeAttr('style'))

  $('#form').on 'submit', ->
    $(this).find('.ui.clearing.segment').each ->
      json = []
      $(this).find('div.fields:hidden,div.field:hidden').remove()
      $(this).find('.fields.single,.fields.multiple').each ->
        val = {}
        idx = 0
        $(this).find('input[type=text]').each ->
          if idx % 2 == 0
            val = {}
            val['value'] = $(this).val()
          else if idx % 2 == 1
            val['text'] = $(this).val()
            json.push val
          idx++
      $(this).find('input[type=hidden]').val(JSON.stringify(json))

  $('.ui.button.red.del').on 'click', ->
    sid = $(this).data 'sid'
    $ '.ui.basic.modal.del'
      .modal {
        closable: false,
        onApprove: ->
          hash_key = $('#hash_key').val()
          $('#destroy-form').submit()
          #location.href = "destroy?hash_key=#{hash_key}"
      }
      .modal 'show'
  q_h = Handlebars.compile($('#q-tmpl').html())
  a_s_h = Handlebars.compile($('#a-single-tmpl').html())
  a_m_h = Handlebars.compile($('#a-multiple-tmpl').html())
  Handlebars.registerPartial 'a-single', $('#a-single-tmpl').html()
  Handlebars.registerPartial 'a-multiple', $('#a-multiple-tmpl').html()

  Handlebars.registerHelper 'select', (v, o) ->
    $el = $('<select />').html(o.fn(this))
    $el.find('[value="' + v + '"]').attr {'selected': 'selected'}
    $el.html()

  Survey.question.add = (v) ->
    $('#add-q-pos').append(q_h v)
    $('select').dropdown()

  Survey.Edit = {}
  Survey.Edit.init = ->
    $(document).on 'change', 'select[name^=question]', ->
      s = $ this
      s.parents('.segment').find('.single,.multiple,.date,.free').hide()
      s.parents('.segment').find(".#{s.val()}").show()
  $('.add-q').on 'click', Survey.question.add
  $(document).on 'click', '.del-q', ->
    id = $(this).data 'id'
    $("#q-#{id}").fadeOut 200, ->
      $(this).remove()
