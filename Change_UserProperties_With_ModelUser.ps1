function AlteracaoCargoFuncao(){

    while($WhileChangeFunction -ne "N"){

        Clear-Host
    
        # CAPTURA O USUÁRIO QUE MODELO
        $UserModel = Read-Host "INFORME O NOME COMPLETO DO COLABORADOR QUE SERÁ O MODELO DA ALTERAÇÃO"
        $UserModelProperties = Get-ADUser -Filter {Name -eq $UserModel} -Properties *

        # VERIFICA A EXISTENCIA DO USUÁRIO MODELO
        if (!$UserModelProperties) {

            Clear-Host
            Write-Host @"
    
            USUÁRIO MODELO INEXISTENTE!!
    
"@

        }else {
        
        # CAPTURA O USUÁRIO QUE SERÁ ALTERADO
        $UserChangeFunction = Read-Host "INFORME O NOME COMPLETO DO COLABORADOR QUE SERÁ ALTERADO"
        $UserChangeFunctionProperties = Get-ADUser -Filter {Name -eq $UserChangeFunction} -Properties *

        # VERIFICA A EXISTENCIA DO USUÁRIO QUE SERÁ ALTERADO
        if(!$UserChangeFunctionProperties){
            
            Clear-Host
            Write-Host @"
    
            USUÁRIO INEXISTENTE!!
    
"@

        }else{
        
            # VERIFICA SE OS USUÁRIO ESTAO CORRETOS
            Clear-Host
            Write-Host "NOME COMPLETO DO COLABORADOR QUE SERÁ ALTERADO:" $UserChangeFunctionProperties.Name
            Write-Host "USERLOGON DO COLABORADOR QUE SERÁ ALTERADO:" $UserChangeFunctionProperties.SamAccountName
            Write-Host
            Write-Host
            Write-Host "NOME DO COLABORADOR MODELO:" $UserModelProperties.Name
            Write-Host "USERLOGON DO COLABORADOR MODELO:" $UserModelProperties.SamAccountName
            Write-Host
            $ChoiceChange = Read-Host -Prompt "CONFIRMAR ALTERAÇÃO DE USUÁRIO [1 = SIM] [0 = NÃO]"


            if($ChoiceChange -ne 1){

                Clear-Host
                Write-Host @"

                VOCE ESCOLHEU NÃO ALTERAR O USUÁRIO!!

"@
            } else{

                # REMOVE TODOS OS GRUPOS DO USUÁRIO QUE SERÁ TRANSFERIDO
                $UserChangeFunctionProperties.Memberof | ForEach-Object {

                Get-ADGroup $_ | Remove-ADGroupMember -Confirm:$False -Members ($UserChangeFunctionProperties.SAMAccountName)

                }
                Start-Sleep -Seconds 5


                # ADICIONA TODOS OS GRUPOS DO USUÁRIO MODELO NO USUÁRIO QUE SERÁ TRANSFERIDO
                $UserModelProperties.MemberOf | ForEach-Object {

                Get-ADGroup $_ | Add-ADGroupMember -Members ($UserChangeFunctionProperties.SAMAccountName)

                }


                # CAPTURA A OU QUE O USUÁRIO MODELO ESTÁ ALOCADO
                $UserModelOU = $UserModelProperties | Select-Object @{n='ParentContainer';e={$_.distinguishedname -replace "CN=$($_.cn),",''}}


                # CAPTURA O DISPLAY NAME
                $PositionDisplay = $UserModelProperties.DisplayName.IndexOf("(")
                $UserModelDisplayName = $UserModelProperties.DisplayName.Substring($PositionDisplay)
                $UserChangeFunctionDisplayName = $UserChangeFunctionProperties.Name + " " + $UserModelDisplayName


                # ALTERA AS PROPRIEDADES DO USUÁRIO QUE SERÁ ALTERADO
                Set-ADUser -Identity $UserChangeFunctionProperties.SamAccountName -Office $UserModelProperties.Office -ScriptPath $UserModelProperties.ScriptPath -Description $UserModelProperties.Description -DisplayName $UserChangeFunctionDisplayName -Title $UserModelProperties.Title -Department $UserModelProperties.Department -Company $UserModelProperties.Company
                Move-ADObject -Identity $UserChangeFunctionProperties.DistinguishedName -TargetPath $UserModelOU.ParentContainer
        
        
                # PRINTA PRO USUÁRIO QUE A ALTERAÇÃO FOI SUCEDIDA
                Clear-Host
                Write-Host @"

                USUÁRIO ALTERADO COM SUCESSO!!

"@

                }
            }
        }
    # FIM DO WHILE DA FUNÇÃO
    $WhileChangeFunction = (Read-Host "DESEJA ALTERAR OUTRO USUÁRIO? [Y = Sim] [N = Não]").ToUpper()
    }
# FIM DA FUNÇÃO
}