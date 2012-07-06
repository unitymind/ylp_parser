module Yelp
  class Engine < ::Rails::Engine
    isolate_namespace Yelp

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
  end
end
