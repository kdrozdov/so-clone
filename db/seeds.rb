
100.times do
  user = {}
  user['username'] = Faker::Name.name.parameterize.underscore
  user['email'] = Faker::Internet.email(user['username'])
  user['password'] = '12345678'
  user['password_confirmation'] = '12345678'
  new_user = User.new(user)
  new_user.skip_confirmation!
  new_user.save!
end

users_count = User.count
50.times do
  user_id = rand(users_count) + 1
  user = User.find(user_id)
  user.questions.create(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph)
end