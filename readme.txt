Game Version
------------

4.2.4


Remove *.meta files
-------------------

Get-ChildItem * -Force -Include *.meta -Recurse | Remove-Item -Force


Rename *.lua.bytes to *.lua
---------------------------

Get-ChildItem -Filter *.lua.bytes -Recurse | Rename-Item -NewName { $_.Name -replace '\.lua\.bytes$', '.lua' }


Rename *.bytes to *.csv
---------------------------

Get-ChildItem -Filter *.bytes -Recurse | Rename-Item -NewName { $_.Name -replace '\.bytes$', '.csv' }

