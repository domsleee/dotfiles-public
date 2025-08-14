
def clear [] { $env.STARSHIP_FIRST_RENDER = 1; nu -c "clear"; }
$env.STARSHIP_FIRST_RENDER = 1
$env.config.hooks.pre_prompt = [{
    if $env.STARSHIP_FIRST_RENDER == 1 {
        $env.STARSHIP_FIRST_RENDER = 0
    } else {
        print ""
    }
}]