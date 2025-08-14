
# Update everything
def update-all [] {
    cargo install-update --all;
    if ($nu.os-info.name == 'macos') {
        brew upgrade;
    }
    if ($nu.os-info.name == 'windows') {
        scoop update -a;
    }
}

def "nu-complete git branches" [] {
  ^git branch | lines | each { |line| $line | str replace '* ' "" | str trim }
}

def grm [
    branch?: string@"nu-complete git branches"
] {
    git fetch origin
    if $branch != null {
        git checkout $branch
    }
    git rebase -i origin/master
}