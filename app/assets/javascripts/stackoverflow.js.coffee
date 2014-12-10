$ ->
  question = new Question($('.question'))

  $('.answers .answer-wrapper').each((i, e) ->
    answer = new Answer($(e)))

  $('.comments .comment-wrapper').each((i, e) ->
    comment = new Comment($(e)))

  PrivatePub.subscribe "/questions", (data, channel) ->
    if data.action is 'create'
      questionJSON = $.parseJSON(data['question'])
      questionEl = createQuestionEl(questionJSON.id)
      questionEl.html(HandlebarsTemplates['questions/show'](questionJSON))
      $('.questions').prepend(questionEl)
    else if data.action is 'update'
      questionJSON = $.parseJSON(data['question'])
      questionEl = getQuestionEl(questionJSON.id)
      questionEl.html(HandlebarsTemplates['questions/show'](questionJSON))
    else if data.action is 'destroy'
      questionId = data.question_id
      questionEl = getQuestionEl(questionId)
      questionEl.remove()

  createQuestionEl = (id) ->
    $('<li></li>').attr({class: 'question', 'data-question': id});

  getQuestionEl = (id) ->
    $('.question[data-question="' + id + '"]')