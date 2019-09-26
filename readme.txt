Here are the data and MATLAB analysis code for:

	Keinath et al. () Environmental deformations dynamically 	shift human spatial memory.

In order to reproduce the analyses in the paper, add the folder 'Functions' to your matlab path and run 'main' while in its home folder. In order to perform new analyses, we recommend using the function 'getData' which will load and aggregate data from a particular folder into a structure with some of the following fields for each subject:

block_order	ordered list of the block condition names
compress		data from the compression block
stretch		data from the stretch block
familiar		data from the undeformed block
no_fog		data from the undeformed block without fog
id			subject ID

data from each block is a struct containing the following fields for each replace trial:

item				item name
startlocation		starting boundary location
trialnum			the number of this trial
path				the recorded path of the participant
replacelocation		the object replace location

If you use these data for any publications, please cite the original paper, thank you!