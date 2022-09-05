#!/bin/bash


module load mrtrix/3.0.3


wkdir="my_project"
outdir="$wkdir/HCP/group"
mkdir ${outdir}

odwidir="$wkdir/HCP/*/T1w/Diffusion"

responsemean ${odwidir}/response_wm.txt ${outdir}/group_average_response_wm.txt -info 
responsemean ${odwidir}/response_gm.txt ${outdir}/group_average_response_gm.txt -info 
responsemean ${odwidir}/response_csf.txt ${outdir}/group_average_response_csf.txt -info 

echo "Finished!"







