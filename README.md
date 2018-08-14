# Guide de l'utilisateur
## Utilisation générale
L'ensemble des programmes nécessaires à la réalisation des krona_charts sont compris dans le dossier krona_pack_tsv. Ce dossier contient le script principal en lui-même permettant de passer du tsv aux krona_charts, mais également un script R permettant la réalisation d'un certain nombre de mises en forme sur le fichier de base, script R auquel je fais appel dans le script principal. Le script traitement_krona permet la réalisation des krona_charts à partir d'un format de fichier bien précis.
Il s'agit de la dernière étape du script principal. Ce dernier script fait intervenir une fonction de krona stockée dans le rérpertoire bin.

Pour construire les krona_charts, il suffit d'avoir dans le même répertoire le répertoire krona_pack_tsv contenant tous les scripts nécessaires et le fichier tsv que l'on souhaite traiter, et faire appel au script tsv_to_krona. Le script retournera alors les fichiers html attendus dans un répertoire intitulé "krona_charts".

## Mise en forme du fichier tsv

'''bash
mkdir -p mise_en_forme_krona
sed 1d ${file} > mise_en_forme_krona/table_fl_removed.txt 
sed 's/#//g' mise_en_forme_krona/table_fl_removed.txt > mise_en_forme_krona/table_sans_diese.txt

Rscript krona_pack_tsv/R_mef_tsv.R mise_en_forme_krona/table_sans_diese.txt mise_en_forme_krona/taxonomie_R.tsv

sed 's/"//g' mise_en_forme_krona/taxonomie_R.tsv > mise_en_forme_krona/taxonomie_R_ssgui.tsv
sed 's/;.__/;/g' mise_en_forme_krona/taxonomie_R_ssgui.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv
sed 's/;*$//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv
sed 's/k__//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv > mise_en_forme_krona/taxonomie_R_propre.tsv

bash krona_pack_tsv/traitement_krona.sh mise_en_forme_krona/taxonomie_R_propre.tsv krona_charts/ 

'''
