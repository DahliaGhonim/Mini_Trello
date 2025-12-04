class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board, only: %i[ show edit update destroy lists_json ]

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
        format.turbo_stream
        format.json { render :show, status: :created, location: @board }
      else
        format.turbo_stream
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board, notice: "Board was successfully updated." }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @board.destroy!

    respond_to do |format|
      format.html { redirect_to boards_path, notice: "Board was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def lists_json
    lists = @board.lists.select(:id, :name)
    render json: lists
  end

  private
  def set_board
      @board = current_user.boards.find(params.expect(:id))
  end

  def board_params
      params.expect(board: [ :user_id, :name ])
  end
end
