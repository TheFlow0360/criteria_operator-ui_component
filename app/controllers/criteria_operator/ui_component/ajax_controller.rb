require_dependency "criteria_operator/ui_component/application_controller"
require 'cell'
require 'cell/erb'

module CriteriaOperator
  module UiComponent
    class AjaxController < ApplicationController
      def create_expression
        operator = 42
        html = CriteriaEditorCell.call(operator).call(:expression_row)
        render json: { html: html }
      end

      def create_group
        operator = 42
        html = CriteriaEditorCell.call(operator).call(:group_row)
        render json: { html: html }
      end
    end
  end
end
