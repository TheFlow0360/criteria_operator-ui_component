CriteriaOperator::UiComponent::Engine.routes.draw do
  get 'create_expression', controller: :ajax, action: :create_expression
  get 'create_group', controller: :ajax, action: :create_group
end
