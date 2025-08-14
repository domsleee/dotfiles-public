if $nu.os-info.name == "macos" {
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin' | prepend '/usr/local/bin' | prepend '~/.cargo/bin')
}
