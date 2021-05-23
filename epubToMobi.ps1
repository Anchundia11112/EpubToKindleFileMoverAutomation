#
#
#  .DESCRIPTION
#    Will convert any epub files found in my download directory to mobi files and the mobi files will be placed in C:\temp
#
#  
#
#

Function epubToMobiConverter() {

    $userName = [Environment]::UserName
    $downloadDirectory = "C:\Users\$userName\Downloads"
    $convertedTempDirectoy = "C:\temp\"

    $downloadedEbooks = Get-ChildItem -Path $downloadDirectory -Filter "*.epub"

    foreach($ebook in $downloadedEbooks) {
        
        $ebookNameWthExtension = $ebook.Name
        $ebookExtensionIndex = $ebookNameWthExtension.IndexOf(".epub")
        $ebookName = $ebookNameWthExtension.Substring(0,$ebookExtensionIndex)

        $ebookDirectoryWithTitle = $ebook.FullName
        
        $ebookWithMobiExtension = $convertedTempDirectoy +  $ebookName + ".mobi"

        Write-Host -ForegroundColor Yellow "$ebookNameWthExtension will be converted to mobi"

        Write-Host "------------------------------------"
        
        & "C:\Program Files (x86)\Calibre2\ebook-convert.exe" @("$ebookDirectoryWithTitle", "$ebookWithMobiExtension")
        Write-Host -ForegroundColor Green "Conversion complete for $ebookName"

        Write-Host "------------------------------------"

        Remove-Item $ebookDirectoryWithTitle -Verbose
        Write-Host -ForegroundColor Green "$ebook has been removed."
    }
}

#epubToMobiConverter
