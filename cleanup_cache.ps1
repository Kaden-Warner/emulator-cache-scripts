# Configuration
$CacheDir = "C:\Users\Public\Documents\DolphinCache"
$MaxAgeDays = 14
$MaxCacheMB = 50GB
$LogFile = "C:\Users\Public\Documents\Scripts\cleanup.log"

Add-Content $LogFile "`n[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Cleanup started"

# --- Age-based cleanup ---
Get-ChildItem $CacheDir -File -Recurse | Where-Object { $_.Name -notlike "*.lastplayed" } | ForEach-Object {
    $marker = "$($_.FullName).lastplayed"
    if (Test-Path $marker) {
        $ageDays = [int]((Get-Date) - (Get-Item $marker).LastWriteTime).TotalDays
        Add-Content $LogFile "DEBUG: $($_.FullName) days since last played: $ageDays"
        if ($ageDays -gt $MaxAgeDays) {
            Add-Content $LogFile "Deleting (age): $($_.FullName)"
            Remove-Item $_.FullName -Force
            Remove-Item $marker -Force
        }
    } else {
        Add-Content $LogFile "WARNING: $($_.FullName) has no .lastplayed marker"
    }
}

# --- Size-based pruning ---
$files = Get-ChildItem $CacheDir -File -Recurse | Where-Object { Test-Path ($_.FullName + ".lastplayed") } | Sort-Object { (Get-Item ($_.FullName + ".lastplayed")).LastWriteTime }
$totalSize = ($files | Measure-Object Length -Sum).Sum
while ($totalSize -gt $MaxCacheMB) {
    $fileToDelete = $files[0]
    Add-Content $LogFile "Deleting (size): $($fileToDelete.FullName)"
    Remove-Item $fileToDelete.FullName -Force
    Remove-Item "$($fileToDelete.FullName).lastplayed" -Force
    $files = $files[1..($files.Count-1)]
    $totalSize = ($files | Measure-Object Length -Sum).Sum
}

Add-Content $LogFile "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Cleanup finished"
