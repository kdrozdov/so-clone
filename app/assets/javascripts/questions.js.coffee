$ ->
  PrivatePub.subscribe "/questions", (data, channel) ->
    if data.action is 'create'
      questionJSON = $.parseJSON(data['question'])
      questionEl = createQuestionEl(questionJSON.id)
      questionEl.html(HandlebarsTemplates['questions/show'](questionJSON))
      $('.questions').append(questionEl)
    else if data.action is 'update'
      console.log(data)
      questionJSON = $.parseJSON(data['question'])
      questionEl = getQuestionEl(questionJSON.id)
      questionEl.html(HandlebarsTemplates['questions/show'](questionJSON))
    else if data.action is 'destroy'
      questionId = data.question_id
      questionEl = getQuestionEl(questionId)
      questionEl.remove()

  createQuestionEl = (id) ->
    $('<li></li>').attr({class: 'answer panel', 'data-question': id});

  getQuestionEl = (id) ->
    $('.question[data-question="' + id + '"]')
