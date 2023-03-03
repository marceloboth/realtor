# frozen_string_literal: true

require 'rails_helper'

describe 'Search' do
  before do
    house
    sign_in user
    visit root_path
  end

  let(:user) { create(:user) }
  let(:house) { create(:house) }

  it 'display a default list of properties' do
    expect(page).to have_link(house.address, href: house.origin_url)
    expect(page).to have_content "House has: #{house.bedrooms} bedrooms and #{house.bathrooms} bathrooms"
    expect(page).to have_content house.price
  end

  describe 'search by possible fields' do
    it 'by address, bedrooms, bathrooms and price' do
      fill_in 'Address contains', with: house.address
      fill_in 'Bedrooms greater than or equal to', with: 1
      fill_in 'Bathrooms greater than or equal to', with: 1
      fill_in 'Price less than or equal to', with: 10000.0

      click_button 'Search'

      expect(page).to have_link(house.address, href: house.origin_url)
      expect(page).to have_content "House has: #{house.bedrooms} bedrooms and #{house.bathrooms} bathrooms"
      expect(page).to have_content house.price
    end
  end
end
