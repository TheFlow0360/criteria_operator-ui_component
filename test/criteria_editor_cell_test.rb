require_relative 'test_helper'

class CriteriaEditorCellTest < Cell::TestCase

  def test_direct_instantiation_html
    html = CriteriaOperator::UiComponent::CriteriaEditorCell.(CriteriaOperator::GroupOperator.new).()
    assert !html.nil?
  end

  def test_helper_html
    html = cell("criteria_operator/ui_component/criteria_editor", CriteriaOperator::GroupOperator.new).()
    assert !html.nil?
  end
end