require 'rails_helper'

describe 'Beerlist page' do
  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: 'Koff')
    @brewery2 = FactoryGirl.create(:brewery, name: 'Schlenkerla')
    @brewery3 = FactoryGirl.create(:brewery, name: 'Ayinger')
    @style1 = Style.create name: 'Lager'
    @style2 = Style.create name: 'Rauchbier'
    @style3 = Style.create name: 'Weizen'
    @beer1 = FactoryGirl.create(:beer, name: 'Nikolai', brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: 'Fastenbier', brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: 'Lechte Weisse', brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it 'shows one known beer', js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content 'Nikolai'
  end

  it 'shows all the known beers in asc order by default', js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    table_rows = page.all('tr').map {|row| row.text }
    expect(table_rows[1]).to have_content 'Fastenbier'
    expect(table_rows[2]).to have_content 'Lechte Weisse'
    expect(table_rows[3]).to have_content 'Nikolai'
  end

  describe 'after clicking' do

    it 'style, it orders the beers by style in asc order', js: true do
      visit beerlist_path
      find('table').find('tr:nth-child(2)')
      page.all('a#style').first.click
      table_rows = page.all('tr').map {|row| row.text }
      expect(table_rows[1]).to have_content 'Lager'
      expect(table_rows[2]).to have_content 'Rauchbier'
      expect(table_rows[3]).to have_content 'Weizen'
    end

    it 'brewery, it orders the beers by style in asc order', js: true do
      visit beerlist_path
      find('table').find('tr:nth-child(2)')
      page.all('a#brewery').first.click
      table_rows = page.all('tr').map {|row| row.text }
      expect(table_rows[1]).to have_content 'Ayinger'
      expect(table_rows[2]).to have_content 'Koff'
      expect(table_rows[3]).to have_content 'Schlenkerla'
    end
  end
end