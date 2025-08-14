# https://github.com/junegunn/fzf/issues/4122#issuecomment-2849075544
# Dependencies: `fd`, `bat, `rg`, `nufmt`

# Directories
const alt_c = {
  name: fzf_dirs
  modifier: alt
  keycode: char_c
  mode: [emacs, vi_normal, vi_insert]
  event: [
    {
      send: executehostcommand
      cmd: "
        $env.STARSHIP_FIRST_RENDER = true;
        $env.FZF_DEFAULT_COMMAND = 'fd --type directory --hidden';
        let result = ^fzf --height=45% --preview 'tree -C {} | head -n 200'
        cd $result;
      "
    }
  ]
}

# Files
const ctrl_t =  {
  name: fzf_files
  modifier: control
  keycode: char_t
  mode: [emacs, vi_normal, vi_insert]
  event: [
    {
      send: executehostcommand
      cmd: "
        $env.STARSHIP_FIRST_RENDER = true;
        $env.FZF_DEFAULT_COMMAND = 'fd --hidden';
        let result = run-external 'fzf' '--height=45%'
        commandline edit --append $result;
        commandline set-cursor --end;
      "
    }
  ]
}

const ctrl_r = {
  name: history_menu
  modifier: control
  keycode: char_r
  mode: [emacs, vi_insert, vi_normal]
  event: [
    {
      send: executehostcommand
      cmd: "
        $env.STARSHIP_FIRST_RENDER = true;
        let result = history
          | get command
          | reverse
          | uniq
          | str replace --all (char newline) ' '
          | to text
          | fzf --scheme=history  --height=45%;
        commandline edit --append $result;
        commandline set-cursor --end
      "
    }
  ]
}

# Update the $env.config
$env.config.keybindings = ($env.config.keybindings | append [
  $alt_c
  $ctrl_t
  $ctrl_r
])