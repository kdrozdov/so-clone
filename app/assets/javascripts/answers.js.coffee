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

  updateTotalCount: () =>
    count = $('.answer').length
    str = 'Answers'
    str = 'Answer' if count == 1
    $(@answersTitle).html("#{count} #{str}")
      
  render: (container, data) ->
    @el.html(HandlebarsTemplates['answers/show'](data))
    $(container).prepend(@el)
    this.updateTotalCount()

  binds: () ->
    self = this

    @el.on 'click', @cancelEditLink, (e) ->
      e.preventDefault()
      self.el.find(self.editLink).show()
      self.el.find(self.form).remove()

  setAjaxHooks: () ->
    self = this

    @el.on 'ajax:success', @deleteLink, (event, data, status, xhr) ->
      self.el.remove()
      self.updateTotalCount()

    @el.on 'ajax:success', @editLink, (e, data, status, xhr) ->
      self.el.find(self.editLink).hide()
      self.el.append(HandlebarsTemplates['answers/form'](data))

    @el.on 'ajax:success', @form, (e, data, status, xhr) ->
      self.el.html(HandlebarsTemplates['answers/show'](data))

    @el.on 'ajax:error', @form, (e, xhr, status) ->
      formErrorsEl = self.el.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['answers/errors']({ errors: xhr.responseJSON }))

$ ->
  $('form.new_answer').on 'ajax:success', (e, data, status, xhr) ->
    answer = new Answer(createAnswerEl(data.id))
    answer.render('.answers', data)
    clearForm($('form.new_answer'))
  .on 'ajax:error', (e, xhr, status, error) ->
    formErrorsEl = $('form.new_answer').find('.form-errors')
    formErrorsEl.html(HandlebarsTemplates['answers/errors']({ errors: xhr.responseJSON }))

  $('.answers .answer').each((i, e) ->
    answer = new Answer($(e)))

  createAnswerEl = (id) ->
    $('<div></div>').attr({class: 'answer panel', 'data-answer': id});

  clearForm = (form) ->
    form.find('.form-errors').html('')
    form.find('.form-attachments').find('.fields').remove()
    form.find('textarea').val('')