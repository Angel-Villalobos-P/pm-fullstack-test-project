require 'mail'

class Snapshot < ApplicationRecord
  serialize :data, coder: JSON

  def self.take
    connection = Postmark::ApiClient.new(Rails.application.config.x.postmark.api_token)

    messages = connection.get_messages(count: 500, offset: 0)
    
    data = build_graph_structure(messages)

    Snapshot.new(data: data)
  end

  def self.build_graph_structure(messages)
    users = Set.new
    links = []
    links_index = {}

    messages.each do |message|
      sender_name = extract_display_name(message[:from])
      add_users(users, sender_name)

      message[:to].each do |recipient|
        recipient_name = recipient['Name']
        add_users(users, recipient_name)

        link_key = [sender_name, recipient_name].sort.join('|')
        add_topic_to_link(links_index, link_key, message[:subject])
      end
    end

    links = build_links_from_index(links_index)
    
    { nodes: users, links: links }
  end
  

  # Helpers for building graph structure

  def self.extract_display_name(address_string)
    Mail::Address.new(address_string).display_name
  end

  def self.extract_email(email_with_name)
    Mail::Address.new(email_with_name).address
  end

  def self.add_users(users, recipient_name)
    users << { id: recipient_name } unless users.any? { |user| user[:id] == recipient_name }
  end

  def self.add_topic_to_link(links_index, link_key, topic)
    links_index[link_key] ||= []
    links_index[link_key] << topic
  end

  def self.build_links_from_index(links_index)
    links_index.map do |id, topics|
      source, target = id.split('|')
      {
        source: source,
        target: target,
        topics: topics.uniq.join(', ')
      }
    end
  end
end
