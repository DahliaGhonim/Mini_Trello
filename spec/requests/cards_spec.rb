require 'rails_helper'

RSpec.describe "Cards", type: :request do
  describe "GET /boards/:board_id/lists/:list_id/cards/new" do
    context "when user is signed in" do
      it "returns success" do
        user = create_and_login_user
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
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/:board_id/lists/:list_id/cards/:id/edit" do
    context "when user is signed in" do
      it "returns success" do
        user = create_and_login_user
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
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /boards/:board_id/lists/:list_id/cards" do
    context "when user is signed in" do
      it "creates a new card for list with valid params" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)

        expect {
          post board_list_cards_path(board, list), params: { card: { title: "New Task" } }
        }.to change(Card, :count).by(1)

        card = Card.last
        expect(response).to redirect_to(board_path(board))
        expect(card.title).to eq("New Task")
        expect(card.owner).to eq(list)
        expect(flash[:notice]).to eq("Card was successfully created.")
      end

      it "does not create card with invalid params" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)

        expect {
          post board_list_cards_path(board, list), params: { card: { title: "" } }
        }.not_to change(Card, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        post board_list_cards_path(board, list), params: { card: { title: "New Task" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /boards/:board_id/lists/:list_id/cards/:id" do
    context "when user is signed in" do
      it "updates card with valid params" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list, title: "Old Title")

        patch board_list_card_path(board, list, card), params: { card: { title: "New Title" } }

        expect(response).to redirect_to(board_path(board))
        expect(card.reload.title).to eq("New Title")
        expect(flash[:notice]).to eq("Card was successfully updated.")
      end

      it "does not update card with invalid params" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list, title: "Original")

        patch board_list_card_path(board, list, card), params: { card: { title: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(card.reload.title).to eq("Original")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        card = create(:card, owner: list)
        patch board_list_card_path(board, list, card), params: { card: { title: "New Title" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /boards/:board_id/lists/:list_id/cards/:id/toggle_done" do
    context "when user is signed in" do
      it "toggles done from false to true" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list, done: false)

        patch toggle_done_board_list_card_path(board, list, card)

        expect(response).to have_http_status(200)
        expect(card.reload.done).to eq(true)
      end

      it "toggles done from true to false" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list, done: true)

        patch toggle_done_board_list_card_path(board, list, card)

        expect(response).to have_http_status(200)
        expect(card.reload.done).to eq(false)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        card = create(:card, owner: list)
        patch toggle_done_board_list_card_path(board, list, card)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /boards/:board_id/lists/:list_id/cards/:id/move" do
    context "when user is signed in" do
      it "moves card to a different list" do
        user = create_and_login_user
        board = create(:board, user: user)
        list1 = create(:list, board: board, name: "To Do")
        list2 = create(:list, board: board, name: "Done")
        card = create(:card, owner: list1, title: "Task")

        patch move_board_list_card_path(board, list2, card)

        expect(response).to have_http_status(200)
        expect(card.reload.owner).to eq(list2)
      end

      it "changes card position" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)
        card1 = create(:card, owner: list, title: "First")
        card2 = create(:card, owner: list, title: "Second")
        card3 = create(:card, owner: list, title: "Third")

        # Move card3 to position 0 (becomes first)
        patch move_board_list_card_path(board, list, card3), params: {
          list_id: list.id,
          position: 0
        }

        expect(response).to have_http_status(200)
        expect(card3.reload.position).to eq(1)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        card = create(:card, owner: list)
        patch move_board_list_card_path(board, list, card), params: {
          list_id: list.id,
          position: 0
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /boards/:board_id/lists/:list_id/cards/:id" do
    context "when user is signed in" do
      it "destroys card" do
        user = create_and_login_user
        board = create(:board, user: user)
        list = create(:list, board: board)
        card = create(:card, owner: list)

        expect {
          delete board_list_card_path(board, list, card)
        }.to change(Card, :count).by(-1)

        expect(response).to redirect_to(board_path(board))
        expect(flash[:notice]).to eq("Card was successfully destroyed.")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        list = create(:list, board: board)
        card = create(:card, owner: list)
        delete board_list_card_path(board, list, card)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
