require 'rails_helper'

RSpec.describe Content, type: :model do
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(5) }

  # Associations
  it { should belong_to(:user) }
end
