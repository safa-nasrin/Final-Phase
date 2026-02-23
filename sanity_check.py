import os
import random
import cv2
import matplotlib.pyplot as plt

def main():
    data_dir = "/Users/safu/Documents/BLOOD/data"
    artifact_path = "/Users/safu/.gemini/antigravity/brain/14275c50-8201-4600-97ce-113eb563286d/sanity_samples.png"
    
    # Get all images
    all_images = []
    for cls in os.listdir(data_dir):
        cls_path = os.path.join(data_dir, cls)
        if os.path.isdir(cls_path) and not cls.startswith('.'):
            for img_name in os.listdir(cls_path):
                if img_name.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp')):
                    all_images.append((os.path.join(cls_path, img_name), cls))
                    
    if len(all_images) < 3:
        print("Not enough images found.")
        return
        
    sampled = random.sample(all_images, 3)
    
    fig, axes = plt.subplots(1, 3, figsize=(15, 5))
    for i, (img_path, cls) in enumerate(sampled):
        img = cv2.imread(img_path)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        axes[i].imshow(img)
        axes[i].set_title(f"Class: {cls}")
        axes[i].axis('off')
        
    plt.suptitle("Sanity Check: 3 Random Images from Dataset")
    plt.savefig(artifact_path)
    print(f"Saved samples to {artifact_path}")

if __name__ == "__main__":
    main()
