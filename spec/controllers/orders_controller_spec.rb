require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe '#create' do
    context 'with registered user' do
      let(:user) { create(:user) }
      let(:client) { create(:client) }

      before { login_user(user) }

      subject { post 'create', params: { order: attributes_for(:order, client_id: client.id) } }

      it 'saves the new order to database' do
        expect { subject }.to change(Order.all, :count).by(1)
      end

      it 'redirects to show view' do
        expect(subject).to redirect_to(Order.last)
      end

      it 'should respond with a success status code (2xx)' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#show' do
    let(:user) { create(:user) }
    let(:client) { create(:client) }
    let(:order) { create(:order) }

    before { login_user(user) }

    subject { get :show, params: { id: order.id } }

    it { is_expected.to render_template(:show) }
    it 'should respond with a success status code (2xx)' do
      expect(response).to have_http_status(:success)
    end
  end

  describe '#index' do
    let(:user) { create(:user) }
    let(:client) { create(:client) }
    let(:order) { create(:order) }

    before { login_user(user) }

    subject { get :index }

    it { is_expected.to render_template(:index) }
    it 'should respond with a success status code (2xx)' do
      expect(response).to have_http_status(:success)
    end
  end
end
