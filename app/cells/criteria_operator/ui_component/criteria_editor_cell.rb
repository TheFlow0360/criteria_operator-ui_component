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
        if model.kind_of? GroupOperator
          @group = model
        elsif model.kind_of?(UnaryOperator) && (model.operator_type == UnaryOperatorType::NOT) && model.operand.kind_of?(GroupOperator)
          @group = model.operand
        else
          @group = nil
        end
        render
      end

      def expression_row(options = {})
        @locator = options.has_key?(:locator) ? options[:locator] : ''
        if model.kind_of? BinaryOperator
          @expression = model
        else
          @expression = nil
        end
        render
      end

      def choose_template(options = {})
        if model.kind_of? BinaryOperator
          expression_row options
        else
          group_row options
        end
      end

      private

      def test
        "abcdefg " + model.inspect
      end

      def caption
        if model.kind_of? GroupOperator
          case model.operator_type
          when GroupOperatorType::AND
            'AND'
          when GroupOperatorType::OR
            'OR'
          else
            'Invalid Group Operator!'
          end
        end
      end

      def serialized_operator
        YAML.dump(model) if model.is_a? BaseOperator
      end
    end
  end
end

