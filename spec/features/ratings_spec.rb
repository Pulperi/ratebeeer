require 'rails_helper'

include Helpers

describe 'Rating' do
  let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
  let!(:beer1) { FactoryGirl.create :beer, name:'iso 3', brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:'Karhu', brewery:brewery }
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
      expect(page).to have_content 'Number of ratings 0'
    end

    describe 'after adding ratings to system' do
      let!(:rating1) { FactoryGirl.create :rating, score:5,  beer:beer1, user:user}
      let!(:rating2) { FactoryGirl.create :rating, score:10,  beer:beer2, user:user}

      it 'should say 2 ratings on page' do
        visit ratings_path
        expect(page).to have_content 'Number of ratings 2'
      end

      it 'list should contain name, score and name of the rater' do
        visit ratings_path
        expect(page).to have_content "#{rating1} #{user.username}"
      end
    end
  end

  describe 'on user page' do
    let!(:rating1) { FactoryGirl.create :rating, score:5,  beer:beer1, user:user}
    let!(:rating2) { FactoryGirl.create :rating, score:10,  beer:beer2, user:user}

    it 'should list all the users ratings' do
      visit user_path(user)
      user.ratings.each do |r|
        expect(page).to have_content "#{r}"
      end
      # save_and_open_page
    end

    it 'should not list other users ratings' do
      rating3 = FactoryGirl.create :rating, score: 5, beer:beer2, user: FactoryGirl.create(:user, username: 'Paavo')
      visit user_path(user)
      expect(page).not_to have_content "#{rating3}"
    end

    it 'clicking delete should remove the rating from page' do
      visit user_path(user)
      expect{
        # find(:xpath, "//a[@href='/ratings/#{rating2.id}']").click
        find(:xpath, "//a[@href='#{rating_path(rating2)}']").click
      }.to change{user.ratings.count}.by(-1)
      expect(page).not_to have_content "#{rating2}"
    end
  end

end