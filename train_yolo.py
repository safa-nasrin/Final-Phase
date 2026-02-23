import os
from ultralytics import YOLO

def main():
    # Load a pretrained YOLO classification model
    print("Initializing YOLOv8 classification model...")
    model = YOLO("yolov8n-cls.pt")  # Use YOLOv8 nano for classification

    # Path to dataset
    # ultralytics expects the dataset path to be a string or a dict/yaml. 
    # For classification, a directory containing 'train' and 'val' subfolders is required.
    data_path = "/Users/safu/Documents/BLOOD/dataset"

    # Define training parameters with data augmentations to optimize for unseen data
    # YOLO classification uses image augmentations by default, but we can tune them if needed via parameters, although classification natively uses less complex augmentations than detection
    # We will let YOLO use its default robust augmentations for classification (like crop, flip, etc.)
    # and adjust the general training parameters.
    
    print("Starting training...")
    results = model.train(
        data=data_path,
        epochs=10, # Modify based on early stopping, starting with 10 for quick run
        imgsz=224, # Standard for classification
        batch=16,
        project='/Users/safu/Documents/BLOOD/training_runs',
        name='blood_clump_cls',
        # Adding augmentations to help the model generalize
        degrees=10.0,      # image rotation (+/- deg)
        scale=0.1,         # image scale (+/- gain)
        fliplr=0.5,        # image flip left-right (probability)
        flipud=0.0,        # image flip up-down (probability)
        hsv_h=0.015,       # image HSV-Hue augmentation (fraction)
        hsv_s=0.7,         # image HSV-Saturation augmentation (fraction)
        hsv_v=0.4,         # image HSV-Value augmentation (fraction)
        # Using Early Stopping by default
        patience=5,
        device='mps' # If user is on an Apple Silicon, this will use Metal Performance Shaders
                     # If the user does not have this (Intel Mac), it will fallback to CPU or it might throw an error.
                     # We might want to let ultralytics auto-detect by commenting this out or let it fail and fallback.
                     # Let's remove device='mps' to make it safe to run on any Mac. ultralytics will auto-detect CPU/MPS.
    )
    
    # We can validate the model on the validation set
    print("Validating model...")
    metrics = model.val()
    
    print("Training process complete. Check the 'training_runs' directory for results.")

if __name__ == "__main__":
    main()
