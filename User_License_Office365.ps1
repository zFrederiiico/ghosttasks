function AtrelarLicenca(){

    # CONECTA REMOTAMENTE AO OFFICE 365
    Connect-ExchangeOnline -UseRPSSession
    Connect-MsolService
    

    
    # INICIO DO WHILE DA FUNÇÃO
    while ($WhileLicenca -ne "N"){
    Clear-Host
    
    # SELECIONA QUAL USUÁRIO VAI RECEBER A LICENÇA
    $UserLogon = Read-Host "QUAL USUÁRIO RECEBERÁ LICENÇA [NOME.SOBRENOME]"


    # VERIFICA SE O USUÁRIO JA FOI SINCRONIZADO COM O 365
    $VerifyUserLogon = Get-MsolUser -UserPrincipalName ($UserLogon + "@domainMail.org.br")


    if(!$VerifyUserLogon){
    
        Clear-Host
        Write-Host @"

             "USUÁRIO AINDA NÃO SINCRONIZADO COM O OFFICE 365! AGUARDE A REPLICAÇÃO!"

"@
    }else {
        
        # ESCOLHE A LICENÇA QUE SERÁ UTILIZADA
        $Licence = Read-Host "QUAL LICENÇA SERÁ ATRELADA AO USUÁRIO [1 - LICENÇA MICROSOFT 365 A3 | 2 - OFFICE 365 A1]"


        if($Licence -eq 1){

            # ATRIBUI A LICENÇA NO USUÁRIO
            Get-MsolUser -UserPrincipalName ($UserLogon + "@domainmail.org.br") | Set-MsolUser -UsageLocation BR
            Set-MsolUserLicense -UserPrincipalName ($UserLogon + "@domainmail.org.br") -AddLicenses "domainlicense:M365EDU_A3_FACULTY"
            Set-Mailbox -Identity ($UserLogon + "@domainmail.org.br") -LitigationHoldEnabled $True


            # RETORNA PARA O USUÁRIO QUE A LICENÇA FOI ATRIBUIDA
            Clear-Host
            Write-Host @"

            LICENÇA ATRIBUIDA COM SUCESSO!

"@
        } elseif ($Licence -eq 2){

            # ATRIBUI A LICENÇA NO USUÁRIO
            Get-MsolUser -UserPrincipalName ($UserLogon + "@domainmail.org.br") | Set-MsolUser -UsageLocation BR
            Set-MsolUserLicense -UserPrincipalName ($UserLogon + "@domainmail.org.br") -AddLicenses "domainlicense:STANDARDWOFFPACK_FACULTY"
            Set-Mailbox -Identity ($UserLogon + "@domainmail.org.br") -LitigationHoldEnabled $True

            
            # PRINTA PRO USUÁRIO QUE A LICENÇA FOI ATRIBUIDA
            Clear-Host
            Write-Host @"

            LICENÇA ATRIBUIDA COM SUCESSO!

"@
        }else {

            # CASO TENHA ESCOLHIDO ALGO SEM SER 1 E 2

            Clear-Host
            Write-Host @"

            OPÇÃO INVÁLIDA!!

"@
        }

    }
    

    # FIM DO WHILE DA FUNÇÃO
    $WhileLicença = (Read-Host "DESEJA REALIZAR OUTRO LICENCIAMENTO? [Y = SIM] [N = NÃO]").ToUpper()
    }

# FIM DA FUNÇÃO
}