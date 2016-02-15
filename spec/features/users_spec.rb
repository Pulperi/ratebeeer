require 'rails_helper'

include Helpers

describe 'User' do
  let!(:user) { FactoryGirl.create :user }

  describe 'who has signed up' do
    it 'can signin with right credentials' do
      sign_in username:'Pekka', password:'Foobar1'

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it 'is redirected back to signin form if wrong credentials given' do
      sign_in username:'Pekka', password:'wrong'

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it 'when signed up with good credentials, is added to the system' do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end

  describe 'on user page' do
    let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
    let!(:brewery2) { FactoryGirl.create :brewery, name:'Koff2'}
    let!(:style1) { FactoryGirl.create :style, name:'Piss' }
    let!(:style2) { FactoryGirl.create :style, name:'Lager' }
    let!(:beer1) { FactoryGirl.create :beer, name:'iso 3', style:style1, brewery:brewery }
    let!(:beer2) { FactoryGirl.create :beer, name:'Karhu', style:style2, brewery:brewery }
    let!(:beer3) { FactoryGirl.create :beer, name:'Karhu2', style:style1, brewery:brewery2 }
    let!(:rating1) { FactoryGirl.create :rating, score:5,  beer:beer1, user:user}
    let!(:rating2) { FactoryGirl.create :rating, score:10,  beer:beer2, user:user}
    let!(:rating2) { FactoryGirl.create :rating, score:19,  beer:beer3, user:user}

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

    it 'favorite kind of beer brewery should be mentioned' do
      visit user_path(user)
      expect(page).to have_content "Based on his ratings #{user.favorite_style} is his favorite kind of beer and #{user.favorite_brewery.name} is his favorite brewery."
    end

    it 'clicking delete should remove the rating from page' do
      sign_in username:'Pekka', password:'Foobar1'
      visit user_path(user)
      expect{
        find(:xpath, "//a[@href='#{rating_path(rating2)}']").click
      }.to change{user.ratings.count}.by(-1)
      expect(page).not_to have_content "#{rating2}"
    end
  end

end