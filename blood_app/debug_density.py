import cv2
import numpy as np

img = cv2.imread('/Users/safu/Downloads/ABO-BTI ABO Blood Typing/ABO-BTI_Images/AB positive/AB_post_2_3.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
blurred = cv2.medianBlur(gray, 5)
blurred = cv2.GaussianBlur(blurred, (5, 5), 0)

thresh = cv2.adaptiveThreshold(blurred, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 11, 2)
kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5, 5))
thresh = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel, iterations=2)
thresh = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel, iterations=2)
contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

potential_circles = []
for cnt in contours:
    area = cv2.contourArea(cnt)
    if 30 < area < 70000:
        perimeter = cv2.arcLength(cnt, True)
        if perimeter > 0:
            circularity = 4 * np.pi * (area / (perimeter * perimeter))
            if circularity > 0.65:
                (x, y), radius = cv2.minEnclosingCircle(cnt)
                potential_circles.append([x, y, radius, circularity])

potential_circles.sort(key=lambda x: x[3], reverse=True)
top_contours = potential_circles[:4]
final_circles = np.uint16(np.around([[c[0], c[1], c[2]] for c in top_contours]))

circles = sorted(final_circles, key=lambda c: c[0])
labels = ['A', 'B', 'D', 'Control']

for i, (x, y, r) in enumerate(circles):
    mask = np.zeros(gray.shape, dtype=np.uint8)
    cv2.circle(mask, (x, y), r, 255, -1)
    extracted = cv2.bitwise_and(gray, gray, mask=mask)
    x1, y1 = max(0, x - r), max(0, y - r)
    x2, y2 = min(gray.shape[1], x + r), min(gray.shape[0], y + r)
    roi_gray = extracted[y1:y2, x1:x2]
    
    edges = cv2.Canny(roi_gray, 50, 150)
    
    edge_pixels = cv2.countNonZero(edges)
    valid_pixels = np.pi * (r ** 2)
    density = (edge_pixels / valid_pixels) * 100 if valid_pixels > 0 else 0
    print(f"Sample {labels[i]}: r={r}, edges={edge_pixels}, valid={valid_pixels:.1f}, density={density:.1f}%")
