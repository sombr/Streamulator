#!/usr/bin/env ruby
require_relative "lib/streamulator"
include Streamulator::Events

class Pumper < Streamulator::Runnable::Process
  def main
    debug("#{self.pid} - start main")
    delay 10
    debug("#{self.pid} - some hard work")
    delay (rand * 100)
    debug("#{self.pid} - hard work is done!")
    delay 15
    debug("#{self.pid} - end main")
  end
end

Pumper.new.run
Pumper.new.run
Pumper.new.run
Pumper.new.run

run!
