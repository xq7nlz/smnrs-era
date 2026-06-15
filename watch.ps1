while ($true) {
  $file = "main.lua"
  $last = (Get-Item $file).LastWriteTime
  while ((Get-Item $file).LastWriteTime -eq $last) { Start-Sleep -Milliseconds 500 }
  .\lua55.exe $file
}
