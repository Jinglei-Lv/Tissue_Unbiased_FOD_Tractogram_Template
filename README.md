![image](https://user-images.githubusercontent.com/16005941/188344220-2a042d96-a471-4e5c-9d00-dd80ddf53835.png)


This repository releases the code for the following paper.

Lv, J, Zeng, R, Ho, MP, D'Souza, A, Calamante, F. Building a tissue-unbiased brain template of fiber orientation distribution and tractography with multimodal registration. Magn Reson Med. 2022; 1- 14. doi:10.1002/mrm.29496.


Our tempalte is open source at https://osf.io/n4kgf/ 

Please cite this paper if you use the scrips or code. License: CC0 1.0 Universal.

Instructions:

There are 7 steps to generate a tissue unbiased brain FOD and tractogram template. You will need T1w/T2w and Diffusion MRI to do so. HCP data is used for this paper.

Step 1: 1_preprocessing.sh

        Preprocessing the Diffusion MRI. 
        The current script is developed after the HCP minimal preprocessing pipeline.
        
Step 2: 2_avg_response.sh

        Average the response function of all your subjects, which are used to generate the template.

Step 3: 3_calculate_scalar_images_FOD.sh

       Use this script to calculate the FOD and the scalar images, such as FA, MD, Apparent fiber density and fibre complexity.
       
Step 4: 4_multimodel_template.sh

       The multimodal scalar images, such as T1w/T2w, FA and MD are used to generate the multimodal template. The “individual to template” warping fields are also generated.
       
Step 5: 5_multimodal_reg_apply2fod.sh

       Apply the multimodal warping fields to the FOD files and average individuals to generate the FOD template.
       
Step 6: 6_run5ttgen.sh

       Run 5ttgen on the derived T1w template to generate the tissue probability map of the template.
       
Step 7: 7_fiber_tracking.sh

      Anatomically constrained fibre tracking is used to generate the tractogram template.


Please cite this paper if you use the scrips or code.  

Lv, Jinglei, Rui Zeng, Mai Phuong Ho, Arkiev D'Souza, and Fernando Calamante. "Building a Tissue-unbiased Brain Template of Fibre Orientation Distribution and Tractography with Multimodal Registration." bioRxiv (2022).
