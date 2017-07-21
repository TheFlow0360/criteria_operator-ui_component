require 'yaml'

module CriteriaOperator
  module UiComponent
    class CriteriaEditorCell < BaseCell

      def show(options = {})
        @input_id = options[:id] if options.has_key? :id
        @input_name = options[:name] if options.has_key? :name
        # TODO: provide support for read_only
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

      def input_id
        @input_id
      end

      def input_name
        @input_name
      end

      def serialized_operator
        YAML.dump(model) if model.is_a? BaseOperator
      end
    end
  end
end

