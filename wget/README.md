# wget Configuration

This directory contains my wget configuration.

## Usage

wget automatically reads the configured settings when it starts.

Example:

```sh
wget https://example.com/file.tar.gz
```

Individual settings can be overridden on the command line:

```sh
wget --tries=1 URL
```

---

## Configuration Notes

The configuration contains general-purpose defaults intended to improve reliability while keeping behavior predictable.

Common settings include:

* download retry behavior
* connection timeouts
* timestamp handling
* filename handling
* recursive download safeguards

Options that are only useful for specific tasks, such as mirroring websites or debugging HTTP responses, should generally be enabled per command rather than globally.

---

## Security Notes

Be cautious when enabling settings that:

* modify user-agent strings
* disable robots.txt handling
* automatically trust remote filenames
* store authentication information

Use command-line overrides for unusual download scenarios instead of changing global defaults.
