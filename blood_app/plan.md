Phase 1: Responsive Auth & Device Tracking
Stage 1.1: Multi-Platform Signup

Create SignupScreen with fields: Full Name, Age, Email, Password, City, and Gender.

Use LayoutBuilder to ensure the UI looks like a mobile app even when viewed on a Laptop/Desktop browser.

Stage 1.2: Interface Detection (Backend Logic)

Implement logic to detect if the user is on a Mobile, Laptop, or Desktop.

Save this interface type into the MongoDB users collection during Signup/Login.

Stage 1.3: Navigation & Security

Set up functional Login, Signup, and Forgot Password routes.

Verification: Confirm that resizing the browser window doesn't break the layout and that the "City" and "Gender" data is captured.

Phase 2: AI Accuracy & Image Quality (The "Standout" Stage)
Stage 2.1: Fingerprint Quality Checker (OpenCV)

Before sending to the model, use OpenCV to check for Blur (Laplacian) and Brightness.

If the image is poor, display: "Image too blurry/dark. Please take a clearer picture".

Stage 2.2: YOLOv8 with Confidence Thresholding

High Confidence (>75%): Show the predicted Blood Group.

Low Confidence (<75%): Hide the prediction and show: "AI is unsure. Please take a clear picture in better lighting".

Stage 2.3: Modern Framework Integration

Use ultralytics for inference and PIL for image handling to ensure high accuracy.

Verification: Upload a blurry photo to trigger the "Unsure" message; upload a clear photo to see the result.

Phase 3: Results, History & RAG Summarizer
Stage 3.1: Result Dashboard

Display Blood Group, Confidence Score, and Medical Compatibility (e.g., "O+ can donate to...").

Stage 3.2: AI-Powered Report Summarizer (Extra)

Add a tab to upload medical PDF reports.

Use a basic RAG (Retrieval-Augmented Generation) or text extraction to summarize the PDF for the user.

Stage 3.3: Scan History & PDF Download

Show a table of: Username, Age, City, Test Count, and Results.

Add a "Download Report" button to save the current scan as a PDF.

Verification: Perform a scan and verify the entry appears in the "Scan History" tab.

Phase 4: Backend Persistence & Emergency Services
Stage 4.1: MongoDB Atlas Integration

Sync all user profiles, device types, and scan history to the BloodApp database.

Stage 4.2: Emergency Donor Finder

Implement a tab to find nearest blood banks or donors (using mock locations or Map API).

Verification: Verify all data (including "Device Type") is correctly visible in MongoDB Compass.