module CriteriaOperator
  module UiComponent
    class Engine < ::Rails::Engine
      require 'jquery-rails'
      require 'criteria_operator'
      isolate_namespace CriteriaOperator::UiComponent

      config.assets.paths << File.expand_path("../../../app/assets/stylesheets/application", __FILE__)
      config.assets.paths << File.expand_path("../../../app/assets/javascripts/application", __FILE__)
    end
  end
end
