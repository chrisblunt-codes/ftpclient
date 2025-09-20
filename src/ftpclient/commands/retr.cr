# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "socket"

module FtpClient
  module Commands
    module Retr
      def retr(remote_file : String, local_file : String, resume : Bool = false, timeout : Time::Span = 30.seconds) : Nil
        set_tranfer_type("I") # binary mode

        offset = resume && File.exists?(local_file) ? File.size(local_file) : 0

        resume(offset)
        download_file(remote_file, local_file, resume, offset, timeout)
      end

      private def resume(offset : Int32 | Int64)
        if offset > 0
          send_line "REST #{offset}"
          line = read_line
          unless ok?(line)
            raise ProtocolError.new("Failed to resume transfer (#{line})")
          end
        end
      end

      private def download_file(remote_file : String, local_file : String, resume : Bool = false, offset = Int32 | Int64, timeout : Time::Span =  30.seconds) : Nil
        ip, port = enter_passive_mode

        send_line "RETR #{remote_file}"
        line = read_line
        raise ProtocolError.new("Failed to download file (#{line})") unless ok?(line)

        with_data_connection(ip, port) do |data_sock|
          save_file(remote_file, local_file, offset, data_sock, resume: true)
        end

        if download_ok?(read_line)
          puts "Download complete"
        end

      rescue ex 
        raise DownloadError.new("Data transfer failed (#{ex.message})")
      end

      private def with_data_connection(ip : String, port : Int32, timeout : Time::Span =  30.seconds) : Nil
        data_sock = TCPSocket.new(ip, port, connect_timeout: timeout.to_i)
        data_sock.read_timeout  = @read_timeout
        data_sock.write_timeout = @write_timeout
        yield data_sock
      ensure
        data_sock.try &.close
      end

      private def save_file(remote_file : String, local_file : String,  offset : Int32 | Int64, data_sock : TCPSocket, resume : Bool = false) 
        total_size = get_file_size(remote_file)

        File.open(local_file, resume ? "ab" : "wb") do |file|
          bytes_written = offset
          buffer = Bytes.new(4096)
          while (bytes_read = data_sock.read(buffer)) > 0
            file.write(buffer[0, bytes_read])
            bytes_written += bytes_read
            percentage = (bytes_written * 100 / total_size).to_i
            puts "Downloaded #{bytes_written}/#{total_size} bytes (#{percentage}%)"
            sleep 0.1.seconds
          end
        end
      end

      private def get_file_size(remote_file : String) : Int64
        send_line("SIZE #{remote_file}")
        line = read_line
        if line =~ /^213 (\d+)/
          $1.to_i64
        else
          raise ProtocolError.new("Failed to parse SIZE response (#{line})")
        end
      end

      private def download_ok?(line : String) : Bool
        pp "Download OK?: #{line}"

        if line.starts_with?("226")
          return true
        end

        raise ProtocolError.new("Failed to parse RETR response (#{line})")
      end
    end
  end
end

class FtpClient::Client
  include FtpClient::Commands::Retr
end