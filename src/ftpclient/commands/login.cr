# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.
require "socket"

enum LoginResult
  Success
  PasswordRequired
  Failed
end

module FtpClient
  module Commands
    module Login
      def login(username : String, password : String = "") : LoginResult
        send_line "USER #{username}"
        line = read_line

        return LoginResult::Success if logged_in?(line)

        if password_required?(line)
          return LoginResult::PasswordRequired if password.empty?
          send_line "PASS #{password}"
          line = read_line
          return logged_in?(line) ? LoginResult::Success : LoginResult::Failed
        end

        LoginResult::Failed
      end

      def login_successful?(username : String, password : String = "") : Bool
        login(username, password) == LoginResult::Success
      end

      def login!(username : String, password : String = "") Nil
        result =  login(username, password)
        return if result == LoginResult::Success
        raise LoginError.new("Login failed (#{result})")
      end

      private def logged_in?(line : String) : Bool
        line.starts_with?("230")
      end

      private def password_required?(line : String) : Bool
        line.starts_with?("331")
      end
    end
  end
end

class FtpClient::Client
  include FtpClient::Commands::Login
end
