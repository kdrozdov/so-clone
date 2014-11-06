class @Answer
  constructor: (@el) ->
    @id = @el.data('answer')
    @commentsEl = @el.find('.comments')
    @answerEl = @el.find('.answer')

    @cancelEditLink = '.cancel-edit-link'
    @editLink = '.edit-answer-link'
    @deleteLink = '.delete-answer-link'
    @form = 'form.edit_answer'
    @formErrors = '.form-errors'
    @answersTitle = '.answers-title'
    @addComment = '.add-comment'
    @cancelComment = '.cancel-comment'
    @newCommentForm = 'form.new_comment'

    this.binds()
    this.setAjaxHooks()

  updateTotalCount: () =>
    count = $('.answer').length
    str = 'Answers'
    str = 'Answer' if count == 1
    $(@answersTitle).html("#{count} #{str}")

  render: (data) ->
    data.user_id = $('body').data('userId')
    @answerEl.html(HandlebarsTemplates['answers/show'](data))

  binds: () ->
    self = this

    @commentsEl.on 'click', @addComment, (e) ->
      e.preventDefault()
      self.commentsEl.find(self.addComment).hide()
      self.commentsEl.append(HandlebarsTemplates['comments/new_form']({ id: self.id, parent: 'answer' }))

    @commentsEl.on 'click', @cancelComment, (e) ->
      e.preventDefault()
      self.commentsEl.find(self.addComment).show()
      self.commentsEl.find(self.newCommentForm).remove()

    @answerEl.on 'click', @cancelEditLink, (e) ->
      e.preventDefault()
      self.answerEl.find(self.editLink).show()
      self.answerEl.find(self.form).remove()

    @el.on 'answer:create', (e, data) ->
      self.render(data)
      self.updateTotalCount()

    @el.on 'answer:update', (e, data) ->
      self.render(data)

    @el.on 'answer:destroy', (e) ->
      self.el.remove()
      self.updateTotalCount()

  setAjaxHooks: () ->
    self = this

    @commentsEl.on 'ajax:success', @newCommentForm, (e, data, status, xhr) ->
      self.commentsEl.find(self.addComment).show()
      self.commentsEl.find(self.newCommentForm).remove()

    @commentsEl.on 'ajax:error', @newCommentForm, (e, xhr, status) ->
      formErrorsEl = self.commentsEl.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['shared/form_errors']({ errors: xhr.responseJSON.errors }))

    @answerEl.on 'ajax:success', @editLink, (e, data, status, xhr) ->
      self.answerEl.find(self.editLink).hide()
      self.answerEl.append(HandlebarsTemplates['answers/form'](data.answer))

    @answerEl.on 'ajax:error', @form, (e, xhr, status) ->
      formErrorsEl = self.el.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['answers/errors']({ errors: xhr.responseJSON }))    
