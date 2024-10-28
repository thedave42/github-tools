#!/bin/bash

# Ensure two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ORG> <REPO>"
    exit 1
fi

ORG="$1"
REPO="$2"

echo "Starting analysis for repository $ORG/$REPO"

# Fetch analyses for the repository using GitHub CLI with explicit GET method
echo "Fetching analyses for $ORG/$REPO..."
analyses=$(gh api -X GET "/repos/$ORG/$REPO/code-scanning/analyses" --paginate -f tool_name=CodeQL)

# Initialize indexed arrays
latest_analysis_ids=()
latest_created_at=()
categories=()

index=0

echo "Processing analyses to find the latest per category on 'refs/heads/main'..."

# Use a temporary file to store the loop input to maintain variable scope in bash 3.2
echo "$analyses" | jq -c '.[]' > /tmp/analyses_tmp.json

while IFS= read -r analysis; do
    ref=$(echo "$analysis" | jq -r '.ref')
    category=$(echo "$analysis" | jq -r '.category')
    id=$(echo "$analysis" | jq -r '.id')
    created_at=$(echo "$analysis" | jq -r '.created_at')

    if [ "$ref" = "refs/heads/main" ]; then
        found=0
        # Iterate through existing categories to find a match
        for ((i=0; i<index; i++)); do
            if [ "${categories[$i]}" = "$category" ]; then
                found=1
                # Compare creation dates to keep the latest analysis
                if [ "$created_at" \> "${latest_created_at[$i]}" ]; then
                    echo "Updating latest analysis for category '$category' with newer analysis ID $id"
                    latest_analysis_ids[$i]="$id"
                    latest_created_at[$i]="$created_at"
                fi
                break
            fi
        done

        # If category not found, add it to the arrays
        if [ "$found" -eq 0 ]; then
            echo "Found new category '$category' with analysis ID $id"
            categories[$index]="$category"
            latest_analysis_ids[$index]="$id"
            latest_created_at[$index]="$created_at"
            index=$((index + 1))
        fi
    else
        echo "Skipping analysis ID $id with ref '$ref'"
    fi
done < /tmp/analyses_tmp.json

# Remove the temporary file
rm /tmp/analyses_tmp.json

echo "Total categories found: $index"

# Initialize summary list
summary_list=""

# Loop through the list of latest analysis IDs
for ((i=0; i<index; i++)); do
    id="${latest_analysis_ids[$i]}"
    category="${categories[$i]}"

    echo "Retrieving SARIF file for analysis ID $id (Category: $category)..."
    sarif=$(gh api -X GET "/repos/$ORG/$REPO/code-scanning/analyses/$id" -H "Accept: application/sarif+json")

    echo "SARIF file retrieved for analysis ID $id"

    echo "Processing SARIF file for analysis ID $id..."
    
    # Extract alerts with more than one threadFlow
    alerts=$(echo "$sarif" | jq -r '
        .runs[] | .results[]? | select(.codeFlows != null) | 
        {
            alertNumber: .properties["github/alertNumber"],
            threadFlowCount: (.codeFlows | map(.threadFlows | length) | add)
        } |
        select(.threadFlowCount > 1) |
        "Alert \(.alertNumber) has \(.threadFlowCount) threadFlows"
    ')

    if [ -n "$alerts" ]; then
        summary_list="${summary_list}${alerts}\n"
    fi

    # Display alerts immediately
    echo "$alerts"

    echo "Completed processing for analysis ID $id"
done

# Output the summary
echo -e "\nSummary of codeFlows with more than one threadFlows:"
echo -e "$summary_list"

echo "Analysis completed for repository $ORG/$REPO"