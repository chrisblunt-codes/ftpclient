# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "../src/ftpclient" 

USERNAME    = "test"
PASSWORD    = "secret"
SERVER      = "127.0.0.1"
PORT        = 2000

client = FtpClient::Client.new(SERVER, PORT)
line = client.connect!
puts line
