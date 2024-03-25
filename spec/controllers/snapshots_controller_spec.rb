require 'rails_helper'

RSpec.describe "Snapshots", type: :request do
  describe 'GET #show' do
    let!(:first_snapshot) { create(:snapshot) }
    let!(:last_snapshot) { create(:snapshot) }

    before do
      get snapshot_path(last_snapshot)
    end

    it 'responds with the correct snapshot' do
      # It'sexpected the response body to include a JSON script element with the snapshot data.
      expected_json_content = last_snapshot.data.to_json
      expect(response.body).to include("var SNAPSHOT_DATA = #{expected_json_content};")
    end

    it 'renders the show template' do
      # To verify that the response body includes expected text that would
      # be found in the 'show' view.
      expect(response.body).to include("Postmark Full Stack Test Project")
    end

    it 'renders the show template' do
      # To verify that the response body includes expected text that would
      # be found in the 'show' view.
      expect(response.body).to include("The Big Postmark Graph")
    end
  end
end
