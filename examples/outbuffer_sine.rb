require "coreaudio"

dev = CoreAudio.default_output_device
buf = dev.output_buffer(1024)

phase = Math::PI * 2.0 * 440.0 / dev.nominal_rate
th = Thread.start do
  i = 0
  loop do
    wav = Array.new(1024){|j| (0.4 * Math.sin(phase*(i+j)) * 0x7FFF).round }
    i += 1024
    buf << wav
  end
end

buf.start
sleep 2
buf.stop

puts "#{buf.dropped_frame} frame dropped."

th.kill
