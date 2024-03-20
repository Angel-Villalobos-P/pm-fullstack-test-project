desc 'Take a snapshot of in-app communications using the Postmark Messages API'
namespace :snapshot do
  task take: :environment do
    snapshot = Snapshot.take
    if snapshot.save
      puts "Snapshot saved successfully!"
    else
      puts "Failed to save snapshot: #{snapshot.errors.full_messages.join(", ")}"
    end
  end
end
