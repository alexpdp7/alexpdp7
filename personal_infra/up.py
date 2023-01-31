#!/usr/bin/env python3
import argparse
from concurrent import futures
import pathlib
import shlex
import shutil
import subprocess
import textwrap
import yaml

"""
directory/
  global_vars/*.json: these JSON files will be available to all hosts
  host_vars/{host}/*.json: these JSON files will be available in each host
  facts/{host}.json: output from "facter -y" for each host

directory/
  output/
    {host}/
      catalog.json
      modules/
"""


def build_hiera(directory, build_host_dir, host):
    hiera_data_dir = build_host_dir / "data"
    hiera_data_dir.mkdir()

    hiera = {
        "version": 5,
        "hierarchy": []
    }

    global_vars_dir = directory / "global_vars"

    for global_var in global_vars_dir.glob("*.json"):
        shutil.copy(global_var, hiera_data_dir / global_var.name)
        hiera["hierarchy"].append({
            "name": global_var.name.removesuffix(".json"),
            "path": global_var.name,
            "data_hash": "json_data",
        })

    host_vars_dir = directory / "host_vars" / host

    for host_var in host_vars_dir.glob("*.json"):
        shutil.copy(host_var, hiera_data_dir / host_var.name)
        hiera["hierarchy"].append({
            "name": host_var.name.removesuffix(".json"),
            "path": host_var.name,
            "data_hash": "json_data",
        })

    hiera_path = build_host_dir / "hiera.yaml"
    with open(hiera_path, "w") as f:
        yaml.dump(hiera, f)

    return hiera_path


def build_facts(directory, build_host_dir, host):
    source_facts_dir = directory / "facts"

    with open(source_facts_dir / f"{host}.yaml") as f:
        facts_yaml_content = f.read()

    dest_facts_dir = build_host_dir / "yaml" / "facts"
    dest_facts_dir.mkdir(parents=True)

    with open(dest_facts_dir / f"{host}.yaml", "w") as f:
        f.write("--- !ruby/object:Puppet::Node::Facts\nvalues:\n")
        f.write(textwrap.indent(facts_yaml_content, "  "))


def compile_catalog(directory, build_dir, modulepath, manifest, output_dir,
                    host):
    build_host_dir = build_dir / host
    build_host_dir.mkdir()

    hiera_path = build_hiera(directory, build_host_dir, host)

    build_facts(directory, build_host_dir, host)

    cmd = [
        "puppet", "catalog", "compile",
        f"--modulepath={modulepath}",
        f"--hiera_config={hiera_path}",
        f"--manifest={manifest}",
        "--terminus", "compiler",
        "--vardir", build_host_dir,
        "--facts_terminus", "yaml",
        host
    ]
    print(shlex.join(map(str, cmd)))
    catalog_compile = subprocess.run(
        cmd, check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf8"
    )
    assert not catalog_compile.stderr, catalog_compile.stderr

    catalog_stdout = catalog_compile.stdout

    _, catalog = catalog_stdout.split("\n", 1)

    host_output_dir = output_dir / host
    host_output_dir.mkdir()
    with open(host_output_dir / "catalog.json", "w") as f:
        f.write(catalog)

    shutil.copytree(modulepath, host_output_dir / "modules")


def up(directory: pathlib.Path, modulepath, manifest, hosts: list[str]):
    build_dir = directory / "build"
    build_dir.mkdir()

    output_dir = build_dir / "output"
    output_dir.mkdir()

    def _compile_catalog(host):
        compile_catalog(
            directory=directory,
            build_dir=build_dir,
            modulepath=modulepath,
            manifest=manifest,
            output_dir=output_dir,
            host=host)

    # list because exceptions do not happen unless you iterate over the result
    list(futures.ThreadPoolExecutor().map(_compile_catalog, hosts))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("directory")
    parser.add_argument("modulepath")
    parser.add_argument("manifest")
    parser.add_argument("hosts", nargs="+", metavar="host")

    args = parser.parse_args()
    up(
        directory=pathlib.Path(args.directory),
        modulepath=args.modulepath,
        manifest=args.manifest,
        hosts=args.hosts
    )


if __name__ == "__main__":
    main()
