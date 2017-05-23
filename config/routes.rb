CriteriaOperator::UiComponent::Engine.routes.draw do
  post 'create_expression', controller: :ajax, action: :create_expression
  post 'create_group', controller: :ajax, action: :create_group
  post 'delete_element', controller: :ajax, action: :delete_element
  post 'operand_change', controller: :ajax, action: :operand_change
  post 'operator_type_change', controller: :ajax, action: :operator_type_change
end
