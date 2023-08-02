require 'rails_helper'

RSpec.describe 'Foods', type: :system do
  include Devise::Test::IntegrationHelpers

  before(:each) do
    @user = User.create(
      name: 'User one',
      email: 'user@example.com',
      password: 'password',
      confirmation_token: '23moe234f',
      confirmed_at: Time.now, confirmation_sent_at: Time.now
    )
    @food = Food.create(
      name: 'my_food',
      measurement_unit: 'units',
      price: 10,
      quantity: 10,
      user_id: @user.id
    )
    sign_in @user
  end
  describe '#index' do
    before(:each) do
      visit root_path
    end

    scenario 'should have tittle Food' do
      assert_text 'Foods'
    end
    scenario 'should have link to New food' do
      assert_text 'New food'
      click_on 'New food'
      assert_current_path new_food_path
    end
    scenario 'should have food name, measurement unit, price' do
      assert_text @food.name
      assert_text @food.measurement_unit
      assert_text @food.price
    end
    scenario 'on clicking on a food name, should redirect to that food show page' do
      click_on @food.name
      assert_current_path food_path(@food)
    end
    scenario 'should delete food when delete button is clicked' do
      assert_text 'Delete'
      click_on 'Delete'
      assert_no_text @food.name
    end
  end
  describe '#show' do
    before(:each) do
      visit food_path(@food)
    end
    scenario 'should have food name, measurement unit, price' do
      assert_text @food.name
      assert_text @food.measurement_unit
      assert_text @food.price
      assert_text @food.quantity
    end
    scenario 'should have link to Edit food' do
      assert_text 'Edit this food'
      click_on 'Edit this food'
      assert_current_path edit_food_path(@food)
    end
    scenario 'should have link to Delete food' do
      assert_text 'Destroy this food'
      click_on 'Destroy this food'
      assert_current_path foods_path
    end
  end
  describe '#new' do
    before(:each) do
      visit new_food_path
    end
    scenario 'should have tittle New Food' do
      assert_text 'New food'
    end
    scenario 'should have form to create new food' do
      assert_text 'Name'
      assert_text 'Measurement unit'
      assert_text 'Price'
      assert_text 'Quantity'
    end
    scenario 'should create new food' do
      fill_in 'Name', with: 'my_food_2'
      fill_in 'Measurement unit', with: 'units'
      fill_in 'Price', with: 10
      fill_in 'Quantity', with: 10
      click_on 'Create Food'
      assert_current_path food_path(Food.last)
    end
  end
  describe '#edit' do
    before(:each) do
      visit edit_food_path(@food)
    end
    scenario 'should have tittle Edit Food' do
      assert_text 'Editing food'
    end
    scenario 'should have form to edit food' do
      assert_text 'Name'
      assert_text 'Measurement unit'
      assert_text 'Price'
      assert_text 'Quantity'
    end
    scenario 'should update food' do
      fill_in 'Name', with: 'my_food_3'
      fill_in 'Measurement unit', with: 'units'
      fill_in 'Price', with: 12
      fill_in 'Quantity', with: 15
      click_on 'Update Food'
      assert_current_path food_path(@food)
    end
  end
end
