# frozen_string_literal: true
RSpec.describe Answer do
  context 'validation' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question }
    it { should validate_length_of(:body).is_at_least(10) }
  end

  context 'association' do
    it { should belong_to(:question) }
  end
end
