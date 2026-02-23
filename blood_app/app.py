from flask import Flask, request, jsonify, render_template, redirect, url_for
import os
from ultralytics import YOLO

app = Flask(__name__, template_folder='web', static_folder='web')

# Load the YOLO model early so it's ready for predictions
# Assuming the user's project structure from earlier
MODEL_PATH = "/Users/safu/Documents/BLOOD/training_runs/blood_clump_cls/weights/best.pt"
print(f"Loading YOLO model from {MODEL_PATH}...")
model = YOLO(MODEL_PATH)

# Ensure upload directory exists
UPLOAD_FOLDER = "/Users/safu/Documents/BLOOD/blood_app/uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/scan')
def scan():
    return render_template('scan.html')

@app.route('/api/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400
        
    file = request.files['image']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
        
    filepath = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(filepath)
    
    # Run YOLO prediction
    try:
        results = model.predict(source=filepath)
        
        # Classification models return top-1 class by default in results[0].probs.top1
        top1_index = results[0].probs.top1
        predicted_class = results[0].names[top1_index]
        confidence = float(results[0].probs.top1conf)
        
        return jsonify({
            'success': True,
            'blood_group': predicted_class,
            'confidence': f"{confidence * 100:.2f}%"
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        # Cleanup uploaded file if needed, keeping for now for debugging
        pass

if __name__ == '__main__':
    # Run on port 5001 as requested to avoid Airplay/other collisions
    app.run(host='0.0.0.0', port=5001, debug=True)

