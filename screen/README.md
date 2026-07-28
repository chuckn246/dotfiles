# GNU Screen Configuration

This directory contains my GNU Screen configuration.

## Installation

Link or copy the configuration file into your home directory.

---

## Usage

Start a new Screen session:

```sh
screen
```

List existing sessions:

```sh
screen -ls
```

Attach to an existing session:

```sh
screen -r <session>
```

Detach from the current session:

```
Ctrl-a d
```

---

## Default Prefix

The default Screen command prefix is:

```
Ctrl-a
```

After pressing the prefix, press the desired command key.

## Common Commands

| Command      | Action                         |
| ------------ | ------------------------------ |
| `Ctrl-a c`   | Create a new window            |
| `Ctrl-a n`   | Switch to next window          |
| `Ctrl-a p`   | Switch to previous window      |
| `Ctrl-a 0-9` | Switch to window by number     |
| `Ctrl-a "`   | List and select windows        |
| `Ctrl-a d`   | Detach session                 |
| `Ctrl-a k`   | Kill current window            |
| `Ctrl-a \`   | Kill the entire Screen session |

## Splitting Regions

Screen regions divide the display area, but creating a region does not automatically start a new shell.

Create a horizontal split:
```
Ctrl-a S
```

Create a vertical split:
```
Ctrl-a |
```

Move between regions:
```
Ctrl-a Tab
Ctrl-a h,j,k,l
```

Create a new window in the active region:
```
Ctrl-a c
```

Remove a split:
```
Ctrl-a X
```

---

## Configuration Notes

The configuration in this directory is intended to provide a consistent terminal multiplexer environment across systems where GNU Screen is available.

I tried to keep machine-specific settings and terminal assumptions minimal so the configuration remains portable, though some features may not work on older versions of screen.
