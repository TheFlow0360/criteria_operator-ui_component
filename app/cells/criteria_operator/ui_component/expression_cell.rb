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

      def operator_type
        if model.kind_of?(BinaryOperator)
          model.operator_type
        else
          0
        end
      end

      def operators
        ops = []
        ops << { value: BinaryOperatorType::EQUAL, text: 'equal to' }
        ops << { value: BinaryOperatorType::NOT_EQUAL, text: 'not equal to' }
        ops << { value: BinaryOperatorType::GREATER, text: 'greater than' }
        ops << { value: BinaryOperatorType::GREATER_OR_EQUAL, text: 'greater than or equal to' }
        ops << { value: BinaryOperatorType::LESS, text: 'less than' }
        ops << { value: BinaryOperatorType::LESS_OR_EQUAL, text: 'less than or equal to' }
        ops
      end
    end
  end
end