#PC_Status_Check: Ruadhán Mulcahy
$opt = 'r'
$path = "C:\Remote_Machines\error.txt"

if (Test-Path -path $path)
{ 
    
    
} else {

    New-Item $path -type file
}

while($opt -eq 'r') {

    $names = Get-Content -Path "C:\Remote_Machines\PC-List.txt"
    $count = $($names).count
    $x = -1

    clear

    while($x++ -lt $count - 1) {
    
        $name = $names[$x]

        if (Test-Connection -BufferSize 32 -Count 1 -ComputerName $name -Quiet) {
            
            $obj = quser /server:$name 2>$path
            $count2 = $obj.count
            $active = 0

            if($count2 -ne 0) {
            
                $i = 0

                while($i++ -lt $count2 - 1) {
    
                    $obj1 = $obj | Select -Index $i
                    $obj1 = "$obj1".substring(46,6)

                    if($obj1 -eq "ACTIVE") {

                        $active = 1
                        $word = $obj | Select -Index $i
                        $word = $word.substring(0, 23)
                    }
                }
                if($active -eq 0) {
            
                    Write-Host ""$name" - PC Available"

                } else {
                
                    Write-Host ""$name" - PC In use by USER:"$word""
                }
            } else {

                Write-Host ""$name" - PC Available"
            }
        } else {
    
            Write-Host ""$name" - PC is offline"
        }
    } 

    $opt = 'n'
    Write-Host "------------------------------------------------------------------"
    $opt = Read-Host -Prompt " Press 'r' to retry"
}

  