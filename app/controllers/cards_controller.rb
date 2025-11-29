class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_owner, only: %i[ index new create ]
  before_action :set_card, only: %i[ show edit update toggle_done destroy ]

  def index
    @cards = @owner.cards
  end

  def show
  end

  def new
    @card = @owner.cards.new
  end

  def edit
  end
  def create
    @card = @owner.cards.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card.owner.board, notice: "Card was successfully created." }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card.owner.board, notice: "Card was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_done
    @card.update(done: !@card.done)
    head :ok
  end


  def destroy
    @card.destroy!

    respond_to do |format|
      format.html { redirect_to @card.owner.board, notice: "Card was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
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
