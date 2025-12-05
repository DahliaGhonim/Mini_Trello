class UsersController < ApplicationController
  before_action :authenticate_user!

  def cards_count
    user = User.find(params[:id])
    count = user.cards.count
    render json: { count: count }
  end
end
