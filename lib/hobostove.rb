#!/usr/bin/env ruby

require 'tinder'
require 'active_support/core_ext'
require 'ncurses'
require 'notify'
require 'values'

require 'hobostove/message'
require 'hobostove/message_renderer'

require 'hobostove/configuration'
require 'hobostove/panel'
require 'hobostove/input_panel'
require 'hobostove/user_panel'
require 'hobostove/window'
require 'hobostove/setup'
require 'hobostove/upgrade'
require 'hobostove/room_picker'

module Hobostove
  def self.logger
    @logger ||= Logger.new(Configuration.log_file, 1, 1024000)
  end
end
