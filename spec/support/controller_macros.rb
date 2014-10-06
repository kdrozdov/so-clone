module ControllerHelper
	def sign_in_user
		before do
			@user = create(:user)
			@request.env["devise.mapping"] = Devise.mappings[:user]
			sign_in @user
		end
	end

	def sign_in_question_author
		before do
			@user = create(:user)
			@question = create(:question, author: @user)
			@request.env["devise.mapping"] = Devise.mappings[:user]
			sign_in @user
		end
	end
end