class ValidateAgentInteractionTypes < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :agent_interactions, name: "interactions_type_check"
  end
end
