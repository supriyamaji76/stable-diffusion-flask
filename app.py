from flask import Flask, request, render_template
import torch
from diffusers import StableDiffusionPipeline
from PIL import Image
import uuid
import os

app = Flask(__name__)

# Load the Stable Diffusion model with FP16 for GPU
pipe = StableDiffusionPipeline.from_pretrained(
    "CompVis/stable-diffusion-v1-4",
    torch_dtype=torch.float16,
    revision="fp16",
    use_auth_token=True  # Login with `huggingface-cli login` if needed
).to("cpu")  # Ensure CUDA (GPU) is available

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate():
    prompt = request.form['prompt']

    # Generate image from text
    image = pipe(prompt).images[0]

    # Save the image with a unique name
    image_id = f"{uuid.uuid4().hex}.png"
    image_path = os.path.join("static", image_id)
    image.save(image_path)

    # Return the image in the template
    return render_template('index.html', prompt=prompt, image_url=image_path)

if __name__ == "__main__":
    os.makedirs("static", exist_ok=True)
    
    app.run(host="0.0.0.0", port=5001)
