module CriteriaOperator
  module UiComponent
    class ExpressionCell < BaseCell

      def show
        render
      end

      private

      def property_name
        ''
      end

      def value
        ''
      end

      def operator
        'equals'
      end
    end
  end
end