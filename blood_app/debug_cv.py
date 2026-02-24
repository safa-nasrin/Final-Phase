import cv2
import numpy as np

img = cv2.imread('/Users/safu/Downloads/ABO-BTI ABO Blood Typing/ABO-BTI_Images/AB positive/AB_post_2_3.jpg')
if img is None:
    print("Failed to load image!")
    exit()

gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
blurred = cv2.medianBlur(gray, 5)
blurred = cv2.GaussianBlur(blurred, (5, 5), 0)

thresh = cv2.adaptiveThreshold(blurred, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 11, 2)
kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5, 5))
thresh = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel, iterations=2)
thresh = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel, iterations=2)

contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

print(f"Total contours: {len(contours)}")
for cnt in contours:
    area = cv2.contourArea(cnt)
    if area > 10:
        perimeter = cv2.arcLength(cnt, True)
        if perimeter > 0:
            circularity = 4 * np.pi * (area / (perimeter * perimeter))
            print(f"Area: {area:.1f}, Perimeter: {perimeter:.1f}, Circularity: {circularity:.3f}")
