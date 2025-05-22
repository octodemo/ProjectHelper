# Import helper and mock functions
. $PSScriptRoot/../../helper/module.helper.ps1
. $PSScriptRoot/../../include/invokeCommand.mock.ps1

# Setup test environment
function Test_AddItemToProject_SUCCESS {
    Reset-InvokeCommandMock
    Enable-InvokeCommandAliasModule

    # Mock the calls to get resource ID, project info, and add item
    MockCallJson -command "Invoke-GitHubGetResourceId" -filename "get-resource-id-response.json"
    MockCallJson -command "Invoke-GitHubGetProjectInfo" -filename "get-project-info-response.json"
    MockCallJson -command "Invoke-GitHubAddItemToProject" -filename "add-item-to-project-response.json"

    # Execute the function
    $result = Add-ItemToProject -ProjectNumber 9279 -Owner "github" -ItemUrl "https://github.com/owner/repo/issues/1"

    # Verify the result
    Assert-NotNull -Object $result
    Assert-IsType -Object $result -Type "PSCustomObject"

    # Verify that the correct ID was retrieved
    $expectedResourceId = "I_kwDOIEf6YM63uLmj"
    $expectedProjectId = "PVT_kwDNJr_OADU3Yg"
    
    Assert-AreEqual -Expected $expectedResourceId -Presented $result.data.addProjectV2ItemById.item.content.id
    Assert-AreEqual -Expected "PVTI_lADNJr_OADU3Ys4Gqsrm" -Presented $result.data.addProjectV2ItemById.item.id
}

# Execute the test
Test_AddItemToProject_SUCCESS