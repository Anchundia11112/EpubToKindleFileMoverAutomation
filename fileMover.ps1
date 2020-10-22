function kindleDownloadsToTemp() {

    $ebookDirectory = "C:\temp\downloadedEbooks"
    $timestamp = Get-Date -Format "MM/dd/yyyy HH:mm"
    $logFile = "$PSScriptRoot\Log\FileMoverLog.txt"
    $downloadsFolder = "C:\Users\micha\Downloads"

    if(!(Test-Path $logFile)) {
        Write-Host "[INFO][$timestamp]" $logFile " does not exist. Creating..."
        mkdir $logFile
        Write-Host "[INFO] [$timestamp] $logFile has been created"
    }
    else {
        Write-Host "[INFO][$timestamp] " $logFile " is already created. Proceeding"
    }

    if(!(Test-Path $ebookDirectory)) {
        Write-Host "[INFO][$timestamp]" $ebookDirectory " does not exist. Creating..."
        mkdir $ebookDirectory
        Write-Host "[INFO] [$timestamp] $ebookDirectory has been created"
    }
    else {
        Write-Host "[INFO][$timestamp] " $ebookDirectory " is already created. Proceeding"
    }

    $epubItemsInDownloads = Get-ChildItem -Path $downloadsFolder | Where-Object {$_.Extension -eq ".epub"}

    foreach($epubFile in $epubItemsInDownloads.Name) {
        $ebookPath = $downloadsFolder + "\" + "$epubFile"

        Move-Item -Path $ebookPath -Destination $ebookDirectory
        Write-Host "[INFO][$timestamp] Moving " $epubFile " from " $ebookPath " to " $ebookDirectory "."
    }



}

kindleDownloadsToTemp