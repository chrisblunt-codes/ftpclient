[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# ftpclient

A tiny FTP client for Crystal.

## Installation

Add this to your `shard.yml`:

```yaml
dependencies:
  ftpclient:
    github: chrisblunt-codes/ftpclient
```

## Usage

```
begin
  client.connect!
  client.login!(USERNAME, PASSWORD)
  client.retr(remote_file: FILENAME, local_file: "#{DOWNLOAD_DIR}/#{FILENAME}", resume: true)
rescue ex : FtpClient::DownloadError
  puts "ERROR: #{ex.message}"
ensure
  client.close
end
```

## Examples and Local Testing

The `examples/` folder contains code snippets demonstrating how to use the main features of this library (connect, login, download, etc.).

For local testing, you can spin up a simple FTP server using [pyftpdlib](https://github.com/giampaolo/pyftpdlib):

```
pip install pyftpdlib
python3 -m pyftpdlib -p 2121 -w --user test --password secret --directory /var/tmp/ftp
```

If you want to simulate slow or laggy connections, you can run the client through [Speedbump](https://github.com/hello-woof/Speedbump)

```
speedbump --latency=2000ms --port=2000 127.0.0.1:2121
```

## Roadmap
 
### MUST
- [ ] Add parsing for `LIST` command output to extract file metadata (name, size, date, permissions).
- [ ] Implement `SIZE` command to fetch remote file size and show percentage 
- [ ] Add FTPS support using TLS/SSL for secure control and data connections.
- [ ] Write unit tests for FTP client functions using Crystal spec.

### COULD
- [ ] Implement active mode using `PORT` command for data connections as an alternative to `PASV`.
- [ ] Add `MKD` command to create directories on the FTP server.
- [ ] Enhance logging with levels (debug, info, error) and file rotation.

### SHOULD
- [ ] Implement resume for uploads using `APPE` command.
- [ ] Implement `DELE` command to delete files on the FTP server.

### WONT
- [ ] Build a CLI for user commands (connect, login, list, download, upload, cd) with argument parsing.
- [ ] Add ASCII progress bar for download/upload operations.
- [ ] Support loading server details from a YAML/JSON config file.
- [ ] Implement concurrent file transfers using Crystal fibers.

_These features wont be included in version 1.0.0_


## Contributing

1. Fork it (<https://github.com/chrisblunt-codes/ftpclient/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Blunt](https://github.com/chrisblunt-codes) - creator and maintainer


## License

Copyright 2025 Chris Blunt
Licensed under the MIT License
SPDX-License-Identifier: MIT

