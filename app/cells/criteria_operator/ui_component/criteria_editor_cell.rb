module CriteriaOperator
  module UiComponent
    class CriteriaEditorCell < BaseCell

      def show
        render
      end

      def group_row(options = {})
        @allow_delete = options.has_key?(:allow_delete) ? options[:allow_delete] : true
        @group = 42
        render
      end

      def expression_row
        @expression = 42
        render
      end

      private

      def test
        "abcdefg " + model.inspect
      end
    end
  end
end

