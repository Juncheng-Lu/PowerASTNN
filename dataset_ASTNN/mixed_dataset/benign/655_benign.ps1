



 -||-> .{
 -||-> $one = @( -||-> ( -||-> 1320,500 <-||- ),( -||-> 990,250 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 1188,250 <-||- ),( -||-> 1320,125 <-||- ),( -||-> 1188,125 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 990,250 <-||- ),( -||-> 880,500 <-||- ),( -||-> 880,250 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 1320,500 <-||- ),( -||-> 1188,250 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 990,750 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 1188,500 <-||- ),( -||-> 1320,500 <-||- ),( -||-> 1056,500 <-||- ),( -||-> 880,500 <-||- ),( -||-> 880,500 <-||- ) <-||- ) <-||- 
 -||-> $two = @( -||-> ( -||-> 1188,500 <-||- ),( -||-> 1408,250 <-||- ),( -||-> 1760,500 <-||- ),( -||-> 1584,250 <-||- ),( -||-> 1408,250 <-||- ),( -||-> 1320,750 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 1320,500 <-||- ),( -||-> 1188,250 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 990,500 <-||- ),( -||-> 990,250 <-||- ),( -||-> 1056,250 <-||- ),( -||-> 1188,500 <-||- ),( -||-> 1320,500 <-||- ),( -||-> 1056,500 <-||- ),( -||-> 880,500 <-||- ),( -||-> 880,500 <-||- ) <-||- ) <-||- 
 -||-> $three = @( -||-> ( -||-> 660,1000 <-||- ),( -||-> 528,1000 <-||- ),( -||-> 594,1000 <-||- ),( -||-> 495,1000 <-||- ),( -||-> 528,1000 <-||- ),( -||-> 440,1000 <-||- ),( -||-> 419,1000 <-||- ),( -||-> 495,1000 <-||- ),( -||-> 660,1000 <-||- ),( -||-> 528,1000 <-||- ),( -||-> 594,1000 <-||- ),( -||-> 495,1000 <-||- ),( -||-> 528,500 <-||- ),( -||-> 660,500 <-||- ),( -||-> 880,1000 <-||- ),( -||-> 838,2000 <-||- ),( -||-> 660,1000 <-||- ),( -||-> 528,1000 <-||- ),( -||-> 594,1000 <-||- ),( -||-> 495,1000 <-||- ),( -||-> 528,1000 <-||- ),( -||-> 440,1000 <-||- ),( -||-> 419,1000 <-||- ),( -||-> 495,1000 <-||- ),( -||-> 660,1000 <-||- ),( -||-> 528,1000 <-||- ),( -||-> 594,1000 <-||- ),( -||-> 495,1000 <-||- ),( -||-> 528,500 <-||- ),( -||-> 660,500 <-||- ),( -||-> 880,1000 <-||- ),( -||-> 838,2000 <-||- ) <-||- ) <-||- 
 -||-> [Console]::Beep(658,125) <-||- 
 -||-> foreach ($N in  -||-> $one <-||- ) {  -||-> [Console]::Beep($N[0],$N[1]) <-||-  } <-||- 
 -||-> Sleep -M 250 <-||- 
 -||-> foreach ($N in  -||-> $two <-||- ) {  -||-> [Console]::Beep($N[0],$N[1]) <-||-  } <-||- 
 -||-> Sleep -M 500 <-||- 
 -||-> foreach ($N in  -||-> $one <-||- ) {  -||-> [Console]::Beep($N[0],$N[1]) <-||-  } <-||- 
 -||-> Sleep -M 250 <-||- 
 -||-> foreach ($N in  -||-> $two <-||- ) {  -||-> [Console]::Beep($N[0],$N[1]) <-||-  } <-||- 
 -||-> Sleep -M 500 <-||- 
 -||-> foreach ($N in  -||-> $three <-||- ) {  -||-> [Console]::Beep($N[0],$N[1]) <-||-  } <-||- 
} <-||- 



 -||-> .{
 -||-> $mario = @( -||-> ( -||-> 130,100 <-||- ),( -||-> 262,100 <-||- ),( -||-> 330,100 <-||- ),( -||-> 392,100 <-||- ),( -||-> 523,100 <-||- ),( -||-> 660,100 <-||- ),( -||-> 784,300 <-||- ),( -||-> 660,300 <-||- ),( -||-> 146,100 <-||- ),( -||-> 262,100 <-||- ),( -||-> 311,100 <-||- ),( -||-> 415,100 <-||- ),( -||-> 523,100 <-||- ),( -||-> 622,100 <-||- ),( -||-> 831,300 <-||- ),( -||-> 622,300 <-||- ),( -||-> 155,100 <-||- ),( -||-> 294,100 <-||- ),( -||-> 349,100 <-||- ),( -||-> 466,100 <-||- ),( -||-> 588,100 <-||- ),( -||-> 699,100 <-||- ),( -||-> 933,300 <-||- ),( -||-> 933,100 <-||- ),( -||-> 933,100 <-||- ),( -||-> 933,100 <-||- ),( -||-> 1047,400 <-||- ) <-||- ) <-||- 
 -||-> foreach ($N in  -||-> $mario <-||- ) {  -||-> [Console]::Beep($N[0],$N[1]) <-||-  } <-||- 
} <-||- 

 -||-> .{
    
     -||-> while ( -||-> 1 <-||- ) {
         -||-> 1..2 | % {  -||-> [console]::beep(3900, 225) <-||-  } <-||- 
         -||-> Start-Sleep -Milliseconds 450 <-||- 
    } <-||- 
} <-||- 


