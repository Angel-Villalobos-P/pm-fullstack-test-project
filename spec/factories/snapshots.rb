FactoryBot.define do
  factory :snapshot do
    data {{
      nodes: [
          { id: 'John Doe' },
          { id: 'Jane Doe' },
          { id: 'Alice Smith' },
          { id: 'Bob Johnson' }
        ],
      links: [
          { source: 'John Doe', target: 'Jane Doe', topics: 'Hello' },
          { source: 'Alice Smith', target: 'Bob Johnson', topics: 'Greetings' },
          { source: 'John Doe', target: 'Alice Smith', topics: 'How are you?' },
          { source: 'Jane Doe', target: 'Bob Johnson', topics: 'Good morning' }
      ]
        }}
  end
end
