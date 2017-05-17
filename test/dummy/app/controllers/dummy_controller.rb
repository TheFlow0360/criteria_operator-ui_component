class DummyController < ApplicationController
  def show
    first_op = CriteriaOperator::UnaryOperator.new(CriteriaOperator::OperandValue.new(true), CriteriaOperator::UnaryOperatorType::NOT)
    second_op = CriteriaOperator::BinaryOperator.new(CriteriaOperator::OperandProperty.new("column xyz"), CriteriaOperator::OperandValue.new(42), CriteriaOperator::BinaryOperatorType::GREATER_OR_EQUAL)
    @example_op = CriteriaOperator::GroupOperator.new [first_op, second_op], CriteriaOperator::GroupOperatorType::OR
    @cell_obj = CriteriaOperator::UiComponent::CriteriaEditorCell.(@example_op)
    render
  end
end