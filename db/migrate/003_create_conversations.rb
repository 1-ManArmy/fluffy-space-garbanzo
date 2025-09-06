class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :agent, null: false, foreign_key: true, type: :uuid
      t.string :session_id
      t.string :title
      t.json :context, default: {}
      t.json :metadata, default: {}
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps

      # Composite indexes for common queries
      t.index [:user_id, :agent_id, :created_at], name: 'idx_conversations_user_agent_created'
      t.index [:user_id, :created_at], name: 'idx_conversations_user_created'
      t.index [:agent_id, :created_at], name: 'idx_conversations_agent_created'
      t.index :session_id
    end

    # Full-text search on title (using btree index instead of gin_trgm_ops)
    add_index :conversations, :title
  end
end
