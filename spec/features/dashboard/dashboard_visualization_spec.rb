# frozen_string_literal: true

require 'rails_helper'

describe 'Dashboard' do
  before do
    sign_in user
    visit root_path
  end

  let(:user) { User.create!(email: 'user@mail.com', password: 'pass123', password_confirmation: 'pass123') }

  it 'will have access to data visualization' do
    within '#desktop-nav' do
      click_link 'Dashboard'
    end

    expect(page).to have_content 'We will display here some charts and some tables.'
  end
end
