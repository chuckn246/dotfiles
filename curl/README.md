# curl Configuration

This directory contains my curl configuration.

## Installation

The configuration file should be placed where curl can discover it automatically.

For XDG-style layouts, this repository uses:

```text
~/.config/curl/
└── .curlrc
```

If using a custom location, set:

```sh
export CURL_HOME="${XDG_CONFIG_HOME}/curl"
```

---

## Usage

curl automatically reads the configuration file when it starts.

For debugging configuration loading:

```sh
curl -v URL
```

Individual settings can always be overridden on the command line:

```sh
curl --location URL
```

---

## Configuration Notes

The configuration contains general-purpose defaults intended for interactive use and automation.

Common settings include:

* connection and transfer timeouts
* redirect handling
* retry behavior
* compression support
* HTTP error handling

Options that significantly change behavior are usually better specified per command.

---

## Security Notes

Avoid storing credentials directly in this configuration file.

For authenticated requests, consider using:
* environment variables
* credential helpers
* `.netrc` with appropriate file permissions
* application-specific authentication methods
