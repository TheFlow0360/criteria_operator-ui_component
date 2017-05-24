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

      def operator_type
        if model.kind_of? GroupOperator
          model.operator_type
        elsif model_negated_group?
          model.operand.operator_type * -1
        else
          0
        end
      end

      def operators
        ops = []
        ops << { value: GroupOperatorType::AND, text: 'AND' }
        ops << { value: GroupOperatorType::OR, text: 'OR' }
        ops << { value: -1 * GroupOperatorType::AND, text: 'NAND' }
        ops << { value: -1 * GroupOperatorType::OR, text: 'NOR' }
        ops
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