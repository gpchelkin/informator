require 'clockwork'
require './config/boot.rb'
require './config/environment.rb'

module Clockwork
  every(5.minutes, 'FeedsUpdate') {FeedsUpdateJob.set(wait: 10.seconds).perform_later('Test_Action')}
end