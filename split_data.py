import splitfolders
import os

input_folder = "/Users/safu/Documents/BLOOD/data"
output_folder = "/Users/safu/Documents/BLOOD/dataset"

print(f"Splitting data from {input_folder} to {output_folder}...")
# Split with a ratio.
# To only split into training and validation set, set a tuple to `ratio`, i.e, `(.8, .2)`.
splitfolders.ratio(input_folder, output=output_folder, seed=42, ratio=(.8, .2), group_prefix=None, move=False)
print("Data splitting complete!")
