class Api::DepositsController < ApplicationController

  def create
    @user = User.find_by(id: params[:user_id])
    @user.deposit_money(params[:user][:amount])
    render "api/users/show"
  end

  private

  def deposit_params
    params.require(:depsit).permit(:amount)
  end
end
