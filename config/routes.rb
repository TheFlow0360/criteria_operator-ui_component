CriteriaOperator::UiComponent::Engine.routes.draw do
  post 'create_expression', controller: :ajax, action: :create_expression
  post 'create_group', controller: :ajax, action: :create_group
  post 'delete_element', controller: :ajax, action: :delete_element
end
