require 'rails_helper'

RSpec.describe "Cards", type: :request do
  describe "GET /boards/1/lists/1/cards" do
    context "when user is signed in" do
      it "returns not found" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)
        board = create(:board, user: user)
        list = create(:list, board: board)

        get board_list_cards_path(board, list)
        expect(response).to have_http_status(404)
      end
    end

    context "when user is not signed in" do
      it "returns not found" do
        board = create(:board)
        list = create(:list, board: board)
        get board_list_cards_path(board, list)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET /boards/1/lists/1/cards/1" do
    context "when user is signed in" do
      it "returns not found" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list)

        get board_list_card_path(board, list, card)
        expect(response).to have_http_status(404)
      end
    end

    context "when user is not signed in" do
      it "returns not found" do
        board = create(:board)
        list = create(:list, board: board)
        card = create(:card, owner: list)
        get board_list_card_path(board, list, card)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET /boards/1/lists/1/cards/new" do
    context "when user is signed in" do
      it "returns success" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)
        board = create(:board, user: user)
        list = create(:list, board: board)

        get new_board_list_card_path(board, list)
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        get new_board_list_card_path(board, list)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/1/lists/1/cards/1/edit" do
    context "when user is signed in" do
      it "returns success" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list)

        get edit_board_list_card_path(board, list, card)
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        card = create(:card, owner: list)
        get edit_board_list_card_path(board, list, card)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
