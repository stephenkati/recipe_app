require 'rails_helper'

RSpec.describe 'General Shopping Lists', type: :system do
  include Devise::Test::IntegrationHelpers

  before do
    @user = User.create(
      name: 'User one',
      email: 'user@example.com',
      password: 'password',
      confirmation_token: '23moe234f',
      confirmed_at: Time.now, confirmation_sent_at: Time.now
    )

    sign_in @user

    @food = Food.create(
      name: 'Food Item',
      measurement_unit: 'units',
      price: 10.99,
      quantity: 5,
      user_id: @user
    )
  end

  it 'displays the total food items and total price' do
    visit general_shopping_lists_path
    expect(page).to have_text("Total Food Items: #{@user.foods.count}")
    expect(page).to have_text("Total Price: $#{@user.foods.sum('price * quantity')}")
  end

  it 'displays the general shopping list table with food items' do
    visit general_shopping_lists_path
    expect(page).to have_selector('table')
    expect(page).to have_selector('tr', count: @user.foods.count + 1)
  end

  it 'displays the correct data in the general shopping list table' do
    visit general_shopping_lists_path
    @user.foods.each do |food|
      expect(page).to have_text(food.name)
      expect(page).to have_text(food.quantity)
      expect(page).to have_text("$#{food.price * food.quantity}")
    end
  end
end
