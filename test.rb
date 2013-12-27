#!/usr/bin/env ruby
require_relative "lib/streamulator"
include Streamulator::Events

r = Streams::Storage::RoundRobin.new( name: "rr" )

pumper = Streamulator::Runnable::Pumper.new(
  :in  => array_in( (1..10000).map { |l| { :id => l, :size => 1024*2 + Integer(rand * 512) } } ),
  :out => r,
  :filter => filter { |line|
    delay 5 + 5*rand(10)
    line
  },
  :commit_step => 100
)
pumper.run

c = r.in("test")
llag = 0
pumper1 = Streamulator::Runnable::Pumper.new(
  :in => c,
  :out => code_out { |line|
    unless llag == c.lag
      debug("[test] lag: #{c.lag}")
      llag = c.lag
    end
    delay 500
  }
)
pumper1.run

run!(300000)
