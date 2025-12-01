class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i[ edit update destroy]
  before_action :set_board, only: %i[ new create destroy ]


  def new
    @list = @board.lists.new
  end

  def edit
  end

  def create
    @list = @board.lists.new(list_params)

    if @list.save
      redirect_to @board, notice: "List was successfully created."
    else
      render :new, status: :unprocessable_entity
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params.expect(:id))
    end

    def set_board
      @board = Board.find(params.expect(:board_id))
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.expect(list: [ :board_id, :name ])
    end
end
