# frozen_string_literal: true

require 'rails_helper'

describe 'Search' do
  before do
    houses
    sign_in user
    visit root_path
  end

  let(:user) { create(:user) }
  let(:houses) { create_list(:house, 2) }

  it 'display a default list of properties' do
    expect(page).to have_content houses.first.address
    expect(page).to have_content houses.first.price
  end
end
