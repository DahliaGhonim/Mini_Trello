class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board
  before_action :set_list, only: %i[ edit update destroy cards_count ]

  def index
    lists = @board.lists.select(:id, :name)
    render json: lists
  end

  def new
    @list = @board.lists.new
  end

  def edit
  end

  def create
    @list = @board.lists.new(list_params)
    @list.save

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    if @list.update(list_params)
      redirect_to @list.board, notice: "List was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy!
    redirect_to board_path(@board), notice: "List was successfully destroyed.", status: :see_other
  end

  def cards_count
    count = @list.cards.count
    render json: { count: count }
  end

  private
  def set_list
    @list = @board.lists.find(params.expect(:id))
  end

  def set_board
    @board = Board.find(params.expect(:board_id))
  end

  def list_params
      params.expect(list: [ :board_id, :name ])
  end
end
