require 'spec_helper'

RSpec.describe ACC::Clients::ConstructionCloud::Issues::Me do
  let(:auth) do
    ACC::Clients::Auth.new(
      access_token: MOCK_ACCESS_TOKEN,
      refresh_token: MOCK_REFRESH_TOKEN
    )
  end

  let(:project_id) { MOCK_PROJECT_ID }
  let(:me_client) { described_class.new(auth, project_id) }

  describe '#initialize' do
    it 'sets the project_id' do
      expect(me_client.send(:project_id)).to eq(project_id)
    end

    it 'inherits from ConstructionCloud::Base' do
      expect(described_class.superclass).to eq(ACC::Clients::ConstructionCloud::Base)
    end

    it 'includes the Paginated module' do
      expect(described_class.included_modules).to include(ACC::Utils::Paginated)
    end
  end

  describe '#endpoint' do
    it 'includes the project_id' do
      expect(me_client.send(:endpoint)).to include(project_id)
    end

    it 'includes the base path' do
      expect(me_client.send(:endpoint)).to include('/construction/issues/v1/projects/')
    end

    it 'includes the me endpoint' do
      expect(me_client.send(:endpoint)).to include('/users/me')
    end
  end

  describe '#call_request', :vcr do
    context 'when the request is successful' do
      it 'makes a GET request and returns the response' do
        response = me_client.send(:call_request)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to include('userId')
      end
    end

    context 'when the token is invalid' do
      let(:auth) do
        ACC::Clients::Auth.new(
          access_token: 'invalid_token',
          refresh_token: MOCK_REFRESH_TOKEN
        )
      end

      it 'returns an unauthorized response' do
        response = me_client.send(:call_request)
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)).to include('developerMessage')
      end
    end
  end

  describe '#params' do
    it 'returns an empty hash by default' do
      expect(me_client.send(:params)).to eq({})
    end
  end
end
