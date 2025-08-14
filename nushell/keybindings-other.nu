$env.config.keybindings = ($env.config.keybindings | append [
  {
    name: git_checkout_branch
    modifier: control
    keycode: char_b
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: executehostcommand
        cmd: "
          let result = ^git branch | fzf --height=45%;
          if $result != '' {
            git checkout ($result | str replace '*' '' | str trim);
          }
        "
      }
    ]
  },
  {
    name: apply_completion
    modifier: control
    keycode: char_.
    mode: [emacs vi_normal vi_insert]
    event: { send: historyhintcomplete }
  }
])