class Api::TradesController < ApplicationController

  def create
    if ['BUY', 'SELL'].include?(trade_params[:trade_type])
      @user = User.find_by(id: trade_params[:user_id])
      if trade_params[:trade_type] == "BUY"
        user.buy_stock(trade_params[:ticker_sym], trade_params[:volume])
      else # must be SELL
        user.sell_stock(trade_params[:ticker_sym], trade_params[:volume])
      end
      render "api/users/show"
    else
      render json: { base: ['invalid trade type'] }, status: 422
    end
  end

private
  def trade_params
    params.require(:trade).permit(:trade_type, :volume, :user_id, :ticker_sym)
  end
end
