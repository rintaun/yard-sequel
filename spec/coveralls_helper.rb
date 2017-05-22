if ENV['SIMPLECOV'] == 'true'
  require 'simplecov'
  SimpleCov.start
else
  require 'coveralls'
  Coveralls.wear!
end
