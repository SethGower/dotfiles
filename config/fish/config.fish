if status is-interactive
    starship init fish | source

    thefuck --alias | source

    fzf_configure_bindings --directory=\cg
end
