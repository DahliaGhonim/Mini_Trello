require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:boards).dependent(:destroy) }
    it { should have_many(:cards).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it "validates email format" do
      user = build(:user, email: "invalid")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it { should validate_presence_of(:password) }

    it "validates password minimum length" do
      user = build(:user, password: "12345", password_confirmation: "12345")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe "dependent destroy" do
    it "destroys associated boards when user is destroyed" do
      user = create(:user)
      board = create(:board, user: user)

      expect { user.destroy }.to change { Board.count }.by(-1)
    end

    it "destroys associated cards when user is destroyed" do
      user = create(:user)
      card = create(:card, owner: user)

      expect { user.destroy }.to change { Card.count }.by(-1)
    end
  end
end
