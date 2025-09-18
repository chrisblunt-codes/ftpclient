# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "../src/ftpclient" 

client = FtpClient::Client.new("ftp.dlptest.com")
line = client.connect!
puts line
