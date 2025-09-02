class CreateUsageMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :usage_metrics, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :agent, null: true, foreign_key: true, type: :uuid
      t.date :date, null: false
      t.integer :requests_count, default: 0, null: false
      t.integer :tokens_used, default: 0, null: false
      t.float :processing_time_total, default: 0.0, null: false
      t.json :breakdown, default: {}
      t.timestamps

      # Unique constraint for user/date combination
      t.index [:user_id, :date], unique: true, name: 'idx_usage_metrics_user_date_unique'
      t.index [:agent_id, :date], name: 'idx_usage_metrics_agent_date'
      t.index [:date, :requests_count], name: 'idx_usage_metrics_date_requests'
    end

    # Add constraints
    add_check_constraint :usage_metrics, "requests_count >= 0", name: 'usage_metrics_requests_positive'
    add_check_constraint :usage_metrics, "tokens_used >= 0", name: 'usage_metrics_tokens_positive'
    add_check_constraint :usage_metrics, "processing_time_total >= 0", name: 'usage_metrics_processing_time_positive'
  end
end
