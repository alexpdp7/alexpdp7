#!/usr/bin/env python3
import json
import sys
import subprocess


def parse_ansible(stdout):
    result = {}
    errors = set()
    for line in stdout.splitlines():
        host_name, _ = line.split(" | ", 2)
        if " => " not in line:
            errors.add(host_name)
            continue
        _, facts_json = line.split(" => ", 2)
        facts = json.loads(facts_json)
        result[host_name] = facts
    return result, errors


hosts = sys.argv[1]

d = subprocess.run(["rye", "run", "ansible","-o", "-m", "setup", "-a", "filter=ansible_distribution", hosts], stdout=subprocess.PIPE, encoding="utf8")

d_data, d_errors = parse_ansible(d.stdout)

v = subprocess.run(["rye", "run", "ansible", "-o", "-m", "setup", "-a", "filter=ansible_distribution_major_version", hosts], stdout=subprocess.PIPE, encoding="utf8")

v_data, v_errors = parse_ansible(v.stdout)

for host_name in d_data.keys():
    print(host_name, d_data[host_name]["ansible_facts"]["ansible_distribution"], v_data[host_name]["ansible_facts"]["ansible_distribution_major_version"])

assert not d_errors and not v_errors, (v_errors, d_errors)
