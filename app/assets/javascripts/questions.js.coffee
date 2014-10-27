class @Question
  constructor: (@el) ->
    @newAnswerFormEl = $('form.new_answer')
    @commentsEl = @el.find('.comments')
    @questionId = $('.answers').data('questionId')

    @newCommentForm = 'form.new_comment'
    @addComment = '.add-comment'
    @cancelComment = '.cancel-comment'
    @formErrors = '.form-errors'
    
    this.binds()
    this.setAjaxHooks()
    this.subscribeToChannel(@questionId)

  binds: () ->
    self = this

    @commentsEl.on 'click', @addComment, (e) ->
      e.preventDefault()
      self.commentsEl.find(self.addComment).hide()
      self.commentsEl.append(HandlebarsTemplates['comments/new_form']({ id: self.questionId, parent: 'question' }))

    @commentsEl.on 'click', @cancelComment, (e) ->
      e.preventDefault()
      self.commentsEl.find(self.addComment).show()
      self.commentsEl.find(self.newCommentForm).remove()

  setAjaxHooks: () ->
    self = this

    @commentsEl.on 'ajax:success', @newCommentForm, (e, data, status, xhr) ->
      self.commentsEl.find(self.addComment).show()
      self.commentsEl.find(self.newCommentForm).remove()

    @commentsEl.on 'ajax:error', @newCommentForm, (e, xhr, status) ->
      formErrorsEl = self.commentsEl.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['shared/form_errors']({ errors: xhr.responseJSON.errors }))

    @newAnswerFormEl.on 'ajax:success', (e, data, status, xhr) ->
      self.clearForm(self.newAnswerFormEl)

    @newAnswerFormEl.on 'ajax:error', (e, xhr, status) ->
      formErrorsEl = self.newAnswerFormEl.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['answers/errors']({ errors: xhr.responseJSON.errors }))

  subscribeToChannel: (id) ->
    self = this

    PrivatePub.subscribe "/questions/#{id}", (data, channel) ->
      if data.type is 'answer'
        switch data.action 
          when 'create' then self.createAnswer(data)
          when 'update' then self.updateAnswer(data)
          when 'destroy' then self.destroyAnswer(data.answer_id)
      else if data.type is 'comment'
        switch data.action
          when 'create' then self.createComment(data)
          when 'update' then self.updateComment(data)
          when 'destroy' then self.destroyComment(data.comment_id)

  createComment: (data) =>
    comment = $.parseJSON(data['comment'])
    commentEl = @createCommentEl(comment.id)
    parentEl = @getParentEl(comment.parent, comment.parent_id)
    c = new Comment(commentEl)
    commentEl.trigger('comment:create', [parentEl, comment])

  updateComment: (data) =>
    comment = $.parseJSON(data['comment'])
    commentEl = @getCommentEl(comment.id)
    commentEl.trigger('comment:update', comment)

  destroyComment: (id) =>
    commentEl = @getCommentEl(id)
    commentEl.trigger('comment:destroy')

  createAnswer: (data) =>
    answer = $.parseJSON(data['answer'])
    answerEl = @createAnswerEl(answer.id)
    a = new Answer(answerEl)
    answerEl.trigger('answer:create', answer)

  updateAnswer: (data) =>
    answer = $.parseJSON(data['answer'])
    answerEl = @getAnswerEl(answer.id)
    answerEl.trigger('answer:update', answer)

  destroyAnswer: (id) =>
    answerEl = @getAnswerEl(id)
    answerEl.trigger('answer:destroy')

  getParentEl: (type, id) =>
    switch type
      when 'question' then @el
      when 'answer' then @getAnswerEl(id)

  getAnswerEl: (id) ->
    $('.answer[data-answer="' + id + '"]') 

  getCommentEl: (id) ->
    $('.comment[data-comment="' + id + '"]')

  createAnswerEl: (id) ->
    $('<div></div>').attr({class: 'answer panel', 'data-answer': id})

  createCommentEl: (id) ->
    $('<div></div>').attr({class: 'comment', 'data-comment': id})

  clearForm: (form) ->
    form.find('.form-errors').html('')
    form.find('.form-attachments').find('.fields').remove()
    form.find('textarea').val('')
