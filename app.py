from flask import Flask, request, render_template
from diffusers import StableDiffusionPipeline
from PIL import Image
import uuid
import os

app = Flask(__name__)

# Recommended: Use the v1-5 model for better compatibility
pipe = StableDiffusionPipeline.from_pretrained("runwayml/stable-diffusion-v1-5")
pipe.to("cpu")

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate():
    prompt = request.form['prompt']
    image = pipe(prompt).images[0]

    image_id = f"{uuid.uuid4().hex}.png"
    image_path = os.path.join("static", image_id)
    image.save(image_path)

    return render_template('index.html', prompt=prompt, image_url=image_path)

if __name__ == "__main__":
    os.makedirs("static", exist_ok=True)
    app.run(host="0.0.0.0", port=5001)
