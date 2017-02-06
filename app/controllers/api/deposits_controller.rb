class Api::DepositsController < ApplicationController

  def create
    @user = User.find_by(id: params[:id])
    @user.deposit_money(amount)
    render "api/users/show"
  end

  private

  def deposit_params
    params.require(:depsit).permit(:amount)
  end
end
