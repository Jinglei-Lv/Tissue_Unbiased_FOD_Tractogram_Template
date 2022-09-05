#!/bin/bash

sbjid="TEMPsub"
hcpdir="/hcp1200"
pjdir="my_project"
tmpdir="my_tmp"
mkdir $pjdir/HCP
wkdir=$pjdir/HCP

# Extracting Structural images

unzip ${hcpdir}/${sbjid}/preproc/${sbjid}_3T_Structural_preproc.zip ${sbjid}/T1w/T1w_acpc_dc_restore_brain.nii.gz -d $wkdir -o
unzip ${hcpdir}/${sbjid}/preproc/${sbjid}_3T_Structural_preproc.zip ${sbjid}/T1w/T2w_acpc_dc_restore_brain.nii.gz -d $wkdir -o

fslmaths $wkdir/${sbjid}/T1w/T1w_acpc_dc_restore_brain.nii.gz -nan -bin $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz

mv $wkdir/${sbjid}/T1w/T1w_acpc_dc_restore_brain.nii.gz $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain.nii.gz
mv $wkdir/${sbjid}/T1w/T2w_acpc_dc_restore_brain.nii.gz $wkdir/${sbjid}/T1w/${sbjid}_T2w_brain.nii.gz

# Extracting diffusion data from the zip
echo "Extracting HCP Diffusion zip..." 
unzip ${hcpdir}/${sbjid}/preproc/${sbjid}_3T_Diffusion_preproc.zip -d $wkdir

# Path of the dwi data
dwidir="$wkdir/${sbjid}/T1w/Diffusion"

# Fill the holes in  the brain mask.
echo "Using FSL to fill holes in nodif_brain_mask..."
time fslmaths ${dwidir}/nodif_brain_mask.nii.gz \
    -fillh \
    -bin \
    -thr .0000000001 \
    ${dwidir}/nodif_brain_mask_fillh.nii.gz

# Bias filed correction.
echo "Running dwibiascorrect..."
mrconvert \
    -fslgrad ${dwidir}/bvecs \
    ${dwidir}/bvals ${dwidir}/data.nii.gz ${dwidir}/data.mif
time dwibiascorrect ants ${dwidir}/data.mif ${dwidir}/cDWI.mif \
    -mask ${dwidir}/nodif_brain_mask_fillh.nii.gz \
    -force \
    -scratch ${tmpdir}    
    #-fslgrad ${dwidir}/bvecs ${dwidir}/bvals \


# Estimate the individual response function.
time dwi2response dhollander ${dwidir}/cDWI.mif \
    ${dwidir}/response_wm.txt \
    ${dwidir}/response_gm.txt \
    ${dwidir}/response_csf.txt \
    -force \
    -scratch ${tmpdir}


# Upsample the image to 1mm 
mrgrid ${dwidir}/cDWI.mif regrid \
    -template $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain.nii.gz ${dwidir}/cDWI_upsampled.mif
	
mrconvert ${dwidir}/cDWI_upsampled.mif ${dwidir}/cDWI_upsampled.mif.gz

dwi2mask ${dwidir}/cDWI_upsampled.mif ${dwidir}/dwi_mask_upsampled.mif


echo "Finished!"







