tplpath='../multimodal_t1t2famd'
tplbase='hcp_multimodal_t1t2famd'
fodpath=../fod
t1path=../T1


# Apply warping to each individual FOD
for i in $(cat ../multimodal_t1t2famd/hcplist_diff_r50.txt)
do
   	 echo $i
   	 k=0
   	 ((k=${j}*4 )) 
    	ants_warp=${tplpath}/${tplbase}${i}_T1w_brain_1mm${k}Warp.nii.gz
	ants_affine=${tplpath}/${tplbase}${i}_T1w_brain_1mm${k}Affine.txt

	warpinit ${t1path}/${i}_T1w_brain_1mm.nii.gz ./${i}_t1t2fixel_SyN_identity_warp[].nii.gz -force

	for p in {0..2}
	do
	   WarpImageMultiTransform 3 ./${i}_t1t2fixel_SyN_identity_warp${p}.nii.gz ./${i}_${tplbase}_SyN_mrtrix_warp${p}.nii.gz -R ${tplpath}/${tplbase}template0.nii.gz ${ants_warp} ${ants_affine}

	done

	warpcorrect ./${i}_${tplbase}_SyN_mrtrix_warp[].nii.gz ./${i}_${tplbase}_SyN_mrtrix_warp_corrected.mif -force

	####################################################################
	echo "applying warp..."
        
	mrtransform -force ${fodpath}/${i}_wmfod_norm.mif -warp ./${i}_${tplbase}_SyN_mrtrix_warp_corrected.mif -reorient_fod 1 ./${i}_wmfod_norm_${tplbase}.mif   


    	((j += 1))
       	echo ${j}
    	echo $k
      	

done

# Average the FOD to generate the FOD template

mrmath ./*_wmfod_norm_${tplbase}.mif mean -keep_unary_axes WM_FOD_${tplbase}.mif

