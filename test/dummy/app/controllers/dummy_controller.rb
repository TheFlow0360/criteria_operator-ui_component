class DummyController < ApplicationController
  def show
    first_op = CriteriaOperator::UnaryOperator.new(CriteriaOperator::GroupOperator.new([], CriteriaOperator::GroupOperatorType::AND), CriteriaOperator::UnaryOperatorType::NOT)
    second_op = CriteriaOperator::BinaryOperator.new(CriteriaOperator::OperandProperty.new("column xyz"), CriteriaOperator::OperandValue.new(42), CriteriaOperator::BinaryOperatorType::GREATER_OR_EQUAL)
    @example_op = CriteriaOperator::UnaryOperator.new(CriteriaOperator::GroupOperator.new([first_op, second_op], CriteriaOperator::GroupOperatorType::OR), CriteriaOperator::UnaryOperatorType::NOT)
    # @example_op = CriteriaOperator::GroupOperator.new [], CriteriaOperator::GroupOperatorType::OR
    render
  end
end