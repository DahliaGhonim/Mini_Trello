class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card, only: %i[ show edit update toggle_done destroy ]

  # GET /cards or /cards.json
  def index
    if params[:list_id]
      @list = List.find(params.expect(:list_id))
      @cards = @list.cards.all
    else
      @card = current_user.cards.new
    end
  end

  # GET /cards/1 or /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    if params[:list_id]
      @list = List.find(params.expect(:list_id))
      @card = @list.cards.new(user: current_user)
    else
      @card = current_user.cards.new
    end
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards or /cards.json
  def create
    if params[:list_id]
      @list = List.find(params.expect(:list_id))
      @card = @list.cards.new(card_params.merge(user: current_user))
    else
      @card = current_user.cards.new(card_params)
    end

    respond_to do |format|
      if @card.save
        format.html { redirect_to @list.board, notice: "Card was successfully created." }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1 or /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card.list.board, notice: "Card was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_done
    @list = List.find(params.expect(:list_id))
    @card.update(done: !@card.done)
    redirect_to @list.board
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    @list = List.find(params.expect(:list_id))
    @card.destroy!

    respond_to do |format|
      format.html { redirect_to @list.board, notice: "Card was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = current_user.cards.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def card_params
      params.require(:card).permit(:title, :user_id, :list_id)
    end
end
