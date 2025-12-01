require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "GET /boards" do
    context "when user is signed in" do
      it "returns success and shows user's boards" do
        user = create_and_login_user
        board1 = create(:board, user: user, name: "My Board")
        board2 = create(:board, user: user, name: "Another Board")
        other_board = create(:board, name: "Someone else's board")

        get boards_path

        expect(response).to have_http_status(200)
        expect(response.body).to include("My Board")
        expect(response.body).to include("Another Board")
        expect(response.body).not_to include("Someone else's board")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        get boards_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/:id" do
    context "when user is signed in" do
      it "returns success for own board" do
        user = create_and_login_user
        board = create(:board, user: user, name: "Test Board")

        get board_path(board)

        expect(response).to have_http_status(200)
        expect(response.body).to include("Test Board")
      end

      it "returns 404 when accessing another user's board" do
        user = create_and_login_user
        other_board = create(:board, name: "Not Mine")

        get board_path(other_board)

        expect(response).to have_http_status(404)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        get board_path(board)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/new" do
    context "when user is signed in" do
      it "returns success" do
        create_and_login_user

        get new_board_path
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        get new_board_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/:id/edit" do
    context "when user is signed in" do
      it "returns success for own board" do
        user = create_and_login_user
        board = create(:board, user: user)

        get edit_board_path(board)
        expect(response).to have_http_status(200)
      end

      it "returns 404 when editing another user's board" do
        user = create_and_login_user
        other_board = create(:board)

        get edit_board_path(other_board)

        expect(response).to have_http_status(404)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        get edit_board_path(board)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /boards" do
    context "when user is signed in" do
      it "creates a new board with valid params" do
        user = create_and_login_user

        expect {
          post boards_path, params: { board: { name: "New Board" } }
        }.to change(Board, :count).by(1)

        expect(response).to redirect_to(board_path(Board.last))
        expect(Board.last.name).to eq("New Board")
        expect(Board.last.user).to eq(user)
      end

      it "does not create board with invalid params" do
        user = create_and_login_user

        expect {
          post boards_path, params: { board: { name: "" } }
        }.not_to change(Board, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        post boards_path, params: { board: { name: "New Board" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /boards/:id" do
    context "when user is signed in" do
      it "updates own board with valid params" do
        user = create_and_login_user
        board = create(:board, user: user, name: "Old Name")

        patch board_path(board), params: { board: { name: "New Name" } }

        expect(response).to redirect_to(board_path(board))
        expect(board.reload.name).to eq("New Name")
        expect(flash[:notice]).to eq("Board was successfully updated.")
      end

      it "does not update board with invalid params" do
        user = create_and_login_user
        board = create(:board, user: user, name: "Original")

        patch board_path(board), params: { board: { name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(board.reload.name).to eq("Original")
      end

      it "returns 404 when updating another user's board" do
        user = create_and_login_user
        other_board = create(:board, name: "Not Mine")

        patch board_path(other_board), params: { board: { name: "Hacked" } }

        expect(response).to have_http_status(404)
        expect(other_board.reload.name).to eq("Not Mine")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        patch board_path(board), params: { board: { name: "New Name" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /boards/:id" do
    context "when user is signed in" do
      it "destroys own board" do
        user = create_and_login_user
        board = create(:board, user: user)

        expect {
          delete board_path(board)
        }.to change(Board, :count).by(-1)

        expect(response).to redirect_to(boards_path)
        expect(flash[:notice]).to eq("Board was successfully destroyed.")
      end

      it "returns 404 when deleting another user's board" do
        user = create_and_login_user
        other_board = create(:board)

        expect {
          delete board_path(other_board)
        }.not_to change(Board, :count)

        expect(response).to have_http_status(404)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        delete board_path(board)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
