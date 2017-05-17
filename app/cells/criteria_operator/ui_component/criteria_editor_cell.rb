require 'cell'
require 'cell/erb'

module CriteriaOperator
  module UiComponent
    class CriteriaEditorCell < Cell::ViewModel
      include Cell::Erb

      self.view_paths << "#{CriteriaOperator::UiComponent::Engine.root}/app/cells"

      def show
        render
      end

      def group_row
        render
      end

      def expression_row
        render
      end

      private

      def test
        "abcdefg " + model.inspect
      end
    end
  end
end

