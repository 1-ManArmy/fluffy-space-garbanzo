class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs, id: :uuid do |t|
      t.references :user, null: true, foreign_key: true, type: :uuid
      t.string :action, null: false
      t.string :resource_type
      t.string :resource_id
      t.json :changes, default: {}
      t.string :ip_address
      t.string :user_agent
      t.json :metadata, default: {}
      t.timestamps

      # Indexes for audit log queries
      t.index [:user_id, :created_at], name: 'idx_audit_logs_user_created'
      t.index [:action, :created_at], name: 'idx_audit_logs_action_created'
      t.index [:resource_type, :resource_id], name: 'idx_audit_logs_resource'
      t.index :created_at
    end

    # Partition table by month for performance (optional, for large datasets)
    # execute "SELECT create_monthly_partition('audit_logs', 'created_at');"
  end
end
