# Chrome-TLS-Config  
![Icon](https://raw.githubusercontent.com/timdawg/Chrome-TLS-Config/master/readme_resources/icon.png)

Google Chrome TLS Configuration is a script written in AutoIt that configures the SSL/TLS cipher suite blacklist for Google Chrome (on Windows).

**I recommend disabling all four RC4 cipher suites at the bottom of the list.**

### Features
* Disable TLS cipher suites by checking boxes
* Checkboxes show the TLS cipher suite name, so there is no need to lookup the ID
* Searches common shortcut locations including the user desktop, start menu and all user profiles
* Easily applies the cipher suite blacklist argument to all of the found shortcuts
* The configuration is automatically stored when the configuration is applied
* At startup, the previous configuration is automatically read
* Configuration is stored in chrome_tls_config.ini (file automatically created)

![Screenshot](https://raw.githubusercontent.com/timdawg/Chrome-TLS-Config/master/readme_resources/screenshot.png)

### Manual Configuration
To specify a TLS cipher suite blacklist, Google Chrome has to be started with the --cipher-suite-blacklist argument.  All of the shortcuts that are used to open Chrome need to be updated with this argument.  The --cipher-suite-blacklist argument should have an equal sign, followed by the a list of cipher suite IDs (as hex) and separated by commas (without spaces).

**Example:** (disables all RC4 cipher suites)
```
chrome.exe --cipher-suite-blacklist=0xc007,0xc011,0x0005,0x0004
```
