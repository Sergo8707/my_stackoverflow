# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Answer do
  context 'validation' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question }
  end

  context 'association' do
    it { should belong_to(:question) }
  end
end
