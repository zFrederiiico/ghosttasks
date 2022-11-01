function NovoEmail(){
    
    # INICIO DO WHILE DE REPETIÇÃO DA FUNÇÃO
    while($WhileNovoEmail -ne "N"){
    #Clear-Host

    # SELECIONA O USUÁRIO QUE VAI TER A CAIXA DE EMAIL CRIADA.
    $UserLogon = Read-Host "INFORME O USUÁRIO QUE DESEJA CRIAR CAIXA DE EMAIL"
    $UserLogonProperties = Get-ADUser -Identity $UserLogon
    #$UserLogonUPN = $UserLogon + "@domainMail.org.br"
    #$UserLogonOnMicrosoft = $UserLogon + "@domainMailMicrosoft.mail.onmicrosoft.com"

    
    # VERIFICA A EXISTENCIA DO USUÁRIO
    if (!$UserLogonProperties){

        #Clear-Host
        Write-Host "USUÁRIO INEXISTENTE!!"
    
    } else{
        
        # CONECTA REMOTAMENTE AO EXCHANGE MANAGEMENT SHELL
        $ExchangeConnection = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://domainmail.domain.local/PowerShell/ -Authentication Kerberos
        Import-PSSession $ExchangeConnection | Out-Null


        # HABILITA A CAIXA DE CORREIO NO EXCHANGE ONLINE
        Enable-RemoteMailbox -Identity ($UserLogon + "@domainMail.org.br") -RemoteRoutingAddress ($UserLogon + "@domainMail.mail.onmicrosoft.com") | Out-Null
        

        # DESCONECTA DO EXCHANGE MANAGEMENT SHELL
        Remove-PSSession $ExchangeConnection
        
        
        # PRINTA PRO USUÁRIO O RETORNO DA CRIAÇÃO
        #Clear-Host
        Write-Host
        Write-Host "CAIXA DE EMAIL CRIADA!!"
        Write-Host "USUÁRIO:" $UserLogonProperties.SAMAccountName 
        Write-Host "EMAIL:" $UserLogonProperties.Mail
        Write-Host


    }

    # FIM DO WHILE DA FUNÇÃO
    $WhileNovoEmail = (Read-Host "DESEJA CRIAR OUTRA CAIXA DE EMAIL? [Y = SIM] [N = NÃO]").ToUpper()
    }
# FIM DA FUNÇÃO
}