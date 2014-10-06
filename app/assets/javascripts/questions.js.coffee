$ ->
  current_answer = 0;

  $(document).on 'click', '.edit_answer_link', (e) ->
    e.preventDefault()
    if self.current_answer > 0 
      $("#answer_form_" + self.current_answer).hide()
      $('#answer_errors_' + self.current_answer).html('')
      $('.edit_answer_link').show()
    $(this).hide()
    self.current_answer = $(this).data('answerId')
    $("#answer_form_" + self.current_answer).show()

  $(document).on 'click', '.cancel_edit_link', (e) ->
    e.preventDefault()
    $("#answer_form_" + self.current_answer).hide()
    $('#answer_errors_' + self.current_answer).html('')
    $('.edit_answer_link').show()