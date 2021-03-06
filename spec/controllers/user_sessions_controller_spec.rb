require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  let(:operator) { create :aml_operator, :administrator }
  let(:user) { create :user, aml_operator: operator }

  before { login_user user }

  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { user_session: { params: { login: '', password: '' } } }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create, params: { user_session: { params: { login: user.email, password: user.password } } }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE #destroy' do
    it 'returns http success' do
      login_user(user)
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end
end
