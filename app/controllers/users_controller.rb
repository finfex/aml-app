class UsersController < ApplicationController
  include Pagination

  authorize_actions_for User

  def index
    render :index, locals: { users: paginate(User.ordered) }
  end

  def new
    render :new, locals: { user: User.new(permitted_params) }
  end

  def create
    ActiveRecord::Base.transaction do
      operator = AML::Operator.create!(name: permitted_params[:name], email: permitted_params[:email])
      User.create! permitted_params.merge!(aml_operator: operator)
    end
    redirect_to users_path, notice: "Пользователь #{permitted_params[:name]} создан."
  rescue ActiveRecord::RecordInvalid => e
    flash.now.alert = e.message
    render :edit, locals: { user: user }
  end

  def edit
    render :edit, locals: { user: user }
  end

  def update
    authorize_action_for user
    user.update! permitted_params
    redirect_to users_path, notice: "Пользователь #{permitted_params[:name]} изменен."
  rescue ActiveRecord::RecordInvalid => e
    flash.now.alert = e.message
    render :edit, locals: { user: e.record }
  end

  private

  def user
    @user ||= User.find params[:id]
  end

  def permitted_params
    params.fetch(:user, {}).permit(:email, :password, :password_confirmation, :name)
  end
end
