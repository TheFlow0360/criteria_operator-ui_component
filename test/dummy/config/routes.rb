Rails.application.routes.draw do
  mount CriteriaOperator::UiComponent::Engine => "/criteria_operator-ui_component"

  root "dummy#show"
end
