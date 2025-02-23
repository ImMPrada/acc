require 'spec_helper'

RSpec.describe ACC::Resources::ConstructionCloud::Issues::Index do
  let(:auth) do
    ACC::Resources::Auth.new(
      access_token: MOCK_ACCESS_TOKEN,
      refresh_token: 'MihNEgB9kmPNv5qOqEMEosQADgDJRolZaDSRrjoF4c'
    )
  end

  describe '#all_paginated', :vcr do
    context 'when project has no issues' do
      let(:project_id) { 'cfd4dbc0-d2ff-4295-957d-6da26067aefd' }
      let(:index) { described_class.new(auth, project_id) }
      let(:issues) { index.all_paginated }

      it 'returns an array' do
        expect(issues).to be_an(Array)
      end

      it 'returns an empty array' do
        expect(issues).to be_empty
      end
    end

    context 'when project has issues', :vcr do
      let(:project_id) { '71a20678-d059-42aa-9a82-7385e1cf4972' }
      let(:index) { described_class.new(auth, project_id) }
      let(:issues) { index.all_paginated }

      it 'returns an array of issues' do
        expect(issues).to be_an(Array)
      end

      it 'returns non-empty results' do
        expect(issues).not_to be_empty
      end

      it 'includes required issue attributes' do
        expect(issues.first).to include(
          'id',
          'title',
          'status',
          'createdAt'
        )
      end
    end
  end
end
