require_dependency "criteria_operator/ui_component/application_controller"
require 'cell'
require 'cell/erb'
require 'yaml'

module CriteriaOperator
  module UiComponent
    class AjaxController < ApplicationController
      def create_expression
        return unless ajax_params.has_key? :value
        root_operator = root_op_from_params
        operator = BinaryOperator.new
        html = CriteriaEditorCell.call(operator).call(:expression_row, locator: new_locator)
        render json: { html: html, operator: YAML.dump(root_operator) }
      end

      def create_group
        return unless ajax_params.has_key? :value
        root_operator = root_op_from_params
        operator = GroupOperator.new
        html = CriteriaEditorCell.call(operator).call(:group_row, locator: new_locator)
        render json: { html: html, operator: YAML.dump(root_operator) }
      end

      private

      def ajax_params
        params.permit :value, :locator, :child_count
      end

      def root_op_from_params
        YAML.safe_load ajax_params[:value], (ObjectSpace.each_object(Class).select { |klass| klass < BaseOperator })
      end

      def new_locator
        if ajax_params.has_key? :child_count
          ajax_params[:child_count].to_s
        else
          '0'
        end
      end
    end
  end
end
