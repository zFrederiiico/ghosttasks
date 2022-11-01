function VerifyUserForDisable(){

    Connect-MsolService

    while($WhileDesabilitarRH -ne "N"){

        Clear-Host

        # VERIFICA O USU�RIO QUE DESEJA E SUAS PROPRIEDADES
        $UserLogon = Read-Host "QUAL NOME COMPLETO DO COLABORADOR QUE DESEJA FAZER A CONSULTA"
        $UserLogonProperties = (Get-ADUser -Filter {Name -eq $UserLogon} -Properties SAMAccountName, MemberOf)


        if(!$UserLogonProperties){

            Clear-Host
            Write-Host @"

            USU�RIO INEXISTENTE!!

"@
        } else{

            # VERIFICA SE O USU�RIO POSSUI LICEN�A
            $UserLogonLicence = Get-MsolUser -UserPrincipalName ($UserLogonProperties.SamAccountName + "@domainmail.org.br")


            # VARIAVEIS DE PRINT
            $PrintLicensed = $UserLogonLicence.IsLicensed -replace ("True", "SIM") -replace ("False", "N�O")
            $PrintEnabled = $UserLogonProperties.Enabled -replace ("True", "SIM") -replace ("False", "N�O")


            # PRINTA A VERIFICA��O PARA O USU�RIO0
            Clear-Host
            Write-Host
            Write-Host "DADOS DO USU�RIO:" $UserLogonProperties.SamAccountName "| VERIFICA��O!!"
            Write-Host
            Write-Host "USU�RIO HABILITADO:" $PrintEnabled
            Write-Host "LICEN�A NO 365:" $PrintLicensed
            Write-Host "OU ATUAL:" $UserLogonProperties.DistinguishedName
            Write-Host

            
            # VERIFICA SE DEVER� SER DESABILITADO OU N�O
            $VerifyDisable = Read-Host "CONFIRMAR DESLIGAMENTO DE USU�RIO? [1 = SIM] [0 = N�O]"

            if($VerifyDisable -ne 1){

                Clear-Host
                Write-Host @"

                VOCE ESCOLHEU N�O DESABILITAR O USU�RIO!!

"@
            }else {

                # REALIZA OS PROCESSOS DE DESABILITAR
                Get-ADUser -Identity $UserLogonProperties.SamAccountName | Move-ADObject -TargetPath "OU"
                Set-ADUser -Identity $UserLogonProperties.SamAccountName -Enabled $False


                # REMOVE TODOS OS GRUPOS DE ACESSO
                $UserLogonProperties.MemberOf | ForEach-Object {Get-ADGroup $_ | Remove-ADGroupMember -Confirm:$False -member $UserLogonProperties.SamAccountName}
                

                # PRINT RETORNO ATUAL DO USU�RIO
                $PrintEnabledNow = $UserLogonProperties.Enabled -replace ("True", "SIM") -replace ("False", "N�O")


                # REMOVE AS LICEN�AS QUE O USU�RIO TIVER NO 365
                $LicenceUser = Get-MsolUser -UserPrincipalName ($UserLogonProperties.SamAccountName + "@domainmail.org.br") | Select-Object -ExpandProperty Licenses
                Set-MsolUserLicense -UserPrincipalName ($UserLogonProperties.SamAccountName + "@domainmail.org.br") -RemoveLicenses $LicenceUser.AccountSkuId

                # RETORNA PRO USU�RIO O STATUS ATUAL DO USU�RIO NO AD
                $UserLogonPropertiesDisabled = Get-ADUser -Identity $UserLogonProperties.SamAccountName -Properties MemberOf
                Clear-Host
                Write-Host
                Write-Host "DADOS DO USU�RIO:" $UserLogonProperties.SamAccountName "| ATUAL!!"
                Write-Host
                Write-Host "USU�RIO HABILITADO:" $PrintEnabledNow
                Write-Host "OU ATUAL:" $UserLogonPropertiesDisabled.DistinguishedName
                Write-Host

            }

        }
        

    # FIM DO WHILE DA FUN��O
    $WhileDesabilitarRH = (Read-Host "DESEJA VERIFICAR OUTRO USU�RIO? [Y = SIM] [N = N�O]").ToUpper()
    }
# FIM DA FUN��O
}