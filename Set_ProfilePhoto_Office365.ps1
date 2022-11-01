function SetProfilePhoto(){
    Clear-Host

    # LEMBRETE PARA A FUNÇÃO FUNCIONAR
    Write-Host @"

    LEMBRE-SE!
    VOCE PRECISA TER A PASTA 'Fotos' NO DIRETÓROIO 'C:\TEMP\' 
    TODOS OS ARQUIVOS DA PASTA DEVEM SER COM PADRÃO [NOME.USUARIO.JPG]

"@

    $StartTask = Read-Host "DESEJA COMEÇAR O PROCESSO DE APLICAÇÃO DAS FOTOS [1 = SIM] [0 = NÃO]"


    # VERIFICA SE O USUÁRIO QUER INICIAR O PROCESSO E SE EXISTE A PASTA FOTOS    
    if($StartTask -ne 2){
        
        # COLOCA A PASTA EM UMA VARIAVEL
        $PathPhotos = "C:\Temp\Fotos\"



        if(!(Test-Path $PathPhotos)){

            Clear-Host
            Write-Host @"

            VOCE NÃO POSSUI A PASTA 'C:\Temp\Fotos'!!

"@  

        } else{
            
            Connect-ExchangeOnline -UseRPSSession
            Clear-Host

            # VERIFICA OS ARQUIVOS QUE EXISTEM NA PASTA E CORRIGE OS NOMES
            $UserLogonList = (Get-ChildItem $PathPhotos).Name
            $UserLogonOutJPG = $UserLogonList.Replace('.jpg', "")
        
            
            # COMEÇA A FUNÇÃO EM TODOS QUE ESTIVEREM NA PASTA
            $UserLogonOutJPG | ForEach-Object {


            # VERIFICA SE A FOTO ESTÁ NA MESMA EXTENSÃO
            $PhotoFile = $PathPhotos + $_ + ".jpg"


            # COLOCA A FOTO NO PORTAL DO ADMIN CENTER PARA O USUÁRIO
            Set-UserPhoto $_ -PictureData ([System.IO.File]::ReadAllBytes($PhotoFile)) -Confirm:$false

            
            # PRINTA PARA O USUÁRIO QUE A FOTO FOI ADICIONADA
            Write-Host "FOTO ADICIONADA PARA O USUÁRIO:" $_

            } 
            
            Write-Host "TODAS FOTOS FORAM ADICIONADAS!!"
            Pause
        }

    }else {

        Clear-Host
        Write-Host @"

        VOCE OPTOU POR NÃO INICIAR A FUNÇÃO!!

"@
    pause
    }

# FIM DA FUNÇÃO
}