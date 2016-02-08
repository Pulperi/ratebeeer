require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has the username set correctly' do
    user = User.new username:'Pekka'
    expect(user.username).to eq 'Pekka'
  end

  it 'is not saved without a password' do
    user = User.create username:'Pekka'
    expect(user).not_to be_valid
    expect(User.count).to eq 0
  end

  describe 'is not saved when the password' do
    it 'is too short' do
      user = User.create username:'Pekka', password: 'Sx1', password_confirmation: 'Sx1'
      expect(user).not_to be_valid
      expect(User.count).to eq 0
    end

    it 'does not contain numbers' do
      user = User.create username:'Pekka', password: 'Secret', password_confirmation: 'Secret'
      expect(user).not_to be_valid
      expect(User.count).to eq 0
    end
  end

  describe 'with a proper password' do
    let(:user){ FactoryGirl.create :user }

    it 'is saved' do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it 'and with two ratings, has the correct average rating' do
      rating = FactoryGirl.create :rating
      rating2 = FactoryGirl.create :rating2

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe 'favorite beer' do
    let(:user){ FactoryGirl.create :user }

    it 'has a method for determining one' do
      expect(user).to respond_to :favorite_beer
    end

    it 'without ratings does not have one' do
      expect(user.favorite_beer).to eq nil
    end

    it 'is the only rated if only one rating' do
      beer = create_beer_with_rating user, 10

      expect(user.favorite_beer).to eq beer
    end

    it 'is the one with highest rating if several rated' do
      create_beers_with_ratings user, 10, 20, 15, 7, 9
      best = create_beer_with_rating user, 25

      expect(user.favorite_beer).to eq best
    end
  end

  describe 'favorite style' do
    let(:user) { FactoryGirl.create :user }

    it 'has a method for determining one' do
      expect(user).to respond_to :favorite_style
    end

    it 'without ratings does not have one' do
      expect(user.favorite_style).to eq nil
    end

    it 'is the only rated if only one rating' do
      beer = create_beer_with_rating user, 10

      expect(user.favorite_style).to eq beer.style
    end

    it 'is the only rated if only one style rated' do
      create_beers_with_style_and_ratings user, 'lager', 10, 2
      expect(user.favorite_style).to eq 'lager'
    end

    it 'is the one with highest rating if several rated' do
      create_beers_with_style_and_ratings user, 'piss', 1, 2, 3, 4, 5
      create_beers_with_style_and_ratings user, 'lager', 6, 7, 8, 9, 10

      expect(user.favorite_style).to eq 'lager'
    end

  end

  describe 'favorite brewery' do
    let(:user) { FactoryGirl.create :user }

    it 'has a method for determining one' do
      expect(user).to respond_to :favorite_brewery
    end

    it 'without ratings does not have one' do
      expect(user.favorite_brewery).to eq nil
    end

    it 'is the only rated if only one rating' do
      beer = create_beer_with_rating user, 10

      expect(user.favorite_brewery).to eq beer.brewery
    end

    it 'is the only rated if only one rated' do
      create_beers_with_brewery_and_ratings user, 'PanimoA', 10, 2
      expect(user.favorite_brewery.name).to eq 'PanimoA'
    end

    it 'is the one with highest rating if several rated' do
      create_beers_with_brewery_and_ratings user, 'PanimoA', 10, 2, 5, 3
      create_beers_with_brewery_and_ratings user, 'PanimoB', 10, 10, 32, 3
      create_beers_with_brewery_and_ratings user, 'PanimoC', 1, 10, 32, 3

      expect(user.favorite_brewery.name).to eq 'PanimoB'
    end

  end


end # describe User

def create_beers_with_style_and_ratings(user, style, *scores)
  scores.each do |score|
    create_beer_with_style_and_rating user, style, score
  end
end

def create_beers_with_brewery_and_ratings(user, brewery, *scores)
  scores.each do |score|
    create_beer_with_brewery_and_rating user, brewery, score
  end
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating user, score
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create :beer
  FactoryGirl.create :rating, score:score,  beer:beer, user:user
  beer
end

def create_beer_with_style_and_rating(user, style, score)
  beer = FactoryGirl.create :beer, style:style
  FactoryGirl.create :rating, score:score,  beer:beer, user:user
  beer
end

def create_beer_with_brewery_and_rating(user, brewery, score)
  b = FactoryGirl.create :brewery, name:brewery
  beer = FactoryGirl.create :beer, brewery:b
  FactoryGirl.create :rating, score:score,  beer:beer, user:user
  beer
end

