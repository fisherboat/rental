class Api::UsersController < Api::BaseController

  before_action :set_user, only: [:show]

  def create
    @user = User.new(user_params)
    if @user.save
      render :show
    else
      render json: { errors: formate_response_errors(@user.errors)}, status: 422
    end
  end

  def show
  end

  private
    def user_params
      params.permit(:name, :email)
    end

    def set_user
      @user = User.find(params[:id])
    end

end
