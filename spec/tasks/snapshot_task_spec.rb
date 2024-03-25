# spec/tasks/snapshot_task_spec.rb
require 'rails_helper'

RSpec.describe 'snapshot:take task' do
  it 'creates a snapshot with the correct data' do
    postmark_response = [{:message_id=>"f33e0b9e-b47f-4255-990b-c5a37166fea5", :message_stream=>"outbound", :to=>[{"Email"=>"anything@blackhole.postmarkapp.com", "Name"=>"Daryl Mitchell Jr."}], :cc=>[], :bcc=>[], :recipients=>["anything@blackhole.postmarkapp.com"], :received_at=>"2024-02-21T16:45:06-05:00", :from=>"\"Mr. Adam O'Connell\" <anything@blackhole.postmarkapp.com>", :subject=>"Billing", :attachments=>[], :status=>"Sent", :track_opens=>false, :track_links=>"None", :metadata=>{}, :sandboxed=>false},]
    
    # Prepare the test environment and mock the API responses
    allow(Postmark::ApiClient).to receive_message_chain(:new, :get_messages).and_return(postmark_response)

    # Execute the Rake task
    Rake::Task['snapshot:take'].invoke

    # Verify that a new Snapshot has been created with the expected data    snapshot = Snapshot.last
    snapshot = Snapshot.last
    expect(snapshot).not_to be_nil
    expect(snapshot.data).to include("nodes", "links")
  end
end
