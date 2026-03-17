path+=$HOME/.cargo/bin
[[ $commands[rustup] ]] && eval_cache rustup-completion rustup completions zsh rustup
[[ $commands[cargo] ]]  && eval_cache cargo-completion env CARGO_COMPLETE=zsh cargo +nightly
