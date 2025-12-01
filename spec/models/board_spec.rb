require 'rails_helper'

RSpec.describe Board, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:lists).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    it "is valid with valid attributes" do
      board = build(:board)
      expect(board).to be_valid
    end

    it "is not valid without a name" do
      board = build(:board, name: nil)
      expect(board).not_to be_valid
      expect(board.errors[:name]).to include("can't be blank")
    end

    it "is not valid without a user" do
      board = build(:board, user: nil)
      expect(board).not_to be_valid
    end
  end

  describe "dependent destroy" do
    it "destroys associated lists when board is destroyed" do
      board = create(:board)
      list = create(:list, board: board)

      expect { board.destroy }.to change { List.count }.by(-1)
    end

    it "destroys associated lists and their cards when board is destroyed" do
      board = create(:board)
      list = create(:list, board: board)
      card = create(:card, owner: list)

      expect { board.destroy }.to change { Card.count }.by(-1)
    end
  end
end
