param(
    [Parameter(Mandatory=$true)]
    [string]$ORG,
    
    [Parameter(Mandatory=$true)]
    [string]$REPO
)

Write-Host "Starting analysis for repository $ORG/$REPO"

# Fetch analyses using GitHub CLI
Write-Host "Fetching analyses for $ORG/$REPO..."
$analyses = gh api -X GET "/repos/$ORG/$REPO/code-scanning/analyses" --paginate -f tool_name=CodeQL

# Initialize arrays
$latest_analysis_ids = @()
$latest_created_at = @()
$categories = @()

$index = 0

Write-Host "Processing analyses to find the latest per category on 'refs/heads/main'..."

# Create temp file for jq processing
$tempFile = Join-Path $env:TEMP "analyses_tmp.json"
$analyses | Out-File -FilePath $tempFile

# Process each analysis using jq
Get-Content $tempFile | jq -c '.[]' | ForEach-Object {
    $analysis = $_
    $ref = $analysis | jq -r '.ref'
    
    # Only process analyses from main branch
    if ($ref -eq "refs/heads/main") {
        $created_at = $analysis | jq -r '.created_at'
        $analysis_id = $analysis | jq -r '.id'
        $category = $analysis | jq -r '.category'
        
        $categoryIndex = [array]::IndexOf($categories, $category)
        
        if ($categoryIndex -eq -1) {
            # New category found
            $categories += $category
            $latest_analysis_ids += $analysis_id
            $latest_created_at += $created_at
        }
        else {
            # Compare dates for existing category
            $existingDate = [DateTime]::Parse($latest_created_at[$categoryIndex])
            $newDate = [DateTime]::Parse($created_at)
            
            if ($newDate -gt $existingDate) {
                $latest_analysis_ids[$categoryIndex] = $analysis_id
                $latest_created_at[$categoryIndex] = $created_at
            }
        }
    }
}

Write-Host "Found latest analyses for these categories:"
for ($i = 0; $i -lt $categories.Count; $i++) {
    Write-Host "Category: $($categories[$i])"
    Write-Host "Analysis ID: $($latest_analysis_ids[$i])"
    Write-Host "Created at: $($latest_created_at[$i])"
    Write-Host "------------------------"
}

# Process each latest analysis
for ($i = 0; $i -lt $latest_analysis_ids.Count; $i++) {
    $analysis_id = $latest_analysis_ids[$i]
    $category = $categories[$i]

    Write-Host "Fetching results for analysis ID: $analysis_id"

    try {
        $sarif = gh api -X GET "/repos/$ORG/$REPO/code-scanning/analyses/$analysis_id" -H "Accept: application/sarif+json" | ConvertFrom-Json

        Write-Host "SARIF file retrieved for analysis ID $analysis_id"
        Write-Host "Processing SARIF file for analysis ID $analysis_id..."

        $alerts = foreach ($run in $sarif.runs) {
            foreach ($result in $run.results) {
                if ($result.codeFlows) {
                    $threadFlowCount = ($result.codeFlows | ForEach-Object {$_.threadFlows.Count}) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
                    if ($threadFlowCount -gt 1) {
                        $alertNumber = $result.properties."github/alertNumber"
                        "Alert $alertNumber has $threadFlowCount threadFlows"
                    }
                }
            }
        }

        if ($alerts) {
            $script:summary_list += "$alerts`n"
            Write-Host $alerts
        } else {
            Write-Host "No multi-threadflow alerts found for analysis ID $analysis_id"
        }
    }
    catch {
        Write-Error "Error processing analysis ID $analysis_id : $_"
        continue
    }

    Write-Host "Completed processing for analysis ID $analysis_id"
}

# Cleanup
Remove-Item $tempFile -Force