# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "socket"

module FtpClient
  class Client

    @socket : TCPSocket?

    def connect(host : String, port : Int32 = 21)
      @socket = TCPSocket.new(host, port)
      puts "Connected to #{host}:#{port}"
    end

    def read_line : String
      response = ""
      loop do
        line = socket!.gets
        break unless line
        response += line + "\n"
        if line =~ /^[0-9]{3} /
          break
        end
      end

      response.strip
    end

    def socket! : TCPSocket
      @socket || raise "Not connected"
    end
  end
end