require 'rails_helper'

RSpec.describe List, type: :model do
  describe "associations" do
    it { should belong_to(:board) }
    it { should have_many(:cards).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    it "is valid with valid attributes" do
      list = build(:list)
      expect(list).to be_valid
    end

    it "is not valid without a name" do
      list = build(:list, name: nil)
      expect(list).not_to be_valid
      expect(list.errors[:name]).to include("can't be blank")
    end

    it "is not valid without a board" do
      list = build(:list, board: nil)
      expect(list).not_to be_valid
    end
  end

  describe "dependent destroy" do
    it "destroys associated cards when list is destroyed" do
      list = create(:list)
      card = create(:card, owner: list)

      expect { list.destroy }.to change { Card.count }.by(-1)
    end
  end

  describe "accessing board through list" do
    it "can access the parent board" do
      board = create(:board, name: "My Board")
      list = create(:list, board: board)

      expect(list.board.name).to eq("My Board")
    end
  end
end
