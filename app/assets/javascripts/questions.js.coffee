# $ ->
  
  # currentAnswer = 0;
  # currentAnswerContainer = null

  # $(document).on 'click', '.edit-answer-link', (e) ->
  #   e.preventDefault()
  #   if self.currentAnswer > 0
  #     answerForm(self.currentAnswerContainer).hide()
  #     answerErrors(self.currentAnswerContainer).html('')
  #     editLink(self.currentAnswerContainer).show()
  #   $(this).hide()
  #   self.currentAnswer = $(this).data('answerId')
  #   self.currentAnswerContainer = answerContainer(self.currentAnswer)
  #   answerForm(self.currentAnswerContainer).show()

  # $(document).on 'click', '.cancel-edit-link', (e) ->
  #   e.preventDefault()
  #   answerForm(self.currentAnswerContainer).hide()
  #   answerErrors(self.currentAnswerContainer).html('')
  #   editLink(self.currentAnswerContainer).show()

  # answerContainer = (answerId) ->
  #   $('div[data-answer="' + answerId + '"]')

  # editLink = (container) ->
  #   container.find('.edit-answer-link')

  # answerForm = (container) ->
  #   container.find('.edit_answer')

  # answerErrors = (container) ->
  #   container.find('.form-errors')
