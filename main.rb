require 'open3'

require_relative 'api'

threads = []

# connect to api
client = HABMC::Client.new ENV['HABMC_KEY']

if false
  # get mission
  mission = nil

  while mission.nil?
    puts 'Which mission is this a livestream for?'
    mission_number = gets

    mission = client.find_mission_by_number mission_number.strip

    if mission.nil?
      puts "Sorry, we couldn't find a mission with that number\n"
    end

  end

  # notify HABMC of upcoming livestream
  threads << Thread.new do
    sleep 10 # wait for stream to start

    client.video_started_for mission.id
  end
end


# start the stream

command = [
    'ffmpeg',
    '-f avfoundation -s 1024x720 -i :0.0+0,0 -f 0:0 -framerate 30',
    '-f avfoundation -ac 1 -i default',
    '-vcodec libx264 -pix_fmt yuv420p -preset veryfast -b:v 1500k -g 60',
    '-acodec libmp3lame -ar 44100 -threads 0 -bufsize 3000k',
    "-f flv #{client.livestream_url}/#{client.livestream_key}"
].join ' '

puts command

`#{command}`

# Open3.popen3(command) do |stdout, stderr, status, thread|
#   threads << Thread.new do
#     while line = stdout.gets
#       puts line
#     end
#   end
#
#   threads << Thread.new do
#     while line = stderr.gets
#       puts line
#     end
#   end
# end

# wait for any other threads to finish
threads.map(&:join)
