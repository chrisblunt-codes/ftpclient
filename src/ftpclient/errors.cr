# Copyright 2025 Chris Blunt
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

module FtpClient
  class ConnectionError   < Exception; end
  class DataTransferError < Exception; end
  class DownloadError     < Exception; end
  class LoginError        < Exception; end
  class ProtocolError     < Exception; end
  class TimeoutError      < Exception; end
end
