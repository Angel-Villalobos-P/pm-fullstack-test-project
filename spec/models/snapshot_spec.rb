require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  describe '.take' do
    it 'creates a new Snapshot with correct data structure' do
      # Simulated response from Postmark that the test expects to receive
      postmark_response = [
          {:message_id=>"f33e0b9e-b47f-4255-990b-c5a37166fea5", :message_stream=>"outbound", :to=>[{"Email"=>"anything@blackhole.postmarkapp.com", "Name"=>"Daryl Mitchell Jr."}], :cc=>[], :bcc=>[], :recipients=>["anything@blackhole.postmarkapp.com"], :received_at=>"2024-02-21T16:45:06-05:00", :from=>"\"Mr. Adam O'Connell\" <anything@blackhole.postmarkapp.com>", :subject=>"Billing", :attachments=>[], :status=>"Sent", :track_opens=>false, :track_links=>"None", :metadata=>{}, :sandboxed=>false},
          {:message_id=>"f6f1032d-49c0-4cf7-bc11-f91ded1bb28e", :message_stream=>"outbound", :to=>[{"Email"=>"anything@blackhole.postmarkapp.com", "Name"=>"Mckinley Abbott"}], :cc=>[], :bcc=>[], :recipients=>["anything@blackhole.postmarkapp.com"], :received_at=>"2024-02-21T16:45:06-05:00", :from=>"\"Lavern Heaney\" <anything@blackhole.postmarkapp.com>", :subject=>"Billing", :attachments=>[], :status=>"Sent", :track_opens=>false, :track_links=>"None", :metadata=>{}, :sandboxed=>false},
          {:message_id=>"f6ee3b25-2a4b-4a9b-bc95-051729c5c070", :message_stream=>"outbound", :to=>[{"Email"=>"anything@blackhole.postmarkapp.com", "Name"=>"Kendrick Johnson"}], :cc=>[], :bcc=>[], :recipients=>["anything@blackhole.postmarkapp.com"], :received_at=>"2024-02-21T16:45:06-05:00", :from=>"\"Lavern Heaney\" <anything@blackhole.postmarkapp.com>", :subject=>"Beanstalk", :attachments=>[], :status=>"Sent", :track_opens=>false, :track_links=>"None", :metadata=>{}, :sandboxed=>false},
          {:message_id=>"f39e3d4f-ed62-4203-8fb3-1bb2cfad4de9", :message_stream=>"outbound", :to=>[{"Email"=>"anything@blackhole.postmarkapp.com", "Name"=>"Lavern Heaney"}], :cc=>[], :bcc=>[], :recipients=>["anything@blackhole.postmarkapp.com"], :received_at=>"2024-02-21T16:45:06-05:00", :from=>"\"Mrs. Johanne Dickens\" <anything@blackhole.postmarkapp.com>", :subject=>"Billing", :attachments=>[], :status=>"Sent", :track_opens=>false, :track_links=>"None", :metadata=>{}, :sandboxed=>false},
          {:message_id=>"f33e0b9e-b47f-4255-990b-c5a37166fea5", :message_stream=>"outbound", :to=>[{"Email"=>"anything@blackhole.postmarkapp.com", "Name"=>"Daryl Mitchell Jr."}], :cc=>[], :bcc=>[], :recipients=>["anything@blackhole.postmarkapp.com"], :received_at=>"2024-02-21T16:45:06-05:00", :from=>"\"Mr. Adam O'Connell\" <anything@blackhole.postmarkapp.com>", :subject=>"Billing", :attachments=>[], :status=>"Sent", :track_opens=>false, :track_links=>"None", :metadata=>{}, :sandboxed=>false}
        ]

      # This simulates the response from Postmark when calling get_messages
      allow(Postmark::ApiClient).to receive_message_chain(:new, :get_messages).and_return(postmark_response)

      # Call the take method to test
      snapshot = Snapshot.take

      # Snapshot is created and not nil
      expect(snapshot).to be_a(Snapshot)
      expect(snapshot.data).not_to be_nil

      # Expectations reflects the exact data we expect
      expected_nodes = postmark_response.map do |email|
        { "id" => Mail::Address.new(email[:from]).display_name }
      end

      expected_nodes += postmark_response.flat_map do |email|
        email[:to].map do |recipient|
          { "id" => recipient["Name"] }
        end
      end

      expected_links = postmark_response.flat_map do |email|
        email[:to].map do |recipient|
          source, target = [Mail::Address.new(email[:from]).display_name, recipient["Name"]].sort
          {
            "source" => source,
            "target" => target,
            "topics" => email[:subject]
          }
        end
      end

      # Checks that the expected nodes are included
      expected_nodes.uniq.each do |node|
        expect(snapshot.data["nodes"]).to include(node)
      end

      # Checks that the expected links are included
      expected_links.each do |link|
        expect(snapshot.data["links"]).to include(a_hash_including(link))
      end
    end
  end
end
