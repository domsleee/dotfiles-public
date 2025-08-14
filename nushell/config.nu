$env.config.show_banner = false
# $env.LS_COLORS = (vivid generate snazzy)

source ./keybindings-fzf.nu
source ./keybindings-other.nu
source ./completions.nu
source ./git-aliases.nu
source ./starship-newline-fix.nu
source ./functions.nu

const plat_file = if ($nu.os-info.name == 'macos') { './config-mac.nu' } else { './config-win.nu' }
source $plat_file

$env.STARSHIP_CONFIG = $env.FILE_PWD | path join ../config/starship.toml | path expand
