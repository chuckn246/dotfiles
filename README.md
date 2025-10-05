## Vivid
Create a docker image and mount the theme directory:
```bash
docker run -v "$HOME/.dotfiles/vivid/.config/themes/":"/.config/vivid/themes" --rm -it debian /bin/bash
```

Enable vi mode:
```bash
set -o vi
```

At the prompt, update the system and install a couple tools in the docker container:
```bash
apt update && apt upgrade -y && apt install -y vim wget
```

Download vivid binary:
```bash
wget "https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_arm64.deb"
```

Install vivid binary:
```bash
dpkg -i vivid_0.8.0_arm64.deb
```

List available themes:
```bash
vivid themes
```

Generate the `LS_COLORS` for the desired theme:
```bash
vivid generate ${theme}
```

Copy and paste the output to `~/.config/zsh/.zprofile` on the host computer.


