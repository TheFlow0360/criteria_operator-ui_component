class DummyController < ApplicationController
  def show
    @whatever = 42

    render { CriteriaOperator::UiComponent::CriteriaEditorCell.(@whatever).() }
  end
end