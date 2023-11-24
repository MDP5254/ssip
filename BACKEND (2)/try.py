import os
from imgurpython import ImgurClient
from fastapi import FastAPI
import uvicorn

app = FastAPI()

# Set your Imgur API credentials
client_id = '12103def7daea23'
client_secret = 'aafc33f7755b620357834d39188a82623fba48f4'

# Create an ImgurClient
client = ImgurClient(client_id, client_secret)

# Specify the path to your image file
image_path = r'D:\apps\ssip\assets\images\bg.jpeg'

# Upload the image to Imgur
uploaded_image = client.upload_from_path(image_path, anon=True)

# Get the URL of the uploaded image
image_url = uploaded_image['link']

# Print the image URL
print(f"Image URL: {image_url}")


@app.get("/images")
def get_image_urls():
    # Image URLs
    image_urls = image_url
        
    return [image_urls]

uvicorn.run(app,host='0.0.0.0',port=5000)
