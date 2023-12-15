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

clear-host

$menuChoice = read-host "Que voulez vous faire ?

    a) Chercher via criteres
    b) Gestion des doublons de contenu
    c) Allegement du repertoire
    
    d) Quitter
    
>"

$files = Get-ChildItem $path -Recurse

switch ($menuChoice){
    "a"{
        

    }

    "b"{

    }

    "c"{

    }

    "d"{
        Clear-Host
        exit
    }
}