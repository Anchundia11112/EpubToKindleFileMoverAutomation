$mailTo = "kindleEmailAddress"
$mailFrom = "emailAddress"
$subjectLine = "Automated books sent"
$credentials = Get-Credential
$body = "Not really needed"
$smtpServer = "smtp.gmail.com"
$port = "587"


$downloadsFolder = "C:\Users\micha\Downloads"

$attachments = Get-ChildItem -path $downloadsFolder | Where-Object {$_.Extension -eq ".epub" -or $_.Extension -eq ".pdf"}

Write-Host " HElo"

foreach($book in $attachments) {
    Write-Host "Building content to send book through email"
    
    $bookName = $book.Name
    Write-Host $bookName " will be sent to kindle"
    $bookLocation = $downloadsFolder + '\' + $bookName
    
    $bookLocation

    Send-MailMessage -To $mailTo -From $mailFrom -Credential $credentials -Body $body -Subject $subjectLine -SmtpServer $smtpServer -Port $port -UseSsl -Attachments $bookLocation
    #timer to not lock account....
    Write-Host "Book " $bookName " has been emailed to Kindle."
    Start-Sleep -Seconds 60
}


