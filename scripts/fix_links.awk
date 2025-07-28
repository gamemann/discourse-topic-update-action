{
    line = $0
    while (match(line, /\[([^\]]+)\]\(#([^)]+)\)/, arr)) {
        title = arr[1]
        anchor = arr[2]

        env_var = anchor
        gsub(/[^a-zA-Z0-9]/, "_", env_var)
        env_var = toupper(env_var)

        env_key = "HEADER_" env_var
        repl = ENVIRON[env_key]

        if (repl != "") {
            before = substr(line, 1, RSTART - 1)
            after = substr(line, RSTART + RLENGTH)
            replacement = "[" title "](#" repl ")"
            line = before replacement after
        } else {
            break
        }
    }
    print line
}