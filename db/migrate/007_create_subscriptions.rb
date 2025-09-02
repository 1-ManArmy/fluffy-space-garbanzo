class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :stripe_subscription_id, index: { unique: true }
      t.string :stripe_customer_id
      t.string :lemon_squeezy_subscription_id, index: { unique: true }
      t.string :paypal_subscription_id, index: { unique: true }
      t.string :payment_provider, null: false, default: 'stripe'
      t.string :plan_name, null: false
      t.string :status, null: false
      t.decimal :amount, precision: 10, scale: 2
      t.string :currency, default: 'USD', null: false
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.datetime :canceled_at
      t.json :metadata, default: {}
      t.timestamps

      # Indexes for subscription management
      t.index [:user_id, :status], name: 'idx_subscriptions_user_status'
      t.index [:status, :current_period_end], name: 'idx_subscriptions_status_period_end'
      t.index :payment_provider
      t.index :plan_name
    end

    # Add constraints
    add_check_constraint :subscriptions, "status IN ('active', 'canceled', 'past_due', 'incomplete', 'trialing')", name: 'subscriptions_status_check'
    add_check_constraint :subscriptions, "payment_provider IN ('stripe', 'lemon_squeezy', 'paypal')", name: 'subscriptions_provider_check'
    add_check_constraint :subscriptions, "amount >= 0", name: 'subscriptions_amount_positive'
    add_check_constraint :subscriptions, "current_period_end > current_period_start", name: 'subscriptions_period_valid'
  end
end
