class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_owner, only: %i[ new create ]
  before_action :set_card, only: %i[ edit update toggle_done move destroy ]


  def new
    @card = @owner.cards.new
  end

  def edit
  end

  def create
    @card = @owner.cards.new(card_params)
    @card.save

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    @card.update(card_params)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def toggle_done
    @card.update(done: !@card.done)
    head :ok
  end

  def move
    new_position = params[:position].to_i

    if params[:list_id]
      new_owner = List.find(params[:list_id])
    elsif params[:user_id]
      new_owner = User.find(params[:user_id])
    end

    @card.update(owner: new_owner, position: new_position + 1)
    @card.insert_at(new_position + 1)

    head :ok
  end

  def destroy
    @card.destroy!

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_owner
    @owner =
      if params[:list_id]
        List.find(params[:list_id])
      else
        current_user
      end
  end

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :owner_id)
  end
end
