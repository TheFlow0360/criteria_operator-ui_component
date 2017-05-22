module CriteriaOperator
  module UiComponent
    class ExpressionCell < BaseCell

      def show(options = {})
        @locator = options.has_key?(:locator) ? options[:locator] : ''
        render
      end

      private

      def property_name
        if model.kind_of?(BinaryOperator) && model.left_operand.kind_of?(OperandProperty)
          model.left_operand.property_name
        else
          ''
        end
      end

      def value
        if model.kind_of?(BinaryOperator) && model.right_operand.kind_of?(OperandValue)
          model.right_operand.value
        else
          ''
        end
      end

      def operator
        if model.kind_of?(BinaryOperator)
          case model.operator_type
          when BinaryOperatorType::EQUAL
            'equal to'
          when BinaryOperatorType::NOT_EQUAL
            'not equal to'
          when BinaryOperatorType::GREATER
            'greater than'
          when BinaryOperatorType::GREATER_OR_EQUAL
            'greater than or equal to'
          when BinaryOperatorType::LESS
            'less than'
          when BinaryOperatorType::LESS_OR_EQUAL
            'less than or equal to'
          end
        end
      end
    end
  end
end