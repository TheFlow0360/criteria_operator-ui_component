require 'yaml'

module CriteriaOperator
  module UiComponent
    class CriteriaEditorCell < BaseCell

      def show
        render
      end

      def group_row(options = {})
        @allow_delete = options.has_key?(:allow_delete) ? options[:allow_delete] : true
        @locator = options.has_key?(:locator) ? options[:locator] : ''
        @group = 42
        render
      end

      def expression_row(options = {})
        @locator = options.has_key?(:locator) ? options[:locator] : ''
        @expression = 42
        render
      end

      private

      def test
        "abcdefg " + model.inspect
      end

      def serialized_operator
        YAML.dump(model) if model.is_a? BaseOperator
      end
    end
  end
end

