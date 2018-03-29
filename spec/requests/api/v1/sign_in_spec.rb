RSpec.describe DeviseController, type: :request do

  let!(:user) { create(:user, subscriber: true) }

  describe 'user signs in with successfully' do

    let(:document) { JSON.parse(response.body)}
    let(:headers) { { HTTP_ACCEPT: 'application/json' } }

    it 'valid user returns user data' do
      post '/api/v1/auth/sign_in', params: {
        email: user.email, password: user.password,
      }, headers: headers

      expected_response = eval(file_fixture('user.txt').read)

      expect(document).to eq expected_response
    end
  end

  describe 'users types in the wrong credentials' do
    let(:document) { JSON.parse(response.body) }
    let(:headers) { { HTTP_ACCEPT: 'application/json' } }


    it 'should return error if wrong password' do

      post '/api/v1/auth/sign_in', params: {
        email: user.email, password: 'wrongPassword',
      }, headers: headers

      expect(document['errors'].first).to eq 'Invalid login credentials. Please try again.'
    end

    it 'should return error if wrong email' do

      post '/api/v1/auth/sign_in', params: {
        email: 'wrong@email.com', password: user.password,
      }, headers: headers

      expect(document['errors'].first).to eq 'Invalid login credentials. Please try again.'
    end

  end
end