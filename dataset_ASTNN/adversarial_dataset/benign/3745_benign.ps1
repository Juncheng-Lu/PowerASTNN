
 -||-> Set-PSFConfig -Module PSFramework -Name 'Serialization.WorkingDirectory' -Value $script:path_typedata -Initialize -Validation "string" -Description "The folder in which registered type extension files are placed before import. Relevant for Register-PSFTypeSerializationData." <-||- 

