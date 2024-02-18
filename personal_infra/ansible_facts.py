#!/usr/bin/env python3
import collections
import json
import subprocess


def setup(pattern, setup_options):
    res = dict()
    out = subprocess.run(["ansible", "-m", "setup", pattern, "-a", setup_options], env={"ANSIBLE_LOAD_CALLBACK_PLUGINS": "true", "ANSIBLE_STDOUT_CALLBACK": "ansible.posix.jsonl"}, check=True, stdout=subprocess.PIPE).stdout
    out = out.decode("utf8").split("\n")[0:-4]
    out = [json.loads(l) for l in out if l.startswith("{")]
    out = [j for j in out if "hosts" in j and j["hosts"]]
    for j in out:
        assert len(j["hosts"]) == 1
        k, v = list(j["hosts"].items())[0]
        res[k] = v["ansible_facts"]
    return res


def distros():
    res = collections.defaultdict(list)
    for k, v in setup("!k8s", "gather_subset=all").items():
        res[f'{v["ansible_distribution_file_variety"]} {v["ansible_distribution_major_version"]}'].append(k)
    return res
