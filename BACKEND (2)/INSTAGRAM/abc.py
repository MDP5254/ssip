image_names = [
    'images/post1.jpg',
    'images/profile.jpg'
]

local_ip_address = '192.168.1.6'
port = '8000'

image_urls = [f'http://{local_ip_address}:{port}/{image_name}' for image_name in image_names]