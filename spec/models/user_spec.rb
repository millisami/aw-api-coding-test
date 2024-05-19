require 'rails_helper'

RSpec.describe User, type: :model do
  # Validation tests
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should_not allow_value("test@host").for(:email) }
  it { should allow_value("test@host.com").for(:email) }
  it { should allow_value("lolita_greenfelder@pollich.test").for(:email) }
  it { should allow_value("catharine@nienow-franecki.example").for(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6) }

  # Associations
  describe 'Associations' do
    it { should have_many(:contents) }
  end
end
