module CriteriaOperator
  module UiComponent
    class Engine < ::Rails::Engine
      isolate_namespace CriteriaOperator::UiComponent

      # config.assets.paths << File.expand_path("../../../assets/stylesheets/application", __FILE__)
      # config.assets.paths << File.expand_path("../../../assets/javascripts/application", __FILE__)
    end
  end
end
