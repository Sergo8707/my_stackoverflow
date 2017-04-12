# frozen_string_literal: true
require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    context 'question vote' do
      let(:votable) { create(:question) }

      it_behaves_like 'Create Vote'
    end

    context 'answer vote' do
      let(:votable) { create(:answer) }

      it_behaves_like 'Create Vote'
    end
  end
end
