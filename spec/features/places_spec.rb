require 'rails_helper'

describe 'Places' do
  it 'if one is returned by the API, it is shown at the page' do
    allow(BeermappingApi).to receive(:places_in).with('kumpula').and_return(
        [ Place.new(name: 'Oljenkorsi', id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button 'Search'

    expect(page).to have_content 'Oljenkorsi'
  end

  it 'if multiple are returned by the API, they are shown at the page' do
    allow(BeermappingApi).to receive(:places_in).with('kumpula').and_return(
        [ Place.new(name: 'Oljenkorsi', id: 1 ),
          Place.new(name: 'Olutkellari', id: 2 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button 'Search'

    expect(page).to have_content 'Oljenkorsi'
    expect(page).to have_content 'Olutkellari'
  end

  it 'if none are returned by the API, notice is shown on the page' do
    allow(BeermappingApi).to receive(:places_in).with('kumpula').and_return(
        [ ]
    )

    visit places_path
    place = 'kumpula'
    fill_in('city', with: place)
    click_button 'Search'

    expect(page).to have_content "No locations in #{place}"
  end
end