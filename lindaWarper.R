## This will loop over LINDA output folders and warp native space files of your choosing to the ch2 template that LINDA uses to draw lesions.
## Edit the paths below to fit your data...

library(ANTsR)

# Specify the base directory of linda outputs
bd <- "/Volumes/JFAL_USERS/LJohnson/Linda_All_Alex"

# Specify the template from wherever you downloaded LINDA
target <- antsImageRead("/Users/alex/Downloads/LINDA-master-2/inst/extdata/pennTemplate/templateBrain.nii.gz")

# Get a list of all directories within the specified directory
d <- list.dirs(bd, recursive = FALSE)

# Remove last two directories (just for our data and its idiosyncracies)
d <- head(d, -2)

# Iterate over the directories
for (i in  seq_along(d)) {
  # Change your input to whatever file in linda directory that you want to warp into ch2 template space
  input <- file.path(d[i], "linda/Prediction3_native_FalsePosFix.nii.gz")
  
  # These are standard, you shouldn't have to touch them
  output <- file.path(d[i], "linda/Prediction3_template_FalsePosFix.nii.gz")
  wrp <- file.path(d[i], "linda/Reg3_sub_to_template_warp.nii.gz")
  aff <- file.path(d[i], "linda/Reg3_sub_to_template_affine.mat")

  # ANTS warp application and image writing...
  tmp <- antsApplyTransforms(
        moving = input,
        fixed = target,
        output = output,
        transformlist = c(aff, wrp),
        interpolator = "Linear",
        verbose = TRUE)
  antsImageWrite(tmp, filename = output)
}