require "socket"
require "eventmachine"
module EventMachine
  module Protocols
    class TestConnection < Connection
      def self.start(host, port)
        @@port = port
        EM.start_server(host, port, self)
      end

      def receive_data(data)
        sleep $1.to_f if data =~ /^sleep (.*)/
        send_data("HTTP/1.1 200/OK\r\n\r\n#{data}")
        close_connection_after_writing
      end
    end
  end
end

module HttpEchoServer
  def start(port)
    ppid = Process.pid
    fork do
      harikari(ppid)
      EM.run do
        EventMachine::Protocols::TestConnection.start('localhost', port)
      end
    end
  end

private
  
  def harikari(ppid)
    Thread.new do
      loop do
        begin
          Process.kill(0, ppid)
        rescue
          exit
        end
        sleep 1
      end
    end
  end
    
  extend self
end