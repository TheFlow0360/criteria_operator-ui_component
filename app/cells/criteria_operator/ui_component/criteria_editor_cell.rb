require 'yaml'

module CriteriaOperator
  module UiComponent
    class CriteriaEditorCell < BaseCell

      def show
        render
      end

      def choose_template(options = {})
        if model.kind_of? BinaryOperator
          ExpressionCell.call(model).call(:show, options)
        else
          GroupCell.call(model).call(:show, options)
        end
      end

      private

      def serialized_operator
        YAML.dump(model) if model.is_a? BaseOperator
      end
    end
  end
end

