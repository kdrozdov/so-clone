require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should be_able_to :me, User }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user), author: user }
    it { should be_able_to :destroy, create(:question, author: user), author: user }
    it { should_not be_able_to :update, create(:question, author: other), author: user }
    it { should_not be_able_to :destroy, create(:question, author: other), author: user }

    it { should be_able_to :update, create(:answer, author: user), author: user }
    it { should be_able_to :destroy, create(:answer, author: user), author: user }
    it { should_not be_able_to :update, create(:answer, author: other), author: user }
    it { should_not be_able_to :destroy, create(:answer, author: other), author: user }

    it { should be_able_to :update, create(:comment, author: user), author: user }
    it { should be_able_to :destroy, create(:comment, author: user), author: user }
    it { should_not be_able_to :update, create(:comment, author: other), author: user }
    it { should_not be_able_to :destroy, create(:comment, author: other), author: user }
  end

  describe 'for user with unconfirmed email' do
    let(:user) { create(:user, email: 'change@me-123456-twitter.com')}

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :create, Question }
    it { should_not be_able_to :create, Answer }
    it { should_not be_able_to :create, Comment }

    it { should_not be_able_to :update, create(:comment, author: user), author: user }
    it { should_not be_able_to :destroy, create(:comment, author: user), author: user }
    it { should_not be_able_to :update, create(:answer, author: user), author: user }
    it { should_not be_able_to :destroy, create(:answer, author: user), author: user }
    it { should_not be_able_to :update, create(:comment, author: user), author: user }
    it { should_not be_able_to :destroy, create(:comment, author: user), author: user }

    it { should be_able_to :finish_signup, User }
    it { should be_able_to :update_profile, User }
  end
end