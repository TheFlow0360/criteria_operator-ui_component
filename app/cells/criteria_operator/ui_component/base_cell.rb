require 'cell'
require 'cell/erb'

module CriteriaOperator
  module UiComponent
    class BaseCell < Cell::ViewModel
      include Cell::Erb

      self.view_paths << "#{CriteriaOperator::UiComponent::Engine.root}/app/cells"

    end
  end
end