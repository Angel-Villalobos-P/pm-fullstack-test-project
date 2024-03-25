require 'rails_helper'

RSpec.feature "User views the last snapshot", type: :feature, js: true do
  scenario "User visits the snapshot show page" do
    # Create a snapshot with the factory data
    snapshot = create(:snapshot)

    # Visit the route that shows the last snapshot.
    visit snapshot_path(snapshot)

    # Retrieve the SNAPSHOT_DATA from the JavaScript environment of the page.
    snapshot_data_from_page = page.evaluate_script('SNAPSHOT_DATA')
    
    # Parse the JSON data from the `snapshot.data` for comparison.
    expected_data = JSON.parse(snapshot.data.to_json)

    # Compare the retrieved SNAPSHOT_DATA with the data set by the factory.
    expect(snapshot_data_from_page).to eq(expected_data)
  end
end
