#!/usr/bin/env -S cargo +nightly -Zscript
```cargo
[dependencies]
clap = { version = "4.4.6", features = ["derive", "env"] }
paars = { git = "https://github.com/alexpdp7/paars.git" }
```
use std::path::PathBuf;
use clap::Parser;

#[derive(Parser, Debug)]
#[command()]
struct Args {
    #[clap(long, env)]
    docker_config: PathBuf,

    #[clap()]
    dir: PathBuf,

    #[clap()]
    image: String,
}

fn main() {
    let args = Args::parse();
    paars::build_image(args.dir, args.docker_config, args.image);
}
