require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { User.create(name: 'test', email: 'test@test.com', password: 'password') }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with a password shorter than 6 characters' do
      user.password = 'short'
      expect(user).to_not be_valid
    end
  end

  describe 'associations' do
    it 'should have many foods' do
      expect(User.reflect_on_association(:foods).macro).to eq(:has_many)
    end

    it 'should have many recipes' do
      expect(User.reflect_on_association(:recipes).macro).to eq(:has_many)
    end
  end
end
