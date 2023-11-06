# create sql database with entraadmin user
if ($null -eq $sqladmin) {
    Write-Error 'Please set the $sqladmin variable to the SQL Server admin account name'
    exit
}

$user = az ad user show --id $sqladmin | ConvertFrom-Json | Select-Object id
$usersid = $user.id

az deployment group create --resource-group $rg --template-file .\Database\SQLDatabase\create_sqldb_entraadmin.json --parameters adminLogin=$sqladmin usersid=$usersid

