# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Verification of authorship' do
    let(:user) { create(:user) }
    let(:object_author) { create(:user) }
    let(:object) { create(:question, author: object_author) }

    it 'false when user is not an author of the object' do
      expect(user.author_of?(object)).to eq false
    end

    it 'true when user is an author of the object' do
      expect(object_author.author_of?(object)).to eq true
    end
  end
end
