require 'rails_helper'

include Helpers

describe 'Beer' do
  let!(:brewery) { FactoryGirl.create :brewery, name:'Koff' }
  let!(:user) { FactoryGirl.create :user }

  describe 'create new beer' do
    before :each do
      sign_in username:'Pekka', password:'Foobar1'
    end

    it 'when creating with blank name is not added to brewery or beer collection' do
      visit new_beer_path
      fill_in('beer_name', with:nil)
      select('Lager', from:'beer[style]')
      select('Koff', from:'beer[brewery_id]')

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(0)

      expect(page).to have_content 'Name is too short (minimum is 1 character)'
      expect(brewery.beers.count).to eq(0)
    end

    it 'when created is registered to brewery and added to beer collection' do
      visit new_beer_path
      fill_in('beer_name', with:'Bisse')
      select('Lager', from:'beer[style]')
      select('Koff', from:'beer[brewery_id]')

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(1)

      expect(brewery.beers.count).to eq(1)
    end
  end
end