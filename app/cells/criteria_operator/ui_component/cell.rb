module CriteriaOperator
  module UiComponent
    class Cell < Cell::ViewModel
      def show
        render
      end

    private

      def test
        "abcdefg " + model.inspect
      end
    end
  end
end

