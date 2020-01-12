using namespace System.Management.Automation.Host
function Prompt-Collection {
    param (
        [string]$Title,
        [string]$Question,    
        [Array] $Choices,
        [string] $DisplayPropertyName
    )


    $chcs = [ordered]@{
        "option1" = 1
        "option2" = 2
        "option3" = 3
    }
    
    $choiceDescriptions = @()

    foreach ($chc in $chcs.Keys) {
        write-host $chc
        $choiceDescriptions.Add([ChoiceDescription]::new("&$($chc)", "Favorite color: $($chc)"))
    }

    $selected = $host.ui.PromptForChoice($Title, $Question, $options, 0)

    return $chcs[$selected]
}