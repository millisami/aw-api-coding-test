FactoryBot.define do
  factory :content do
    title { Faker::Book.title }
    body { Faker::Quote.famous_last_words }
    user { create(:user) }
  end
end