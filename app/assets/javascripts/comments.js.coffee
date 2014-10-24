class @Comment
  constructor: (@el) ->
    @userId = $('body').data('userId')
    @wrapper = '.comments'
    @cancelEdit = '.cancel-edit'
    @editComment = '.edit-comment'
    @form = 'form.edit_comment'
    @formErrors = '.form-errors'

    this.binds()
    this.setAjaxHooks()
      
  render: (parent, data) =>
    data.user_id = @userId
    @el.html(HandlebarsTemplates['comments/show'](data))
    parent.find(@wrapper).prepend(@el)

  binds: () ->
    self = this

    @el.on 'click', @cancelEdit, (e) ->
      e.preventDefault()
      self.el.find(self.editComment).show()
      self.el.find(self.form).remove()

    @el.on 'comment:create', (e, parent, data) ->
      self.render(parent, data)

    @el.on 'comment:update', (e, data) ->
      data.user_id = self.userId
      self.el.html(HandlebarsTemplates['comments/show'](data))

    @el.on 'comment:destroy', (e) ->
      self.el.remove()

  setAjaxHooks: () ->
    self = this

    @el.on 'ajax:success', @editComment, (e, data, status, xhr) ->
      console.log('editComment')
      self.el.find(self.editComment).hide()
      self.el.append(HandlebarsTemplates['comments/edit_form'](data))

    @el.on 'ajax:error', @form, (e, xhr, status) ->
      formErrorsEl = self.el.find(self.formErrors)
      formErrorsEl.html(HandlebarsTemplates['shared/errors']({ errors: xhr.responseJSON.errors }))
