# Features
* fzf bindings (ctrl+t, alt+c, ctrl+r)
* git tab completions
* zoxide integration

# Setup

1. Clone repository

```shell
cd ~/git
git clone https://github.com/domsleee/dotfiles-public.git
```

2. Install dependencies
```shell
scoop install nu starship zoxide fzf fd bat
```

3. In `code $nu.config-path`
```shell
source ~/git/dotfiles-public/nushell/config.nu
```

4. In `code $nu.env-path`
```shell
source ~/git/dotfiles-public/nushell/env.nu
```

5. Run install script
```shell
nu nushell/install.nu
```

Tested nu version: `0.106.1`.