. "$PSScriptRoot\PowershellLib.ps1"

function kindleDownloadsToTemp() {

    $ebookDirectory = "C:\temp\downloadedEbooks"
    $timestamp = Get-Date -Format "MM/dd/yyyy HH:mm"
    $logFile = "$PSScriptRoot\Log\FileMoverLog.txt"
    $downloadsFolder = "C:\Users\micha\Downloads"

    if(!(Test-Path $ebookDirectory)) {
        Write-Log-Message 1 $ebookDirectory " does not exist. Creating..."
        mkdir $ebookDirectory
        Write-Log-Message 1 "$ebookDirectory has been created"
    }
    else {
        Write-Log-Message 1 " $ebookDirectory is already created. Proceeding"
    }

    $epubItemsInDownloads = Get-ChildItem -Path $downloadsFolder | Where-Object {$_.Extension -eq ".epub"}

    foreach($epubFile in $epubItemsInDownloads.Name) {
        $ebookPath = $downloadsFolder + "\" + "$epubFile"

        try { 
            Move-Item -Path $ebookPath -Destination $ebookDirectory
            Write-Log-Message 1 "Moving $epubFile from $ebookPath to $ebookDirectory."
        }
        catch {
            Write-Log-Message 2 "$_" 
        }
    }



}

kindleDownloadsToTemp