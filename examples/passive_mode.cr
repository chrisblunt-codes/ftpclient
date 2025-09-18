# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "../src/ftpclient"

USERNAME = "dlpuser"
PASSWORD = "rNrKYTX9g7z3RgJRmxWuGHbeu"

client = FtpClient::Client.new("ftp.dlptest.com")
client.connect!
client.login!(USERNAME, PASSWORD)
ip, port = client.enter_passive_mode
client.close

puts "Passsive Mode: #{ip}:#{port}"

