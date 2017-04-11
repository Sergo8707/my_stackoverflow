# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  describe 'GET #show' do
    let!(:answer) { create(:answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:comment) { comments.last }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      let!(:attachment) { attachments.last }
      let!(:parent_path) { 'answer' }

      before { get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token} }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body best created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like 'API Attachable'

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(2).at_path('answer/comments')
        end

        %w(id content created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end
    end
    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end
end
