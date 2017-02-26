RSpec.describe Question do
  context 'validation' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  context 'association' do
    it { should have_many(:answers).dependent(:destroy) }
  end
end
