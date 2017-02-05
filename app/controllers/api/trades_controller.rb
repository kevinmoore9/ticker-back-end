class Api::TradesController < ApplicationController

  def create
    if "2" == trade_params[:user_id]
      if trade_params[:trade_type] == "BUY"
        current_user.buy_stock(trade_params[:ticker_sym],
                               trade_params[:volume])
      elsif trade_params[:trade_type] == "SELL"
        current_user.sell_stock(trade_params[:ticker_sym],
                               trade_params[:volume])
      else
        render json: { base: ['trade type must be specified'] }, status: 422
      end
    else
      render json: { base: ['Only logged in users can trade stocks']},
        status: 422
    end
  end

private
  def trade_params
    params.require(:trade).permit(:trade_type, :volume, :user_id, :ticker_sym)
  end
end
