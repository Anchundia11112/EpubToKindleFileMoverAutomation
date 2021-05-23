Add-type -assembly "Microsoft.Office.Interop.Outlook"

function mobiToGmail () {

    $From = "<yourSenderEmail>"
    $To = "<yourKindleEmailAddress>"
    $Attachment = $attachment
    $Subject = "Kindle Books"
    $Body = "<Body Message>"
    $SMTPServer = "smtp.gmail.com"
    $SMTPPort = "587"
    
    $tempConvertedPath = "<convertedPathTemp>"
    $bookToReadTxt = "<TextFile of book>"
    
    $mobiEbook = Get-ChildItem -Path "$tempConvertedPath" -Filter "*.mobi"
    $numOfEbooks = ( Get-ChildItem -Path "$tempConvertedPath" -Filter "*.mobi" | Measure-Object ).Count

    $iteration = 0

    foreach($ebook in $mobiEbook) {
        
        $iteration = $iteration + 1
        $ebookNameWthExtension = $ebook.Name
        $ebookExtensionIndex = $ebookNameWthExtension.IndexOf(".mobi")
        $ebookName = $ebookNameWthExtension.Substring(0,$ebookExtensionIndex)

        $bookSizeMB = $ebook.Length / 1MB

        if($bookSizeMB -gt 25) {
            Write-Host -ForegroundColor Yellow "$ebook is too large\nEbook will be sent via outlook."
            $Outlook = New-Object -ComObject Outlook.Application
            $MapiNs = $Outlook.GetNameSpace("MAPI")
            $MailMsg = $Outlook.CreateItem(0)
            $MailMsg.GetInspector.Activate()
            #$Signature = $MailMsg.HTMLBody
            [Void]$MailMsg.Recipients.Add($To)  
            $MailMsg.Subject = $Subject
            $MailMsg.HTMLBody = $Body
            $MailMsg.Attachments.Add($ebook.FullName)
            $MailMsg.Send()

            if( ($numOfEbooks -ne 1) -or ($iteration -ne $numOfEbooks)) {
                Start-Sleep -s 30
            }
           
            Copy-Item $ebook.FullName "<bookArchivePath>" -Verbose
            #You can only send a combined 25 MB...which is only 1 or 2 books at the most. 
            Write-Host -ForegroundColor Green "$ebook has been moved to C:\temp\bookArchive"
            
            Remove-Item $ebook.FullName -Verbose
            Write-Host -ForegroundColor Green "$ebook has been removed."
            
        }
        else {
            Write-Host -ForegroundColor Yellow "$ebook will be added to attachments"
            Write-Host -ForegroundColor Yellow "Adding $ebookName to $bookToReadTxt"
            Add-Content -Path $bookToReadTxt -Value $ebookName
            
            Send-MailMessage -From $From -to $To -Subject $Subject `
            -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
            -Credential $From -Attachments $ebook.FullName

            Write-Host -ForegroundColor Green "$ebook has been emailed."
            Write-Host -ForegroundColor Yellow "Waiting 60 secs to send another email..."

            if( ($numOfEbooks -ne 1) -or ($iteration -ne $numOfEbooks)) {
                Start-Sleep -s 30
            }
           
            Copy-Item $ebook.FullName "<bookArchivePath>" -Verbose
            #You can only send a combined 25 MB...which is only 1 or 2 books at the most. 
            Write-Host -ForegroundColor Green "$ebook has been moved to C:\temp\bookArchive"
            
            Remove-Item $ebook.FullName -Verbose
            Write-Host -ForegroundColor Green "$ebook has been removed."
            
        }    
    }
}

mobiToGmail