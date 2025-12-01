require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "GET /boards" do
    context "when user is signed in" do
      it "returns success" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)

        get boards_path
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        get boards_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/1" do
    context "when user is signed in" do
      it "returns success" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)
        board = create(:board, user: user)

        get board_path(board)
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        get board_path(board)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/new" do
    context "when user is signed in" do
      it "returns success" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)

        get new_board_path
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        get new_board_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /boards/1/edit" do
    context "when user is signed in" do
      it "returns success" do
        user = create(:user,
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        )
        login_as(user)
        board = create(:board, user: user)

        get edit_board_path(board)
        expect(response).to have_http_status(200)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        board = create(:board)
        get edit_board_path(board)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
