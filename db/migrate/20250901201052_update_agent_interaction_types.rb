class UpdateAgentInteractionTypes < ActiveRecord::Migration[7.1]
  def up
    # Remove the old constraint
    remove_check_constraint :agent_interactions, name: "interactions_type_check"
    
    # Add the new constraint with additional types (without validation)
    add_check_constraint :agent_interactions, 
      "interaction_type IN ('chat', 'function_call', 'error', 'system', 'conversation_start', 'conversation_end')", 
      name: "interactions_type_check",
      validate: false
  end
  
  def down
    # Remove the new constraint
    remove_check_constraint :agent_interactions, name: "interactions_type_check"
    
    # Add back the old constraint
    add_check_constraint :agent_interactions, 
      "interaction_type IN ('chat', 'function_call', 'error', 'system')", 
      name: "interactions_type_check"
  end
end
