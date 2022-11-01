function AlterarSenha(){

    while($WhileChangePassword -ne "N"){

        # INFORMA O USUÁRIO QUE TERÁ A SENHA TROCADA E VERIFICA EXISTENCIA
        $UserLogon = Read-Host "QUAL USUÁRIO DESEJA ALTERAR A SENHA [NOME.SOBRENOME]"
        $VerifyUser = Get-ADUser -Filter {SamAccountName -eq $UserLogon}


        if(!$VerifyUser){
        
            Clear-Host
            Write-Host @"

            USUÁRIO INEXISTENTE!!

"@
        }else{

        # ALTERA A SENHA PARA SENHA DO USUÁRIO
        Set-ADAccountPassword -Identity $UserLogon -Reset -NewPassword (ConvertTo-SecureString "SENHA" -AsPlainText -Force)
        Set-ADUser -Identity $UserLogon -ChangePasswordAtLogon $True

        # RETORNA PRO USUÁRIO QUE A SENHA FOI ALTERADA
        Clear-Host
        Write-Host "Senha alterada com sucesso!!"
        Write-Host
        Write-Host "USUÁRIO:" $UserLogon
        Write-Host "Senha: senha"
        Write-Host
        }

    # FIM DO WHILE DA FUNÇÃO
    $WhileChangePassword = (Read-Host "DESEJA ALTERAR A SENHA DE OUTRO USUÁRIO? [Y = SIM] [N = NÃO]").ToUpper()
    }
# FIM DA FUNÇÃO
}
