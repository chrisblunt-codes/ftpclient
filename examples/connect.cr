# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "../src/ftpclient"

client = FtpClient::Client.new
client.connect("ftp.dlptest.com")
response = client.read_line
puts response
