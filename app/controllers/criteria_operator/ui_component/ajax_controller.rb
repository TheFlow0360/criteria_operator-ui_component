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
        extend_operator root_operator, operator, ajax_params[:locator]
        html = CriteriaEditorCell.call(operator).call(:expression_row, locator: new_locator)
        render json: { html: html, operator: YAML.dump(root_operator) }
      end

      def create_group
        return unless ajax_params.has_key? :value
        root_operator = root_op_from_params
        operator = GroupOperator.new
        extend_operator root_operator, operator, ajax_params[:locator]
        html = CriteriaEditorCell.call(operator).call(:group_row, locator: new_locator)
        render json: { html: html, operator: YAML.dump(root_operator) }
      end

      def delete_element
        return unless (ajax_params.has_key? :value) && (ajax_params.has_key? :locator)
        root_operator = root_op_from_params
        remove_sub_operator root_operator, ajax_params[:locator]
        render json: { operator: YAML.dump(root_operator) }
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

      def locate_sub_operator(operator, locator)
        op = operator
        locator.split(',').map(&:to_i).each do |pos|
          # TODO: some kind of error handling beside cancelling?
          return nil unless op.is_a? GroupOperator
          op = op.operand_collection[pos]
        end
        op
      end

      def extend_operator(root_op, extend_op, locator)
        op = locate_sub_operator root_op, locator
        op.operand_collection << extend_op
      end

      def remove_sub_operator(root_op, locator)
        locator_array = locator.split(',')
        pos = locator_array.pop
        op = root_op
        unless locator_array.empty?
          op = locate_sub_operator op, locator_array.join(',')
        end
        op.operand_collection.delete_at pos.to_i
      end
    end
  end
end
