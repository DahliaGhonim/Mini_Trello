require 'rails_helper'

RSpec.describe Card, type: :model do
  describe "associations" do
    it { should belong_to(:owner) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }

    it "is valid with valid attributes and list as owner" do
      card = build(:card, owner: create(:list))
      expect(card).to be_valid
    end

    it "is valid with valid attributes and user as owner" do
      card = build(:card, owner: create(:user))
      expect(card).to be_valid
    end

    it "is not valid without a title" do
      card = build(:card, title: nil)
      expect(card).not_to be_valid
      expect(card.errors[:title]).to include("can't be blank")
    end

    it "is not valid without an owner" do
      card = build(:card, owner: nil)
      expect(card).not_to be_valid
    end
  end

  describe "polymorphic owner" do
    it "can belong to a list" do
      list = create(:list)
      card = create(:card, owner: list)

      expect(card.owner).to eq(list)
      expect(card.owner_type).to eq("List")
    end

    it "can belong to a user" do
      user = create(:user)
      card = create(:card, owner: user)

      expect(card.owner).to eq(user)
      expect(card.owner_type).to eq("User")
    end
  end

  describe "default scope" do
    it "orders cards by position ascending" do
      list = create(:list)
      card1 = create(:card, owner: list)  # Will be position 1
      card2 = create(:card, owner: list)  # Will be position 2
      card3 = create(:card, owner: list)  # Will be position 3

      card1.insert_at(2)  # Move card1 to position 2
      card2.insert_at(1)  # Move card2 to position 1
      card3.insert_at(3)  # card3 stays at position 3
      list.reload

      cards = list.cards.to_a
      expect(cards).to eq([ card2, card1, card3 ])
    end
  end

  describe "acts_as_list" do
    it "automatically assigns position when created" do
      list = create(:list)
      card1 = create(:card, owner: list)
      card2 = create(:card, owner: list)

      expect(card1.position).to eq(1)
      expect(card2.position).to eq(2)
    end

    it "scopes position to owner" do
      list1 = create(:list)
      list2 = create(:list)

      card1 = create(:card, owner: list1)
      card2 = create(:card, owner: list2)

      # Both should have position 1 because they have different owners
      expect(card1.position).to eq(1)
      expect(card2.position).to eq(1)
    end
  end

  describe "done attribute" do
    it "defaults to false" do
      card = create(:card)
      expect(card.done).to eq(false)
    end

    it "can be set to true" do
      card = create(:card, done: true)
      expect(card.done).to eq(true)
    end
  end
end
