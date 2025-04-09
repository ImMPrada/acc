require 'spec_helper'

RSpec.describe ACC::Clients::ConstructionCloud::Issues::Index do
  let(:auth) do
    ACC::Clients::Auth.new(
      access_token: MOCK_ACCESS_TOKEN,
      refresh_token: MOCK_REFRESH_TOKEN
    )
  end

  let(:project_id) { MOCK_PROJECT_ID }
  let(:issues_client) { described_class.new(auth, project_id) }

  describe 'structure' do
    it 'has the correct endpoint' do
      expect(issues_client.send(:endpoint)).to include(project_id)
    end

    it 'responds to all_paginated' do
      expect(issues_client).to respond_to(:all_paginated)
    end

    it 'includes the Paginated module' do
      expect(described_class.included_modules).to include(ACC::Utils::Paginated)
    end
  end

  describe '#all_paginated', :vcr do
    context 'when project has issues' do
      it 'returns an array of issues' do
        issues = issues_client.all_paginated
        expect(issues).to be_an(Array)
        expect(issues.first).to include('id', 'title', 'status')
      end
    end

    context 'when project has no issues' do
      let(:project_id) { 'empty_project_id' }

      it 'returns an empty array' do
        issues = issues_client.all_paginated
        expect(issues).to be_an(Array)
        expect(issues).to be_empty
      end
    end

    context 'when token is invalid' do
      let(:auth) do
        ACC::Clients::Auth.new(
          access_token: 'invalid_token',
          refresh_token: MOCK_REFRESH_TOKEN
        )
      end

      it 'raises an error' do
        expect { issues_client.all_paginated }.to raise_error(ACC::Errors::UnauthorizedError)
      end
    end
  end
end
