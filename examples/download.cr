# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

require "../src/ftpclient"
require "../src/ftpclient/errors"

USERNAME    = "test"
PASSWORD    = "secret"
SERVER      = "127.0.0.1"
PORT        = 2000
FILENAME    = "test.zip"

client = FtpClient::Client.new(SERVER, PORT)

begin
  client.connect!
  client.login!(USERNAME, PASSWORD)
  client.retr(remote_file: FILENAME, local_file: "~/Downloads/#{FILENAME}", resume: true)
rescue ex : FtpClient::DownloadError
  puts "ERROR: #{ex.message}"
ensure
  client.close
end