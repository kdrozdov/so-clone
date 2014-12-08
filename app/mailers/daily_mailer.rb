class DailyMailer < ActionMailer::Base
  default from: 'so-clone@dev.com'

  def digest(user, questions)
    @user = user
    @questions = questions

    mail to: user.email
  end
end
