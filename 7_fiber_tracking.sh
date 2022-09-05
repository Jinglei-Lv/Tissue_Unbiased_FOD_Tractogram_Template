
# # # Definitions for DEC
tckno=10M
alg=iFOD2
cutoff_value=0.06
min_length=5
max_length=300
max_attempts=1000
tck_file=./fibers_act_dy_seed_10m.tck
fod_norm_file=/home/jingleil/data_lv/Tract_ID/HCP_f100/Apply_FOD2template_t1t2mdfa/WM_FOD_hcp_f50_t1t2mdfa.mif
i5tt_file=/home/jingleil/data_lv/Tract_ID/HCP_f100/multi_modal_50sub_t1t2mdfa/5tt_templte0_hsvs/5tt.mif


# Whole image tckgen 
tckgen ${fod_norm_file} ${tck_file} \
-algorithm ${alg} \
-select ${tckno} \
-seed_dynamic ${fod_norm_file} \
-act ${i5tt_file} \
-output_seeds ./seeds_act_dy_seed_50m_act.mif \
-backtrack \
-cutoff ${cutoff_value} \
-minlength ${min_length} \
-maxlength ${max_length} \
-max_attempts_per_seed ${max_attempts} \
-force



