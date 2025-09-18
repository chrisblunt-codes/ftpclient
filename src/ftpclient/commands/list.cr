# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.
require "socket"


module FtpClient
  module Commands
    module List
      def list_directory : String
        ip, port = enter_passive_mode

        send_line("LIST")

        listing = read_data_connection(ip, port)
        listing

        line = read_line
        if ok?(line)
          listing
        else
          raise ProtocolError.new("Failed to parse LIST response (#{line})")
        end
      end
    end
  end
end

class FtpClient::Client
  include FtpClient::Commands::List
end