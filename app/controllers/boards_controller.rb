class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board, only: %i[ show edit update destroy ]

  def index
    @boards = current_user.boards
  end

  def show
  end

  def new
    @board = current_user.boards.new
  end

  def edit
  end

  def create
    @board = current_user.boards.new(board_params)

    respond_to do |format|
      if @board.save
        redirect_to @board, notice: "Board was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    respond_to do |format|
      if @board.update(board_params)
        redirect_to @board, notice: "Board was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @board.destroy!

    respond_to do |format|
      redirect_to boards_path, notice: "Board was successfully destroyed.", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = current_user.boards.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.expect(board: [ :user_id, :name ])
    end
end
