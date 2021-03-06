require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  describe '#update' do
    context 'with new user' do
      let(:current_password) { generate :aml_password }
      let(:operator) { create :aml_operator, :administrator }
      let(:user) { create :user, aml_operator: operator }

      before { login_user user }

      it 'создание пароля после регистрации пользователя' do
        put 'update', params: { user: { password: current_password,
                                        password_confirmation: current_password },
                                id: user.reset_password_token }
        expect(User.authenticate(user.email, current_password)).to eq(user)
        expect(response).to be_redirect
      end
    end
  end
end
