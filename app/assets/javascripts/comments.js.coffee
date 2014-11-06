class @Comment
  constructor: (@el) ->
    @userId = $('body').data('userId')
    @commentEl = @el.find('.comment')

    @cancelEdit = '.cancel-edit'
    @editComment = '.edit-comment'
    @form = 'form.edit_comment'
    @formErrors = '.form-errors'

    this.binds()
    this.setAjaxHooks()
      
  render: (data) =>
    data.user_id = @userId
    @commentEl.html(HandlebarsTemplates['comments/show'](data))

  binds: () ->
    self = this

    @commentEl.on 'click', @cancelEdit, (e) ->
      e.preventDefault()
      self.commentEl.find(self.editComment).show()
      self.commentEl.find(self.form).remove()

    @el.on 'comment:create', (e, data) ->
      self.render(data)

    @el.on 'comment:update', (e, data) ->
      self.render(data)

    @el.on 'comment:destroy', (e) ->
      self.el.remove()

  setAjaxHooks: () ->
    self = this

    @commentEl.on 'ajax:success', @editComment, (e, data, status, xhr) ->
      self.commentEl.find(self.editComment).hide()
      self.commentEl.append(HandlebarsTemplates['comments/edit_form'](data.comment))

    @commentEl.on 'ajax:error', @form, (e, xhr, status) ->
      formErrorsEl = self.el.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['shared/errors']({ errors: xhr.responseJSON.errors }))
