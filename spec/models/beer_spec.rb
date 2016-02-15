require 'rails_helper'

include Helpers

RSpec.describe Beer, type: :model do

  let!(:style) { FactoryGirl.create(:style) }

  it 'has name and style set up correctly' do
    beer = Beer.new name:'Bisse', style: style

    expect(beer.name).to eq 'Bisse'
    expect(beer.style).to eq style
  end

  describe 'is not saved when' do
    it 'name is not set' do
      beer = Beer.create style: style
      expect(beer).not_to be_valid
      expect(Beer.count).to be 0
    end

    it 'style is not set' do
      beer = Beer.create name:'Bisse'
      expect(beer).not_to be_valid
      expect(Beer.count).to be 0
    end
  end

end
