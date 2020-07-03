require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/unit'
require 'mocha/minitest'

Minitest::Reporters.use!

require 'coveralls'
Coveralls.wear!
