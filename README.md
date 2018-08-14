# Guide de l'utilisateur
## Utilisation générale
L'ensemble des programmes nécessaires à la réalisation des krona_charts sont compris dans le dossier krona_pack_tsv. Ce dossier contient le script principal en lui-même permettant de passer du tsv aux krona_charts, mais également un script R permettant la réalisation d'un certain nombre de mises en forme sur le fichier de base, script R auquel je fais appel dans le script principal. Le script traitement_krona permet la réalisation des krona_charts à partir d'un format de fichier bien précis.
Il s'agit de la dernière étape du script principal. Ce dernier script fait intervenir une fonction de krona stockée dans le répertoire bin.

Pour construire les krona_charts, il suffit d'avoir dans le même répertoire le répertoire krona_pack_tsv contenant tous les scripts nécessaires et le fichier tsv que l'on souhaite traiter, et faire appel au script tsv_to_krona. Le script retournera alors les fichiers html attendus dans un répertoire intitulé "krona_charts".

## Mise en forme du fichier avant traitement 
Voici le script permettant de mettre en forme le fichier tsv en entrée afin qu'il puisse être utilisé dans un second temps pour générer les krona charts.
```bash
mkdir -p mise_en_forme_krona
sed 1d ${file} > mise_en_forme_krona/table_fl_removed.txt 
sed 's/#//g' mise_en_forme_krona/table_fl_removed.txt > mise_en_forme_krona/table_sans_diese.txt

Rscript krona_pack_tsv/R_mef_tsv.R mise_en_forme_krona/table_sans_diese.txt mise_en_forme_krona/taxonomie_R.tsv

sed 's/"//g' mise_en_forme_krona/taxonomie_R.tsv > mise_en_forme_krona/taxonomie_R_ssgui.tsv
sed 's/;.__/;/g' mise_en_forme_krona/taxonomie_R_ssgui.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv
sed 's/;*$//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv
sed 's/k__//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv > mise_en_forme_krona/taxonomie_R_propre.tsv

bash krona_pack_tsv/traitement_krona.sh mise_en_forme_krona/taxonomie_R_propre.tsv krona_charts/ 
```

```bash
mkdir -p mise_en_forme_krona
```
Les différentes étapes de modification seront enregistrées en tant que fichiers intermédiaires dans le répertoire **mise_en_forme_krona**.

```bash
sed 1d ${file} > mise_en_forme_krona/table_fl_removed.txt
```
La première étape est la suppression de la première ligne du fichier, cette ligne ne sera certes pas exploitée dans la suite du programme et donc, pas nécessaire.

```bash
sed 's/#//g' mise_en_forme_krona/table_fl_removed.txt > mise_en_forme_krona/table_sans_diese.txt
```
La deuxième modification est la suppression des # dans le fichier. En effet, cela me permet de récupérer les noms des différentes colonnes du fichier, colonnes qui me serviront lors du traitement sur R.
```bash
Rscript krona_pack_tsv/R_mef_tsv.R mise_en_forme_krona/table_sans_diese.txt mise_en_forme_krona/taxonomie_R.tsv
```
```R
args<-commandArgs(TRUE)
library(tidyverse)

mef_tsv <- function(file)
{
	tax<-read.table(file,sep="\t",header=T)
	tax$OTU.ID<-str_replace_all(tax$OTU.ID,'s','s')
	tax<-data.frame(tax,tax$OTU.ID)
	colnames(tax)[7]<-"taxo"
	tax$OTU.ID<-NULL
	colnames(tax)<-str_replace(colnames(tax),'X','')
	return(tax)
}
write.table(mef_tsv(args[1]),file=args[2],sep="\t")
```
Après lecture du fichier, j'ai modifié la colonne contenant les taxonomies, pour supprimer les "levels".Les étapes suivantes permettent de déplacer la taxonomie en fin de tableau. J'ai également modifié le nom des colonnes pour avoir des noms d'échantillons propres.
```bash
sed 's/"//g' mise_en_forme_krona/taxonomie_R.tsv > mise_en_forme_krona/taxonomie_R_ssgui.tsv
```
On supprime ensuite les guillemets du fichier généré.
```bash
sed 's/;.__/;/g' mise_en_forme_krona/taxonomie_R_ssgui.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv
sed 's/;*$//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv
sed 's/k__//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv > mise_en_forme_krona/taxonomie_R_propre.tsv
```
On met ensuite en forme la taxonomie. Chaque niveau taxonomique sera séparé des autres par un point virgule.

## Création des krona charts
Une fois la mise en forme effectuée, on peut faire les krona_charts. Le programme l'effectuant a été récupéré sur un autre github et légèrement retouché pour correspondre à notre besoin.
