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

      def group_row(options = {})
        @allow_delete = options.has_key?(:allow_delete) ? options[:allow_delete] : true
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

