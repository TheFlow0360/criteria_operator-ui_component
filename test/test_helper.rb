$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '../test'
  add_filter '../bin'
  add_filter 'criteria_operator/ui_component/version'
end

require 'criteria_operator-ui_component'

require 'minitest/autorun'
require 'minitest/reporters'

MiniTest::Reporters.use!
