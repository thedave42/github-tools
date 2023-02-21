# Some handy commands to viewing the data in SARIF files

### Getting the SARIF
Re-run the Action in [debug mode](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging) in order to get the SARIF from the Actions workflow as an artifact.

### Shows a list of rules that were run and number of results
```
cat FILE.sarif | jq  '.runs[].results[].ruleId' | sort | uniq -c
```

### Shows the threadFlowStepsCount for each result
```
cat FILE.sarif | jq -rc '.runs[].results[] | {rule: .ruleId, file: .locations[0].physicalLocation.artifactLocation.uri, codeFlowsCount: (.codeFlows | length), threadFlowStepsCount: (.codeFlows | reduce .[]? as $item (0;  . + ($item.threadFlows[0].locations | length)))}' | jq -s -c 'sort_by(.threadFlowStepsCount) | .[]'
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

