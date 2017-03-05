# frozen_string_literal: true
RSpec.describe Question do
  context 'validation' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_length_of(:title).is_at_least(10) }
    it { should validate_length_of(:body).is_at_least(10) }
  end

  context 'association' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end
end
