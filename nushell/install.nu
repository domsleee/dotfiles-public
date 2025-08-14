mkdir ($nu.data-dir | path join "vendor/autoload")
zoxide init nushell --cmd cd | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
starship init nu | str replace -r '\^.*prompt --continuation' ("'" + (starship prompt --continuation) + "'") | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
echo '$env.PROMPT_COMMAND_RIGHT = { || }' | save -f ($nu.data-dir | path join "vendor/autoload/zzz.blankrightprompt.nu")
