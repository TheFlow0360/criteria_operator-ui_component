class DummyController < ApplicationController
  def show
    @whatever = 42
    # CriteriaOperator::UiComponent::Cell.(@whatever).()
    # render
  end
end