require_dependency "criteria_operator/ui_component/application_controller"
require 'cell'
require 'cell/erb'
require 'yaml'

module CriteriaOperator
  module UiComponent
    class AjaxController < ApplicationController
      def create_expression
        return unless ajax_params.has_key? :root_operator
        root_operator = root_op_from_params
        operator = BinaryOperator.new
        add_sub_operator root_operator, operator, ajax_params[:locator]
        html = ExpressionCell.call(operator).call(:show, locator: new_locator)
        render json: { html: html, operator: YAML.dump(root_operator) }
      end

      def create_group
        return unless ajax_params.has_key? :root_operator
        root_operator = root_op_from_params
        operator = GroupOperator.new
        add_sub_operator root_operator, operator, ajax_params[:locator]
        html = GroupCell.call(operator).call(:show, locator: new_locator)
        render json: { html: html, operator: YAML.dump(root_operator) }
      end

      def delete_element
        return unless (ajax_params.has_key? :root_operator) && (ajax_params.has_key? :locator)
        root_operator = root_op_from_params
        remove_sub_operator root_operator, ajax_params[:locator]
        render json: { operator: YAML.dump(root_operator) }
      end

      def operand_change
        return unless (ajax_params.has_key? :root_operator) && (ajax_params.has_key? :locator)
        root_operator = root_op_from_params
        op = locate_sub_operator root_operator, ajax_params[:locator]
        op.left_operand = OperandProperty.new(ajax_params[:operand_value]) if ajax_params[:operand_type] == 'left'
        op.right_operand = OperandValue.new(ajax_params[:operand_value]) if ajax_params[:operand_type] == 'right'
        render json: { operator: YAML.dump(root_operator) }
      end

      def expression_type_change
        return unless (ajax_params.has_key? :root_operator) && (ajax_params.has_key? :locator)
        root_operator = root_op_from_params
        op = locate_sub_operator root_operator, ajax_params[:locator]
        op.operator_type = ajax_params[:operator_type_value]
        render json: { operator: YAML.dump(root_operator) }
      end

      def group_type_change
        return unless (ajax_params.has_key? :root_operator) && (ajax_params.has_key? :locator)
        root_operator = root_op_from_params
        root_operator = change_sub_group_type root_operator, ajax_params[:locator], ajax_params[:operator_type_value].to_i
        render json: { operator: YAML.dump(root_operator) }
      end

      private

      def ajax_params
        params.permit :root_operator, :locator, :child_count, :operand_type, :operand_value, :operator_type_value
      end

      def root_op_from_params
        BaseOperator.deserialize ajax_params[:root_operator]
      end

      def new_locator
        if ajax_params.has_key? :child_count
          ajax_params[:child_count].to_s
        else
          '0'
        end
      end

      def locate_sub_operator(operator, locator)
        op = get_negated_group_if_exist operator
        locator.split(',').map(&:to_i).each do |pos|
          # TODO: some kind of error handling beside cancelling?
          return nil unless op.is_a? GroupOperator
          op = op.operand_collection[pos]
          op = get_negated_group_if_exist op
        end
        op
      end

      def add_sub_operator(root_op, extend_op, locator)
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
        op = get_negated_group_if_exist op
        op.operand_collection.delete_at pos.to_i
      end

      def change_sub_group_type(root_op, locator, op_type)
        op = root_op
        last_pos = -1
        parent_op = nil
        locator_array = locator.split(',')
        locator_array.map(&:to_i).each do |pos|
          op = get_negated_group_if_exist op
          last_pos = pos
          parent_op = op
          op = op.operand_collection[pos]
        end

        if negation? op
          if op_type > 0
            parent_op.operand_collection[last_pos] = op.operand
            op.operand.operator_type = op_type
          else
            op.operand.operator_type = op_type * -1
          end
        else
          if op_type < 0
            parent_op.operand_collection[last_pos] = UnaryOperator.new op, UnaryOperatorType::NOT
            op.operator_type = op_type * -1
          else
            op.operator_type = op_type
          end
        end
        root_op
      end

      def get_negated_group_if_exist(op)
        if negation? op
          op.operand
        else
          op
        end
      end

      def negation?(op)
        op.is_a?(UnaryOperator) && (op.operator_type == UnaryOperatorType::NOT)
      end
    end
  end
end
