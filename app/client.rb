require_relative 'hash_pathing'
require 'em-websocket-client'
require 'socket'
require 'json'

class Client
  # return hostname
  def self.get_hostname
    Socket.gethostname
  end
  # return ip address
  def self.get_ipaddress
    Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address
  end
end
# Web socket client class
class IpClient
  def initialize(server)
    # Create connection via Websocket
    @server = server
    @current_ip = Client.get_ipaddress
    @current_name = Client.get_hostname
    @conn = EventMachine::WebSocketClient.connect @server
    # send message after connect
    @conn.callback do
      send_new
    end

    @conn.errback do |e|
      puts "Got error: #{e}"
    end
    # get incoming message
    @conn.stream do |msg|
      incoming_message msg.data
    end
    # reconnect to server after 10 second
    @conn.disconnect do
      sleep 10
      @conn = nil
      reconnect @server
    end
    # every 30 second send 'online' message to server and get new tasks after that
    @timer = EventMachine.add_periodic_timer 30 do
      ip = Client.get_ipaddress
      send_change_ip ip unless @current_ip == ip
      send_online
    end
  end
  # parse incoming message
  def incoming_message msg
    data = JSON(msg).symbolize_keys
    if data[:type] == 'task'
      result = run_command data[:data]
      send_result result, data[:task_id]
    elsif data[:type] == 'close'
      @conn.close_connection
    end
  end
  # run command from tash and return hash with result
  def run_command(command)
    time_start = Time.now
    begin
      result = `#{ command }`
    rescue
      result = 'Get an error when try to run command'
    end
    time_finished = Time.now
    duration = time_finished - time_start
    { start_time: time_start, finished_time: time_finished, duration: duration, result: result }
  end
  # reconnect to server
  def reconnect(server)
    @timer.cancel
    IpClient.new server
  end
  # send new message
  def send_new
    @conn.send_msg ({ :type => 'new', :client => @current_name, :ip => @current_ip }.to_json)
  end
  # send online message
  def send_online
    @conn.send_msg({ :type => 'online', :client => @current_name, :ip => @current_ip }.to_json)
  end
  # send result message
  def send_result(result, task_id)
    @conn.send_msg({ type: 'result', :client => @current_name, :ip => @current_ip, result: result[:result],  task_id: task_id, duration: result[:duration], start_time: result[:start_time], finished_time: result[:finished_time]  }.to_json)
  end
  # send message if ip changed to new
  def send_change_ip(new_ip)
    @conn.send_msg({ :type => 'change_ip', :client => @current_name, :ip_old => @current_ip, :ip_new => new_ip }.to_json)
    @current_ip == new_ip
  end
end

EM.run do

  options = Hash[*ARGV]
  IP = options['-i']
  PORT = options['-p']
  # TODO: implement checking of incoming options
  SERVER = "ws://#{IP}:#{PORT}"
  IpClient.new SERVER
end