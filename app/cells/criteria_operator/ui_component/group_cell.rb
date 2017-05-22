module CriteriaOperator
  module UiComponent
    class GroupCell < BaseCell

      def show(options = {})
        @allow_delete = options.has_key?(:allow_delete) ? options[:allow_delete] : true
        @locator = options.has_key?(:locator) ? options[:locator] : ''
        if model.kind_of? GroupOperator
          @group = model
        elsif model_negated_group?
          @group = model.operand
        else
          @group = nil
        end
        render
      end

    private

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
        elsif model_negated_group?
          case model.operand.operator_type
          when GroupOperatorType::AND
            'NAND'
          when GroupOperatorType::OR
            'NOR'
          else
            'Invalid Group Operator!'
          end
        end
      end

      def empty?
        !@group.kind_of?(GroupOperator) || @group.operand_collection.empty?
      end

      def model_negated_group?
        model.kind_of?(UnaryOperator) && (model.operator_type == UnaryOperatorType::NOT) && model.operand.kind_of?(GroupOperator)
      end

    end
  end
end