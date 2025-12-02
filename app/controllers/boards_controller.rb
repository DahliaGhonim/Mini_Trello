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
    @board.save

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    if @board.update(board_params)
      redirect_to @board, notice: "Board was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy!
    redirect_to boards_path, notice: "Board was successfully destroyed.", status: :see_other
  end

  private
    def set_board
      @board = current_user.boards.find(params.expect(:id))
    end

    def board_params
      params.expect(board: [ :user_id, :name ])
    end
end
