# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "../src/ftpclient"

USERNAME = "dlpuser"
PASSWORD = "rNrKYTX9g7z3RgJRmxWuGHbeu"

client = FtpClient::Client.new("ftp.dlptest.com")
client.connect!

# Example 1
if client.login_successful?(USERNAME, PASSWORD)
  puts "Login successful"
else
  puts "Login failed"
end

# Example 2
if client.login(USERNAME, PASSWORD) == LoginResult::Success
  puts "Login successful"
else
  puts "Login failed"
end

# Example 3
begin
  client.login!(USERNAME, PASSWORD)
  puts "Login successful"
rescue FtpClient::LoginError
  puts "Login failed"
end
