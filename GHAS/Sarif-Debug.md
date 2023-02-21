# Some handy commands to viewing the data in SARIF files

### Getting the SARIF
Re-run the Action in [debug mode](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging) in order to get the SARIF from the Actions workflow as an artifact.

### Shows a list of rules that were run and number of results
```
cat FILE.sarif | jq  '.runs[].results[].ruleId' | sort | uniq -c
```
Example output:
```
  23 "py/clear-text-logging-sensitive-data"
   1 "py/clear-text-storage-sensitive-data"
   2 "py/incomplete-url-substring-sanitization"
   2 "py/insecure-temporary-file"
  13 "py/overly-large-range"
   1 "py/path-injection"
  88 "py/stack-trace-exposure"
  16 "py/url-redirection"
   2 "py/weak-sensitive-data-hashing"
```

### Shows the threadFlowStepsCount for each result
```
cat FILE.sarif | jq -rc '.runs[].results[] | {rule: .ruleId, file: .locations[0].physicalLocation.artifactLocation.uri, codeFlowsCount: (.codeFlows | length), threadFlowStepsCount: (.codeFlows | reduce .[]? as $item (0;  . + ($item.threadFlows[0].locations | length)))}' | jq -s -c 'sort_by(.threadFlowStepsCount) | .[]'
```
Example output:
```
{"rule":"js/sql-injection","file":"app/data/user-dao.js","codeFlowsCount":1,"threadFlowStepsCount":8}
{"rule":"js/sql-injection","file":"app/data/user-dao.js","codeFlowsCount":1,"threadFlowStepsCount":8}
{"rule":"js/ml-powered/nosql-injection","file":"app/data/memos-dao.js","codeFlowsCount":2,"threadFlowStepsCount":10}
{"rule":"js/polynomial-redos","file":"app/routes/session.js","codeFlowsCount":2,"threadFlowStepsCount":14}
{"rule":"js/unsafe-jquery-plugin","file":"app/assets/vendor/bootstrap/bootstrap.js","codeFlowsCount":2,"threadFlowStepsCount":26}
{"rule":"js/unsafe-jquery-plugin","file":"app/assets/vendor/bootstrap/bootstrap.js","codeFlowsCount":2,"threadFlowStepsCount":31}
{"rule":"js/ml-powered/nosql-injection","file":"app/data/user-dao.js","codeFlowsCount":4,"threadFlowStepsCount":32}
{"rule":"js/unsafe-jquery-plugin","file":"app/assets/vendor/bootstrap/bootstrap.js","codeFlowsCount":2,"threadFlowStepsCount":37}
{"rule":"js/unsafe-jquery-plugin","file":"app/assets/vendor/bootstrap/bootstrap.js","codeFlowsCount":3,"threadFlowStepsCount":41}
```

### Use a config file to exclude rule ids
File only need to contain the exclusions.  Exclusions are the rule ids that can be found with the above queries.
```
query-filters:
    - exclude:
        id: 
          - cpp/unbounded-write
          - cpp/path-injection
```
Specify the config file in the init step in the Actions workflow
```
    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        config-file: codeql-config.yml
        languages: ${{ matrix.languages }}
```
Or specify the config on the codeql CLI command line using the [`--codescanning-config`](https://codeql.github.com/docs/codeql-cli/manual/database-init/#cmdoption-codeql-database-init-codescanning-config) flag.
```
--codescanning-config=<file>
```

