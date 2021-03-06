# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  describe 'GET #show' do
    let!(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:comment) { comments.last }
      let!(:attachments) { create_list(:attachment, 2, attachable: question) }
      let!(:attachment) { attachments.last }
      let!(:parent_path) { 'question' }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like 'API Attachable'
      it_behaves_like 'API Commentable'
    end
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge!(options)
    end
  end
end
