#!/usr/bin/env python3

import json
import sys
import urllib.request

run_id = sys.argv[1]

if run_id == "last":
    runs = json.loads(urllib.request.urlopen("https://api.github.com/repos/alexpdp7/ragent/actions/runs?branch=master&event=push").read().decode('utf8'))
    run_id = runs["workflow_runs"][0]["id"]

run = json.loads(urllib.request.urlopen("https://api.github.com/repos/alexpdp7/ragent/actions/runs/%s" % run_id).read().decode('utf8'))
artifacts = json.loads(urllib.request.urlopen(run['artifacts_url']).read().decode('utf8'))['artifacts']
urls = {a['name']: 'https://api.github.com/repos/alexpdp7/ragent/actions/artifacts/%s/zip' % a["id"] for a in artifacts}
print(json.dumps(urls))
