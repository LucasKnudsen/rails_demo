require 'rails_helper'
include ActionController::RespondWith

RSpec.describe 'POST /api/articles', types: :request do
  let(:user) { create(:user) }
  let(:user_credentials) { user.create_new_auth_token }

  describe 'Authenticated POST request' do
    before do
      post '/api/articles',
           params: {
             article: {
               title: 'Im logged in!',
               body: 'A long and descriptive story'
             }
           },
           headers: user_credentials
    end

    it 'responds with a 201 status' do
      expect(response).to have_http_status 201
    end

    it 'responds with an access-token' do
      expect(response.has_header?('access-token')).to eq(true)
    end

    it 'responds with expected message' do
      expect(response_json['response']['message']).to eq "Successfully created new article!"
    end
  end

  describe 'Unauthenticated POST request' do
    before do
      post '/api/articles',
           params: {
             article: {
               title: 'Im logged in!',
               body: 'A long and descriptive story'
             }
           }
    end

    it 'responds with a 401' do
      expect(response).to have_http_status 401
    end

    it 'responds with an appropriate error message' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end
end
