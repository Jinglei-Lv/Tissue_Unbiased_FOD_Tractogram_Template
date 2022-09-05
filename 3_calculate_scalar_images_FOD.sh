#!/bin/bash

sbjid="TEMPsub"
hcpdir="/hcp1200"
pjdir="my_project"
tmpdir="my_tmp"

goutdir="$wkdir/group"


odwidir="$wkdir/${sbjid}/T1w/Diffusion"
# Calculate FOD
dwi2fod msmt_csd ${odwidir}/cDWI_upsampled.mif.gz \
    ${goutdir}/group_average_response_wm.txt ${odwidir}/wmfod.mif \
    ${goutdir}/group_average_response_gm.txt ${odwidir}/gm.mif  \
    ${goutdir}/group_average_response_csf.txt ${odwidir}/csf.mif \
    -mask $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -force

# Normalize FOD
mtnormalise ${odwidir}/wmfod.mif ${odwidir}/wmfod_norm.mif \
    ${odwidir}/gm.mif ${odwidir}/gm_norm.mif \
    ${odwidir}/csf.mif ${odwidir}/csf_norm.mif \
    -mask $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -force
	
# Calculate Tensor	FA MD
dwi2tensor -mask $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz ${odwidir}/cDWI_upsampled.mif.gz ${odwidir}/tensor.mif
tensor2metric -adc ${odwidir}/adc.mif -fa ${odwidir}/fa.mif -ad ${odwidir}/ad.mif -rd ${odwidir}/rd.mif ${odwidir}/tensor.mif	

# Calculate fixel	
ind_ind_fixeldir="$odwidir/fixel_ind_ind_nothr"



fod2fixel -fmls_peak_value 0 -fmls_no_thresholds -mask $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -nthreads 2 -afd afd.mif -peak peak.mif -disp dispersion.mif ${odwidir}/wmfod_norm.mif ${ind_ind_fixeldir} -force

mrcalc ${odwidir}/adc.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/adc.mif 
mrcalc ${odwidir}/fa.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/fa.mif   
mrcalc ${odwidir}/ad.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/ad.mif  
mrcalc ${odwidir}/rd.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/rd.mif

mrconvert ${odwidir}/adc.mif ${odwidir}/adc.nii.gz
mrconvert ${odwidir}/fa.mif ${odwidir}/fa.nii.gz
mrconvert ${odwidir}/ad.mif ${odwidir}/ad.nii.gz
mrconvert ${odwidir}/rd.mif ${odwidir}/rd.nii.gz

mv ${odwidir}/adc.nii.gz ${odwidir}/${sbjid}_adc.nii.gz
mv ${odwidir}/fa.nii.gz ${odwidir}/${sbjid}_fa.nii.gz
mv ${odwidir}/ad.nii.gz ${odwidir}/${sbjid}_ad.nii.gz
mv ${odwidir}/rd.nii.gz ${odwidir}/${sbjid}_rd.nii.gz



fixel2voxel ${ind_ind_fixeldir}/afd.mif sum ${odwidir}/fixel_total_afd_nothr.mif -force
fixel2voxel ${ind_ind_fixeldir}/peak.mif count ${odwidir}/fixel_count_nothr.mif -force    
fixel2voxel ${ind_ind_fixeldir}/peak.mif complexity ${odwidir}/fixel_complexity_nothr.mif -force    
fixel2voxel ${ind_ind_fixeldir}/peak.mif sf ${odwidir}/fixel_single_fiber_nothr.mif -force    

mrcalc ${odwidir}/fixel_total_afd_nothr.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/fixel_total_afd_nothr.mif -force  
mrcalc ${odwidir}/fixel_count_nothr.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/fixel_count_nothr.mif -force  
mrcalc ${odwidir}/fixel_complexity_nothr.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/fixel_complexity_nothr.mif -force  
mrcalc ${odwidir}/fixel_single_fiber_nothr.mif $wkdir/${sbjid}/T1w/${sbjid}_T1w_brain_mask.nii.gz -mul ${odwidir}/fixel_single_fiber_nothr.mif -force  

mrconvert ${odwidir}/fixel_total_afd_nothr.mif ${odwidir}/${sbjid}_fixel_total_afd_nothr.nii.gz -force  
mrconvert ${odwidir}/fixel_count_nothr.mif ${odwidir}/${sbjid}_fixel_count_nothr.nii.gz -force  
mrconvert ${odwidir}/fixel_complexity_nothr.mif  ${odwidir}/${sbjid}_fixel_complexity_nothr.nii.gz -force  
mrconvert ${odwidir}/fixel_single_fiber_nothr.mif ${odwidir}/${sbjid}_fixel_single_fiber_nothr.nii.gz -force  

mrconvert ${odwidir}/wmfod_norm.mif ${odwidir}/${sbjid}_wmfod_norm_l0_totalafd.nii.gz -coord 3 0



echo "Finished!"







