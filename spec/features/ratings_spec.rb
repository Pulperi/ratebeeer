require 'rails_helper'

include Helpers

describe 'Rating' do
  let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
  let!(:style) { FactoryGirl.create :style }
  let!(:beer1) { FactoryGirl.create :beer, name:'iso 3', brewery:brewery, style:style }
  let!(:beer2) { FactoryGirl.create :beer, name:'Karhu', brewery:brewery, style:style }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in username:'Pekka', password:'Foobar1'
  end

  it 'when given, is registered to the beer and user who is signed in' do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button 'Create Rating'
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
    # save_and_open_page
  end

  describe 'on ratings list page' do

    it 'should not have any ratings before created' do
      visit ratings_path
      expect(page).to have_content 'No ratings added yet'
    end

    describe 'after adding ratings to system' do
      let!(:rating1) { FactoryGirl.create :rating, score:5,  beer:beer1, user:user}
      let!(:rating2) { FactoryGirl.create :rating, score:10,  beer:beer2, user:user}

      it 'recent ratings -list should contain name, score and name of the rater' do
        visit ratings_path
        expect(page).to have_content "#{rating1.beer} #{rating1.score} #{user.username}"
      end
    end
  end

  describe 'on user page' do
    let!(:rating1) { FactoryGirl.create :rating, score:5,  beer:beer1, user:user}
    let!(:rating2) { FactoryGirl.create :rating, score:10,  beer:beer2, user:user}

    it 'should list all the users ratings' do
      visit user_path(user)
      user.ratings.each do |r|
        expect(page).to have_content "#{r.beer} #{r.score}"
      end
      # save_and_open_page
    end

    it 'should not list other users ratings' do
      rating3 = FactoryGirl.create :rating, score: 5, beer:beer2, user: FactoryGirl.create(:user, username: 'Paavo')
      visit user_path(user)
      expect(page).not_to have_content "#{rating3.beer} #{rating3.score}"
    end

    it 'clicking delete should remove the rating from page' do
      visit user_path(user)
      expect(page).to have_content "#{rating2.beer} #{rating2.score}"
      expect{
        find(:xpath, "//a[@href='#{rating_path(rating2)}']").click
      }.to change{user.ratings.count}.by(-1)
      expect(page).not_to have_content "#{rating2.beer} #{rating2.score}"
    end
  end

end