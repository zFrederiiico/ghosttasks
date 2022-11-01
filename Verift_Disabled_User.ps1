function VerifyUserForDisable(){

    Connect-MsolService

    while($WhileDesabilitarRH -ne "N"){

        Clear-Host

        # VERIFICA O USUÁRIO QUE DESEJA E SUAS PROPRIEDADES
        $UserLogon = Read-Host "QUAL NOME COMPLETO DO COLABORADOR QUE DESEJA FAZER A CONSULTA"
        $UserLogonProperties = (Get-ADUser -Filter {Name -eq $UserLogon} -Properties SAMAccountName, MemberOf)


        if(!$UserLogonProperties){

            Clear-Host
            Write-Host @"

            USUÁRIO INEXISTENTE!!

"@
        } else{

            # VERIFICA SE O USUÁRIO POSSUI LICENÇA
            $UserLogonLicence = Get-MsolUser -UserPrincipalName ($UserLogonProperties.SamAccountName + "@domainmail.org.br")


            # VARIAVEIS DE PRINT
            $PrintLicensed = $UserLogonLicence.IsLicensed -replace ("True", "SIM") -replace ("False", "NÃO")
            $PrintEnabled = $UserLogonProperties.Enabled -replace ("True", "SIM") -replace ("False", "NÃO")


            # PRINTA A VERIFICAÇÃO PARA O USUÁRIO0
            Clear-Host
            Write-Host
            Write-Host "DADOS DO USUÁRIO:" $UserLogonProperties.SamAccountName "| VERIFICAÇÃO!!"
            Write-Host
            Write-Host "USUÁRIO HABILITADO:" $PrintEnabled
            Write-Host "LICENÇA NO 365:" $PrintLicensed
            Write-Host "OU ATUAL:" $UserLogonProperties.DistinguishedName
            Write-Host

            
            # VERIFICA SE DEVERÁ SER DESABILITADO OU NÃO
            $VerifyDisable = Read-Host "CONFIRMAR DESLIGAMENTO DE USUÁRIO? [1 = SIM] [0 = NÃO]"

            if($VerifyDisable -ne 1){

                Clear-Host
                Write-Host @"

                VOCE ESCOLHEU NÃO DESABILITAR O USUÁRIO!!

"@
            }else {

                # REALIZA OS PROCESSOS DE DESABILITAR
                Get-ADUser -Identity $UserLogonProperties.SamAccountName | Move-ADObject -TargetPath "OU"
                Set-ADUser -Identity $UserLogonProperties.SamAccountName -Enabled $False


                # REMOVE TODOS OS GRUPOS DE ACESSO
                $UserLogonProperties.MemberOf | ForEach-Object {Get-ADGroup $_ | Remove-ADGroupMember -Confirm:$False -member $UserLogonProperties.SamAccountName}
                

                # PRINT RETORNO ATUAL DO USUÁRIO
                $PrintEnabledNow = $UserLogonProperties.Enabled -replace ("True", "SIM") -replace ("False", "NÃO")


                # REMOVE AS LICENÇAS QUE O USUÁRIO TIVER NO 365
                $LicenceUser = Get-MsolUser -UserPrincipalName ($UserLogonProperties.SamAccountName + "@domainmail.org.br") | Select-Object -ExpandProperty Licenses
                Set-MsolUserLicense -UserPrincipalName ($UserLogonProperties.SamAccountName + "@domainmail.org.br") -RemoveLicenses $LicenceUser.AccountSkuId

                # RETORNA PRO USUÁRIO O STATUS ATUAL DO USUÁRIO NO AD
                $UserLogonPropertiesDisabled = Get-ADUser -Identity $UserLogonProperties.SamAccountName -Properties MemberOf
                Clear-Host
                Write-Host
                Write-Host "DADOS DO USUÁRIO:" $UserLogonProperties.SamAccountName "| ATUAL!!"
                Write-Host
                Write-Host "USUÁRIO HABILITADO:" $PrintEnabledNow
                Write-Host "OU ATUAL:" $UserLogonPropertiesDisabled.DistinguishedName
                Write-Host

            }

        }
        

    # FIM DO WHILE DA FUNÇÃO
    $WhileDesabilitarRH = (Read-Host "DESEJA VERIFICAR OUTRO USUÁRIO? [Y = SIM] [N = NÃO]").ToUpper()
    }
# FIM DA FUNÇÃO
}