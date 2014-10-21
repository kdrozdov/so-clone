class Answer
  constructor: (@el) ->
    @answerBody = '.answer-body'
    @cancelEditLink = '.cancel-edit-link'
    @editLink = '.edit-answer-link'
    @deleteLink = '.delete-answer-link'
    @form = 'form.edit_answer'
    @formErrors = '.form-errors'
    @answersTitle = '.answers-title'

    this.binds()
    this.setAjaxHooks()
    this.setEventHandlers()

  updateTotalCount: () =>
    count = $('.answer').length
    str = 'Answers'
    str = 'Answer' if count == 1
    $(@answersTitle).html("#{count} #{str}")
      
  render: (container, data) ->
    data.user_id = $('body').data('userId')
    @el.html(HandlebarsTemplates['answers/show'](data))
    $(container).prepend(@el)

  binds: () ->
    self = this

    @el.on 'click', @cancelEditLink, (e) ->
      e.preventDefault()
      self.el.find(self.editLink).show()
      self.el.find(self.form).remove()

  setAjaxHooks: () ->
    self = this

    @el.on 'ajax:success', @editLink, (e, data, status, xhr) ->
      self.el.find(self.editLink).hide()
      self.el.append(HandlebarsTemplates['answers/form'](data.answer))

    @el.on 'ajax:error', @form, (e, xhr, status) ->
      formErrorsEl = self.el.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['answers/errors']({ errors: xhr.responseJSON }))

  setEventHandlers: () ->
    self = this

    @el.on 'answer:create', (e, data) ->
      self.render('.answers', data)
      self.updateTotalCount()

    @el.on 'answer:update', (e, data) ->
      data.user_id = $('body').data('userId')
      self.el.html(HandlebarsTemplates['answers/show'](data))

    @el.on 'answer:destroy', (e) ->
      self.el.remove()
      self.updateTotalCount()

$ ->

  questionId = $('.answers').data('questionId')

  PrivatePub.subscribe "/questions/#{questionId}/answers", (data, channel) ->
    if data.action is 'create'
      answerJSON = $.parseJSON(data['answer'])
      answerEl = createAnswerEl(answerJSON.id)
      answer = new Answer(answerEl)
      answerEl.trigger('answer:create', answerJSON)
    else if data.action is 'update'
      answerJSON = $.parseJSON(data['answer'])
      answerEl = getAnswerEl(answerJSON.id)
      answerEl.trigger('answer:update', answerJSON)
    else if data.action is 'destroy'
      answerId = data.answer_id
      answerEl = getAnswerEl(answerId)
      answerEl.trigger('answer:destroy')

  $('form.new_answer').on 'ajax:success', (e, data, status, xhr) ->
    clearForm($('form.new_answer'))
  .on 'ajax:error', (e, xhr, status) ->
    formErrorsEl = $('form.new_answer').find('.form-errors')
    formErrorsEl.html(HandlebarsTemplates['answers/errors']({ errors: xhr.responseJSON.errors }))

  $('.answers .answer').each((i, e) ->
    answer = new Answer($(e)))

  getAnswerEl  = (id) ->
    $('.answer[data-answer="' + id + '"]')

  createAnswerEl = (id) ->
    $('<div></div>').attr({class: 'answer panel', 'data-answer': id});

  clearForm = (form) ->
    form.find('.form-errors').html('')
    form.find('.form-attachments').find('.fields').remove()
    form.find('textarea').val('')