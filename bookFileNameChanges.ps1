function convertFileNameToBookName () {
    Param(
        [Parameter(Position=0, Mandatory)]
        [String]$rootCalibrePath
    )

    if(!(Test-Path $rootCalibrePath)) {
        Write-Log-Message 1 "$rootCalibrePath does not exists. This should exit."
    }
    else {
        Write-Log-Message 1 "$rootCalibrePath exists."
    }

    $calibreMobiFiles = Get-ChildItem -Path $rootCalibrePath -Recurse -Filter "*.mobi"
    $tempDirectory = "C:\temp\downloadedEbooks"    

    foreach($mobiFile in $calibreMobiFiles) {
        $mobiFileLocation = $mobiFile.FullName
        $mobiFileSize = $mobiFile.Length
        $mobiFileTitle = $mobiFile.Name

        #Google limit is 25mb 
        if($mobiFile.Length -gt "25mb") {
            Write-Log-Message 1 "$mobiFileTitle has exceeded the file size. This mobi file cannot be mailed."
        }
        else {
            Write-Host -ForegroundColor Yellow "$mobiFileTitle is being copied over to $tempDirectory"
            Copy-Item $mobiFileLocation -Destination $tempDirectory
            Write-Host -ForegroundColor Green "Copy Complete."
        }
    }
    
    #return $calibreMobiFiles
}

convertFileNameToBookName "C:\Users\micha\Calibre Library"