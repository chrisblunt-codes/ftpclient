# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.


require "socket"

require "./commands/**"

module FtpClient
  class Client

    @socket : TCPSocket?

    def initialize(@host : String, @port : Int32 = 21)
      @read_timeout   = 30.seconds
      @write_timeout  = 30.seconds
    end

    def connect! : String
      @socket = TCPSocket.new(@host, @port)
      socket!.read_timeout  = @read_timeout
      socket!.write_timeout = @write_timeout

      line = read_line
      unless ok?(line)
        close
        raise ProtocolError.new("Server did not respond with 220 message")
      end

      line
    rescue ex
      raise ConnectionError.new("Connection failed #{ex.message}")
    end

    def read_line : String
      line = socket!.gets
      line ||= ""
      line.strip
    end

    def send_line(line : String) : Nil
      sock = socket!
      sock << line << "\r\n"
      sock.flush
    end

    def socket! : TCPSocket
      @socket || raise "Not connected"
    end

    def ok?(line : String) : Bool
      return true if line.starts_with? "350"
      return true if line.starts_with? "331"
      return true if line.starts_with? "2"
      return true if line.starts_with? "150"
      return true if line.starts_with? "125"

      false
    end

    def enter_passive_mode : Tuple(String, Int32)
      send_line("PASV")
      line = read_line

      # Extract IP and port from response like "227 Entering Passive Mode (192,168,1,1,195,133)"
      if match = line.match(/\((\d+),(\d+),(\d+),(\d+),(\d+),(\d+)\)/)
        ip   = "#{match[1]}.#{match[2]}.#{match[3]}.#{match[4]}"
        port = match[5].to_i * 256 + match[6].to_i
        {ip, port}
      else
        raise ProtocolError.new("Failed to parse PASV response (#{line})")
      end
    end

    def close
      @socket.try &.close
    end

    private def read_data_connection(host : String, port : Int32, timeout : Time::Span =  30.seconds) : String
      io = IO::Memory.new

      data_sock = TCPSocket.new(host, port, connect_timeout: timeout.to_i)
      data_sock.read_timeout  = @read_timeout
      data_sock.write_timeout = @write_timeout

      while line = data_sock.gets
        io << line << "\r\n"
      end

      io.to_s.strip
    rescue ex
      raise DataTransferError.new("Data transfer failed #{ex.message}")
    ensure
      data_sock.try &.close
    end
  end
end