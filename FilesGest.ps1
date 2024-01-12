<#
.NOTES
 
Nom du fichier :    FilesGest.ps1
Prerequis :         PowerShell 7.4.0
Version :           1.0
Auteur :            Cyril Napoleone
Date de creation :  15.12.23
Lieu :              ETML Sebeillon
 
.SYNOPSIS
 Agit sur les fichiers d'un repertoire donne en parametre selon ce qui est choisi
 
.DESCRIPTION
Ce script permet de choisir entre plusieurs options d'actions sur les fichiers :
.Supprimer ou deplacer les fichiers qui correspondent aux criteres donnes (entre 1 et 4, l'utilisateur choisit combien il en veut et lequels il veut)
.Gere les doublons (fichiers qui ont le meme contenus mais pas le meme nom)
.Allege le repertoire en selectionnant les fichiers lourds et/ou peu utilises (l'utilisateur choisit quel critere lui importe puis choisit ce qu'il veut supprimer)

.PARAMETER path
Repertoire dans lequel le gestionnaire va agir

.INPUTS
 -
 
.OUTPUTS
 -
 
.EXAMPLE
./filesgest.ps1

Que voulez vous faire ?

        a) Chercher via criteres
        b) Gestion des doublons de contenu
        c) Allegement du repertoire

        d) Quitter

    >:b

    No identical files detected !


#>

param(
    [Parameter(mandatory=$false)]
    [string]$path=$PSScriptRoot
)

if(Test-Path $path){
    clear-host
}else{
    Clear-Host
    Write-Host "Chemin non valide, veuillez reessayer" -ForegroundColor Red
    exit
}


while(1){
    $menuChoice = read-host "`nQue voulez vous faire ?

        a) Chercher via criteres
        b) Gestion des doublons de contenu
        c) Allegement du repertoire
        
        d) Quitter
        
    >"  

    switch ($menuChoice){
        "a"{
            

        }

        #Gestion des doublons
        "b"{
            clear-host
            $files = Get-ChildItem $path -Recurse
            $identicalFiles = @()
            $nbIdentiticalFiles = 0

            #Comparaison de chaques fichiers entre eux
            for ($i = 0; $i -lt $files.Count; $i++) {
                write-host "Analyse du répertoire en cours...  ($i/$($files.count))" -foregroundcolor darkyellow
                for ($j = $i + 1; $j -lt $files.Count; $j++) {
                    
                    #verifie si c'est un dossier ou un fichier, si dossier alors ne pas faire get-content
                    $verif1 = get-item $files[$i].FullName
                    $verif2 = get-item $files[$j].FullName

                    if($verif1 -is [system.io.fileinfo] -and $verif2 -is [system.io.fileinfo]){
                        $file1 = Get-Content $files[$i].FullName 
                        $file2 = Get-Content $files[$j].FullName 
                
                        # Comparez le contenu des fichiers
                        if ($file1 -eq $file2) {
                            $identicalFiles += @{
                                File1 = $files[$i].BaseName
                                File2 = $files[$j].BaseName
                                File1Root = $files[$i].Fullname
                                File2Root = $files[$j].Fullname
                            }
                            $nbIdentiticalFiles += 1
                        }
                    }
                }
            }
            #Aucun doublons
            if($nbIdentiticalFiles -eq 0){
                clear-host
                write-host "Aucun doublons détectés !" -ForegroundColor Green
            }else{
                #Doublons détectés
                clear-host
                write-host "$nbIdentiticalFiles Doublons détectés ! (voir ci-dessous)" -ForegroundColor Red

                #Affichage des doublons
                foreach($pair in $identicalFiles){
                    write-host "       - $($pair.File1) and $($pair.File2)" -ForegroundColor Red
                }

                #Choix de suppression ou non
                do{
                    $deleteChoice = read-host "`nVoulez vous supprimer les fichiers doublons ? O/N" 

                }while($deleteChoice -ne "y" -and $deleteChoice -ne "n")

                switch ($deleteChoice){
                    #L'utilisateur veut supprimer ses doublons
                    "o"{
                        clear-host
                        #Suppression des fichiers doublons
                        foreach($pair in $identicalfiles){
                            remove-item $pair.File1Root -ErrorAction:Ignore
                            remove-item $pair.File2Root -ErrorAction:Ignore
                            write-host "Suppression des doublons en cours..." -foregroundcolor darkyellow
                        }
                        write-host "Doublons supprimés avec succès !" -foregroundcolor green
                    }
                    #L'utilisateur ne désire pas supprimer ses doublons
                    "n"{
                        clear-host
                        write-host "Doublons non-supprimés `n" -foregroundcolor blue
                    }
                }
            }
        }

        "c"{
            clear-host
            $unusedHeavyFiles = Get-Childitem $path -recurse -file | sort-object length, LasteWriteTime | select-object -last 10
            write-host "Voici une séléction des fichiers qui sont les plus lourds de votre répertoire et que vous utilisez le moins :`n"
            foreach($file in $unusedHeavyFiles){
                write-host "   - $($file.Name)" -ForegroundColor darkyellow -nonewline
                write-host " Taille : " -nonewline -foregroundcolor blue
                write-host "$($file.length) " -nonewline -foregroundcolor green
                write-host " Dernière utilisation : " -nonewline -foregroundcolor blue
                write-host "$($file.lastWriteTime)" -foregroundcolor green
            }
            
            

        }

        "d"{
            Clear-Host
            exit
        }
    }
}