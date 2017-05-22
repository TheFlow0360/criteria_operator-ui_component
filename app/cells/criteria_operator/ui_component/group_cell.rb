module CriteriaOperator
  module UiComponent
    class GroupCell < BaseCell

      def show
        render
      end

    private

      def empty?
        !model.kind_of?(GroupOperator) || model.operand_collection.empty?
      end

    end
  end
end