$ ->
  currentAnswer = 0;

  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    if self.currentAnswer > 0 
      answerForm(self.currentAnswer).hide()
      answerErrors(self.currentAnswer).html('')
      editLink(self.currentAnswer).show()
    $(this).hide()
    self.currentAnswer = $(this).data('answerId')
    answerForm(self.currentAnswer).show()

  $(document).on 'click', '.cancel-edit-link', (e) ->
    e.preventDefault()
    answerForm(self.currentAnswer).hide()
    answerErrors(self.currentAnswer).html('')
    editLink(self.currentAnswer).show()

  editLink = (answerId) ->
    $('.edit-answer-link[data-answer-id="' + answerId + '"]')

  answerForm = (answerId) ->
    $("#edit-answer-" + answerId)

  answerErrors = (answerId) ->
    $('#answer-errors-' + answerId)
