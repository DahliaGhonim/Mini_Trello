# spec/requests/lists_spec.rb
require 'rails_helper'

RSpec.describe "Lists", type: :request do
  describe "GET /boards/:board_id/lists/new" do
    context "when user is signed in" do
      it "returns success" do
        user = create_and_login_user
        board = create(:board, user: user)

        get new_board_list_path(board)
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        get new_board_list_path(board)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/:board_id/lists/:id/edit" do
    context "when user is signed in" do
      it "returns success" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)

        get edit_board_list_path(board, list)
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        get edit_board_list_path(board, list)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /boards/:board_id/lists" do
    context "when user is signed in" do
      it "creates a new list with valid params" do
        user = create_and_login_user
        board = create(:board, user: user)

        expect {
          post board_lists_path(board), params: { list: { name: "To Do" } }
        }.to change(List, :count).by(1)

        expect(response).to redirect_to(board_path(board))
        expect(List.last.name).to eq("To Do")
        expect(List.last.board).to eq(board)
        expect(flash[:notice]).to eq("List was successfully created.")
      end

      it "does not create list with invalid params" do
        user = create_and_login_user
        board = create(:board, user: user)

        expect {
          post board_lists_path(board), params: { list: { name: "" } }
        }.not_to change(List, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        post board_lists_path(board), params: { list: { name: "To Do" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /boards/:board_id/lists/:id" do
    context "when user is signed in" do
      it "updates list with valid params" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board, name: "Old Name")

        patch board_list_path(board, list), params: { list: { name: "New Name" } }

        expect(response).to redirect_to(board_path(board))
        expect(list.reload.name).to eq("New Name")
        expect(flash[:notice]).to eq("List was successfully updated.")
      end

      it "does not update list with invalid params" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board, name: "Original")

        patch board_list_path(board, list), params: { list: { name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(list.reload.name).to eq("Original")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        patch board_list_path(board, list), params: { list: { name: "New Name" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /boards/:board_id/lists/:id" do
    context "when user is signed in" do
      it "destroys list" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)

        expect {
          delete board_list_path(board, list)
        }.to change(List, :count).by(-1)

        expect(response).to redirect_to(board_path(board))
        expect(flash[:notice]).to eq("List was successfully destroyed.")
      end

      it "destroys list and its associated cards" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list)

        expect {
          delete board_list_path(board, list)
        }.to change(Card, :count).by(-1)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        delete board_list_path(board, list)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
