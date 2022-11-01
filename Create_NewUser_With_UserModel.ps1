function NovoUsuario(){

    # INICIO DA FUNÇÃO COM WHILE DE REPETIÇÃO
    while($WhileNovoUser -ne "N"){
    Clear-Host


    # REGISTRA USUÁRIO MODELO PARA CRIAÇÃO E CAPTURA AS PROPRIEDADES
    $UserModelName = Read-Host "INFORME O NOME COMPLETO DO USUÁRIO MODELO"
    $UserModelProperties = Get-ADUser -Filter {Name -eq $UserModelName} -Properties *
    $UserModelPropertiesToNewUser = Get-ADUser -Filter {Name -eq $UserModelName} -Properties Office, description


    # VERIFICA SE O USUÁRIO MODELO EXISTE
    if (!$UserModelProperties){
        Write-Host "USUÁRIO MODELO INEXISTENTE!!"
    } else {


        # REGISTRA O NOME COMPLETO DO USUÁRIO QUE SERÁ CRIADO
        $NewUserFullName = Read-Host "INFORME O NOME COMPLETO DO NOVO USUÁRIO"


        # AJUSTA O NOME COMPLETO PARA A CRIAÇÃO DO USERLOGON
        $NewUserFullNameReplace = $NewUserFullName.Replace("ç","c").Replace("ã","a").Replace("á","a").Replace("â","a").Replace("õ","o").Replace("ó","o").Replace("ô","o").Replace("é","e").Replace("ê","e").Replace("Ç","c").Replace("Á","a").Replace("Ã","a").Replace("Â","a").Replace("Õ","o").Replace("Ó","o").Replace("Ô","o").Replace("É","e").Replace("Ê","e").Replace("í","i")


        # TRANSFORMA O NOME COMPLETO EM INDICES
        $NewUserFullNameSplit = $NewUserFullNameReplace.Split()


        # VERIFICA A DISPONIBILIDADE DE LOGON
        $ArrayUser = @()
        $ExistLogin = @()
        $Index = 0


        # DELETA TODOS OS SOBRENOMES 'PEQUENOS'
        foreach ($Campo in $NewUserFullNameSplit){
            if ($Campo -ne "da" -and $Campo -ne "de" -and $Campo -ne "do" -and $Campo -ne "das" -and $Campo -ne "dos" -and $Campo -ne "e" -and $Campo -ne "la" -and $Campo -ne "los" -and $Campo -ne "le"){
                $ArrayUser += $Campo
            }
        }


        # VERIFICA AS DISPONIBILIDADES DE NOME DE USUÁRIO CONFORME A QUANTIDADE DE SOBRENOMES
        if ($ArrayUser.Count -eq 2){
            $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[1].ToLower()
        }

        if ($ArrayUser.Count -eq 3){
            $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[2].ToLower()
            $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[1].ToLower()
            $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[1].Substring(0,1).ToLower() + $ArrayUser[2].ToLower()
            $ExistLogin += $ArrayUser[0].ToLower() + $ArrayUser[1].ToLower() + "." + $ArrayUser[2].ToLower()
        }

        if ($ArrayUser.Count -eq 4) {
	        $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[3].ToLower()
	        $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[2].ToLower()
	        $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[1].ToLower()
	        $ExistLogin += $ArrayUser[0].ToLower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[3].ToLower()
	        $ExistLogin += $ArrayUser[0].ToLower() + $ArrayUser[1].ToLower() + "." + $ArrayUser[3].ToLower()
	        $ExistLogin += $ArrayUser[0].ToLower() + $ArrayUser[1].ToLower() + "." + $ArrayUser[2].ToLower()
	        $ExistLogin += $ArrayUser[0].ToLower() + $ArrayUser[1].ToLower() + "." + $ArrayUser[2].Substring(0,1).ToLower() + $ArrayUser[3].ToLower()

        }

        if ($ArrayUser.count -eq 5) {
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[3].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[2].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[3].Substring(0,1).tolower() + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[3].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[3].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[2].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[3].Substring(0,1).tolower() + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[3].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[4].tolower()
        }

        if ($ArrayUser.count -eq 6) {
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[3].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[2].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[4].Substring(0,1).tolower() + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[3].Substring(0,1).tolower() + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[3].Substring(0,1).tolower() + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[3].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[3].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[2].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[4].Substring(0,1).tolower() + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[3].Substring(0,1).tolower() + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[5].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[3].Substring(0,1).tolower() + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[4].tolower()
	        $ExistLogin += $ArrayUser[0].tolower() + $ArrayUser[1].tolower() + "." + $ArrayUser[2].Substring(0,1).tolower() + $ArrayUser[3].tolower()
        }


        # RETORNA TODOS OS NOMES POSSÍVEIS, LISTANDO OS QUE ESTÃO DISPONÍVEIS OU NÃO
        foreach ($Logon in $ExistLogin){
            $TryExistLogin = Get-ADUser -Filter {SAMAccountName -eq $Logon} 
    
            if(!$TryExistLogin){
               
                Write-Host $Index " - " $Logon "- LIVRE!!"
            
            }else {
                
                $UserExistPropertiesName = Get-ADUser -Identity $logon | Select-Object Name
                Write-Host $Index " - " $Logon "- JA UTILIZADO!! || " $UserExistPropertiesName.Name
            
            } $Index++
        }

        # SELEÇÃO DO USUÁRIO
        $OpcaoPrint = "Qual login deseja utilizar? [0 - " + ($Index - 1) + "]"
        [int]$OpcaoDesejada = Read-Host -Prompt $OpcaoPrint


        # CAPTURA OS PARAMETROS DO NOME DO USUÁRIO PARA CRIAÇÃO
        $DefaultText = (Get-Culture).TextInfo
        $NewUserFullNameCreateLogon = $DefaultText.ToTitleCase($NewUserFullNameReplace.ToLower())
        $Position = $NewUserFullNameCreateLogon.IndexOf(" ")
        $NewUserFirstName = $NewUserFullNameCreateLogon.Substring(0, $Position)
        $NewUserLastName = $NewUserFullNameCreateLogon.Substring($Position + 1)


        # CAPTURA A UPN PARA CRIAÇÃO DE USUÁRIO
        $NewUserUPN = $ExistLogin[$OpcaoDesejada] + "@domainmail.org.br"


        # CORRIGE O DISPLAYNAME DO USUARIO NOVO
        $PositionDN = $UserModelProperties.DisplayName.IndexOf("(")
        $GetUserModelDisplayName = $UserModelProperties.DisplayName.Substring($PositionDN)
        $NewUserDisplayName = $NewUserFullNameCreateLogon + " " + $GetUserModelDisplayName


        # CAPTURA A OU QUE O USUÁRIO MODELO ESTÁ
        $NewUserOU = $UserModelProperties | Select-Object @{n='ParentContainer';e={$_.DistinguishedName -replace "CN=$($_.cn),",''}}

        # VERIFICA AS INFORMAÇÕES PARA CRIAÇÃO DE USUÁRIO
        Clear-Host

        Write-Host "NOME COMPLETO DO NOVO COLABORADOR:" $NewUserFullNameCreateLogon
        Write-Host "USERLOGON DO NOVO COLABORADOR:" $ExistLogin[$OpcaoDesejada]
        Write-Host "DISPLAYNAME DO NOVO COLABORADOR:" $NewUserDisplayName
        Write-Host
        Write-Host
        Write-Host "NOME DO COLABORADOR MODELO:" $UserModelProperties.Name
        Write-Host "USERLOGON DO COLABORADOR MODELO:" $UserModelProperties.SamAccountName
        Write-Host
        $CreateChoice = Read-Host -Prompt "CRIAR NOVO USUÁRIO? [1 = SIM] [0 = NÃO]"
        

        # USUÁRIO SERÁ CRIADO CASO SEJA DIGITADO 'Y'
        if($CreateChoice -ne 1){
            Write-Host "VOCE ESCOLHEU SAIR DA CRIAÇÃO DE USUÁRIO"
        }else {
    
            # REALIZA A CRIAÇÃO DE USUÁRIO E CAPTURA AS PROPRIEDADES
            New-ADUser -Name $NewUserFullNameCreateLogon -SamAccountName $ExistLogin[$OpcaoDesejada] -Instance $UserModelPropertiesToNewUser -UserPrincipalName $NewUserUPN -DisplayName $NewUserDisplayName -GivenName $NewUserFirstName -Surname $NewUserLastName -AccountPassword (ConvertTo-SecureString "M@ristas2022" -AsPlainText -Force) -Path $NewUserOU.ParentContainer -Enabled $True -ScriptPath $UserModelProperties.ScriptPath -EmailAddress $NewUserUPN -Title $UserModelProperties.Title -Department $UserModelProperties.Department -Company $UserModelProperties.Company
            $NewUserProperties = Get-ADUser -Identity $ExistLogin[$OpcaoDesejada] -Properties SAMAccountName, Memberof


            # USUÁRIO SERÁ OBRIGADO A ALTERAR SENHA APÓS PRIMEIRO LOGIN
            Set-ADUser -Identity $ExistLogin[$OpcaoDesejada] -ChangePasswordAtLogon $True


            # REALIZA A CÓPIA DOS ACESSOS DO USUÁRIO MODELO PARA O NOVO USUÁRIO
            $UserModelProperties.MemberOf | Where-Object {$NewUserProperties.MemberOf -notcontains $_} | Add-ADGroupMember -Members $NewUserProperties.SAMAccountName

        }


        # TESTA SE O USUÁRIO FOI CRIADO CORRETAMENTE
        $TestCreateNewUser = Get-ADUser -Identity $ExistLogin[$OpcaoDesejada]


        if (!$TestCreateNewUser){

            Write-Host "USUÁRIO NÃO FOI CRIADO!!"

        }else {

            # DESCREVE AS INFORMAÇÕES DO NOVO COLABORADOR
            Clear-Host
            Write-Host
            Write-Host "USUÁRIO CRIADO COM SUCESSO!!"
            Write-Host
            Write-Host "NOME COMPLETO:" $NewUserFullNameReplace
            Write-Host "USUÁRIO DE REDE:" $ExistLogin[$OpcaoDesejada]
            Write-Host "SENHA DE REDE: M@ristas2022"
            Write-Host "CRIADO EM:" $NewUserOU.ParentContainer
            Write-Host

        }
    }

# FIM DO WHILE DA FUNÇÃO. VERIFICA SE SERÁ CRIADO OUTRO USUÁRIO OU NÃO
$WhileNovoUser = (Read-Host "DESEJA CRIAR OUTRO USUÁRIO? [Y = SIM] [N = NÃO]").ToUpper()
}

# FIM DA FUNÇÃO
}