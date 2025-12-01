class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i[ edit update destroy]
  before_action :set_board, only: %i[ new create destroy ]


  # GET /lists/new
  def new
    @list = @board.lists.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists or /lists.json
  def create
    @list = @board.lists.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @board, notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list.board, notice: "List was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to board_path(@board), notice: "List was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
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
