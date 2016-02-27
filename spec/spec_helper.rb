require 'chefspec'
require 'chefspec/berkshelf'

module SpecHelper
  def memoized_runner(recipe)
    @runner ||= begin
      runner = ChefSpec::SoloRunner.new
      runner.converge recipe
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelper
end
