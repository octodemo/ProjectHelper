<#
    .SYNOPSIS
    Adds an item to a GitHub project.

    .DESCRIPTION
    This function adds an item (issue or pull request) to a GitHub project.

    .PARAMETER ProjectNumber
    The number of the project to which the item will be added.

    .PARAMETER Owner
    The owner of the item.

    .PARAMETER ItemUrl
    The URL of the item to be added.

    .EXAMPLE
    Add-ItemToProject -ProjectNumber 123 -Owner "github" -ItemUrl "https://github.com/owner/repo/issues/1"
#>
function Add-ItemToProject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)] [string]$ProjectNumber,
        [Parameter(Mandatory=$true)] [string]$Owner,
        [Parameter(Mandatory=$true)] [string]$ItemUrl
    )

    # Step 1: Translate URL to resource ID
    $resourceResponse = Invoke-GitHubGetResourceId -Url $ItemUrl
    if (-not $resourceResponse) {
        "Failed to get resource ID for URL: $ItemUrl" | Write-MyError
        return $null
    }

    $resourceId = $resourceResponse.data.resource.id
    if (-not $resourceId) {
        "No resource ID found for URL: $ItemUrl" | Write-MyError
        return $null
    }

    # Step 2: Get project info (to get project ID)
    $projectResponse = Invoke-GitHubGetProjectInfo -Owner $Owner -ProjectNumber $ProjectNumber
    if (-not $projectResponse) {
        "Failed to get project info for Owner: $Owner, Project: $ProjectNumber" | Write-MyError
        return $null
    }

    $projectId = $projectResponse.data.organization.projectV2.id
    if (-not $projectId) {
        "No project ID found for Owner: $Owner, Project: $ProjectNumber" | Write-MyError
        return $null
    }

    # Step 3: Add the item to the project
    $addItemResponse = Invoke-GitHubAddItemToProject -ProjectId $projectId -ContentId $resourceId
    if (-not $addItemResponse) {
        "Failed to add item to project" | Write-MyError
        return $null
    }

    # Return the response
    return $addItemResponse
} Export-ModuleMember -Function Add-ItemToProject