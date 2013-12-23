require_relative "lib/streamulator"
include Streamulator::Events

Fiber.new do delay 2; Streamulator::Source::File.new("file1").read(50); end.resume
Fiber.new do delay 3; Streamulator::Source::File.new("file2").read(45); end.resume
Fiber.new do delay 4; Streamulator::Source::File.new("file3").read(40); end.resume
Fiber.new do delay 5; Streamulator::Source::File.new("file4").read(35); end.resume
Fiber.new do delay 6; Streamulator::Source::File.new("file5").read(30); end.resume
Fiber.new do delay 7; Streamulator::Source::File.new("file6").read(25); end.resume
Fiber.new do delay 8; Streamulator::Source::File.new("file7").read(20); end.resume
Fiber.new do delay 9; Streamulator::Source::File.new("file8").read(15); end.resume

run!
