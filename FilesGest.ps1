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

#>

param(
    [Parameter(mandatory=$false)]
    [string]$path=$PSScriptRoot
)

if(Test-Path $path){
    $files = Get-ChildItem $path -Recurse
    clear-host
}else{
    Clear-Host
    Write-Host "Chemin non valide, veuillez reessayer" -ForegroundColor Red
    exit
}



$menuChoice = read-host "Que voulez vous faire ?

    a) Chercher via criteres
    b) Gestion des doublons de contenu
    c) Allegement du repertoire
    
    d) Quitter
    
>"


    

switch ($menuChoice){
    "a"{
        

    }

    "b"{
        $identicalFiles = @()
        $nbIdentiticalFiles = 0

        for ($i = 0; $i -lt $files.Count; $i++) {
            for ($j = $i + 1; $j -lt $files.Count; $j++) {
                $file1 = Get-Content $files[$i].FullName
                $file2 = Get-Content $files[$j].FullName 
        
                # Comparez le contenu des fichiers
                if ($file1 -eq $file2) {
                    $identicalFiles += @{
                        File1 = $files[$i].BaseName
                        File2 = $files[$j].BaseName
                    }
                    $nbIdentiticalFiles++
                }
                
            }
        }
        if($nbIdentiticalFiles -eq 0){
            write-host "No identical files detected !" -ForegroundColor Green
        }else{
            write-host "$nbIdentiticalFiles identical files has been detected !" -ForegroundColor Red
        }
        #demander si ils veulent les supprimer, y/n 
    }

    "c"{

    }

    "d"{
        Clear-Host
        exit
    }
}