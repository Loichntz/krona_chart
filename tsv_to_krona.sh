#!/bin/bash

set -e 

module load R

file=$1

mkdir -p mise_en_forme_krona
sed 1d ${file} > mise_en_forme_krona/table_fl_removed.txt 
sed 's/#//g' mise_en_forme_krona/table_fl_removed.txt > mise_en_forme_krona/table_sans_diese.txt

Rscript krona_pack_tsv/R_mef_tsv.R mise_en_forme_krona/table_sans_diese.txt mise_en_forme_krona/taxonomie_R.tsv

sed 's/"//g' mise_en_forme_krona/taxonomie_R.tsv > mise_en_forme_krona/taxonomie_R_ssgui.tsv
sed 's/;.__/;/g' mise_en_forme_krona/taxonomie_R_ssgui.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv
sed 's/;*$//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts.tsv > mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv
sed 's/k__//g' mise_en_forme_krona/taxonomie_R_ssgui_sspts_nivir.tsv > mise_en_forme_krona/taxonomie_R_propre.tsv

bash krona_pack_tsv/traitement_krona.sh mise_en_forme_krona/taxonomie_R_propre.tsv krona_charts/ 
