from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.staticfiles import StaticFiles
from pathlib import Path
import instaloader
import requests
import re
from img_text_extract import detect_text
import spacy
# from testing_image import predict_image
from testing import check
import os
import uvicorn
app = FastAPI()
ig = instaloader.Instaloader()

# Pydantic model for incoming login requests
class LoginRequest(BaseModel):
    username: str
    password: str

app.mount("/images", StaticFiles(directory=Path("images")), name="images")
image_folder_path = "images"


# Initialize dictionaries to store the frequencies
number_frequency = {}
hashtag_frequency = {}
location_frequency = {}
profile_pic_url = ""
post_path = ""
offensive_bio = {}
offensive_comments = {}
follower_list = []
following_list = []

@app.get("/number-frequency")
async def get_data():
    return number_frequency

@app.get("/hashtag-frequency")
async def get_data():
    keys_to_delete = []

    for i, j in hashtag_frequency.items():
        predict = check(i[1::])
        if predict != 1:
            keys_to_delete.append(i)

    for key in keys_to_delete:
        del hashtag_frequency[key]

    return hashtag_frequency

@app.get("/location-frequency")
async def get_data():
    return location_frequency

@app.get("/profile-picture")
async def get_data():
    return {"profile_path" : "lib/backend/images/profile.jpg"}

@app.get("/offensive-bio")
async def get_data():
    return offensive_bio

@app.get("/offensive-comments")
async def get_data():
    return offensive_comments

@app.get("/follower-count")
async def get_data():
    return {"follower_count" : len(follower_list)}

@app.get("/following-count")
async def get_data():
    return {"following_count" : len(following_list)}

@app.get("/image-paths")
async def get_data():
    dict1 = image_detection()
    return dict1

# Login endpoint
@app.post("/login")
async def login(request: LoginRequest):
    global number_frequency
    global hashtag_frequency
    global location_frequency
    global offensive_bio
    global offensive_comments
    global follower_list
    global following_list
    global post_path

    number_frequency = {}
    hashtag_frequency = {}
    location_frequency = {}
    profile_pic_url = ""
    post_path = ""
    offensive_bio = {}
    offensive_comments = {}
    follower_list = []
    following_list = []


    username = request.username
    password = request.password

    try:
        ig.login(username, password)
    except Exception as e:
        print(f"Login failed: {str(e)}")
        raise HTTPException(status_code=401, detail="Login failed")
    
    global profile
    profile = instaloader.Profile.from_username(ig.context, username)

    profile_pic_url = profile.profile_pic_url
    response = requests.get(profile_pic_url)

    if response.status_code == 200:
        with open(f"images/profile.jpg", 'wb') as file:
            file.write(response.content)

    c=0
    for post in profile.get_posts():
        c+=1
        post_path = post.url
        response = requests.get(post_path)

        if response.status_code == 200:
            with open(f"images/post{c}.jpg", 'wb') as file:
                file.write(response.content)
            break

    # Extract phone numbers
    number_frequency = extract_number_frequencies(profile)

    # Extract hashtag frequencies
    hashtag_frequency = extract_hashtag_frequencies(profile)

    # Extract location frequencies
    location_frequency = extract_loaction_frequency()

    # Extract offensive bio
    offensive_bio = offensive_bio1()

    # Extract offensive comments
    offensive_comments = offensive_comments1()

    # Extract follower count
    follower_list = followers1()

    # Extract following count
    following_list = following1()


    return {"message": "Login successful"}

#============================================================================================================================

def extract_number_frequencies(profile):
    frequency_of_numbers = {}
    numbers_list = []
    
    bio = profile.biography
    matches = re.findall(r'\b(?:\+91|0)?[789]\d{9}\b', bio.strip())
    if matches:
        numbers_list.extend(matches)

    for post in profile.get_posts():
        caption = post.caption
        matches = re.findall(r'\b(?:\+91|0)?[789]\d{9}\b', caption.strip())
        numbers_list.extend(matches)

        for comment in post.get_comments():
            matches = re.findall(r'\b(?:\+91|0)?[789]\d{9}\b', comment.text.strip())
            numbers_list.extend(matches)

    for post in profile.get_tagged_posts():
        caption = post.caption
        matches = re.findall(r'\b(?:\+91|0)?[789]\d{9}\b', caption.strip())
        numbers_list.extend(matches)

        for comment in post.get_comments():
            matches = re.findall(r'\b(?:\+91|0)?[789]\d{9}\b', comment.text.strip())
            numbers_list.extend(matches)

    for number in numbers_list:
        count = numbers_list.count(number)
        frequency_of_numbers[number] = count

    return frequency_of_numbers

def extract_hashtag_frequencies(profile):
    frequency_of_hashtags = {}
    hashtags_list = []

    bio = profile.biography
    matches = re.findall(r'#\w+', bio.strip())
    if matches:
        hashtags_list.extend(matches)

    for post in profile.get_posts():
        caption = post.caption
        matches = re.findall(r'#\w+', caption.strip())
        hashtags_list.extend(matches)

        for comment in post.get_comments():
            matches = re.findall(r'#\w+', comment.text.strip())
            hashtags_list.extend(matches)

    for post in profile.get_tagged_posts():
        caption = post.caption
        matches = re.findall(r'#\w+', caption.strip())
        hashtags_list.extend(matches)

        for comment in post.get_comments():
            matches = re.findall(r'#\w+', comment.text.strip())
            hashtags_list.extend(matches)

    for hashtag in hashtags_list:
        count = hashtags_list.count(hashtag)
        frequency_of_hashtags[hashtag] = count

    return frequency_of_hashtags

def extract_loaction_frequency():
    location_list = []
    nlp = spacy.load("en_core_web_sm")

    def extract_locations_from_text(user_input):
        doc = nlp(user_input)
        locations = [ent.text for ent in doc.ents if ent.label_ == "GPE"]
        return locations

    for post in profile.get_posts():
        caption = post.caption
        matches = extract_locations_from_text(caption.strip())
        location_list.extend(matches)

        for comment in post.get_comments():
            matches = extract_locations_from_text(comment.text.strip())
            location_list.extend(matches)
    
    for post in profile.get_tagged_posts():
        caption = post.caption
        matches = extract_locations_from_text(caption.strip())
        location_list.extend(matches)

        for comment in post.get_comments():
            matches = extract_locations_from_text(comment.text.strip())
            location_list.extend(matches)
    
    for location in location_list:
        count = location_list.count(location)
        location_frequency[location] = count
    
    return location_frequency

def offensive_bio1():
    bio = profile.biography
    for words in bio.split():
        predict = check(words)
        # print(pr`edict)
        if predict == 1:
            offensive_bio[profile.username] = bio
            break

        if predict == 1:
            offensive_bio[profile.username] = bio
            break

    return offensive_bio

def offensive_comments1():
    for post in profile.get_posts():
        caption = post.caption
        for words in caption.split():
            predict = check(words)
            if predict == 1:
                offensive_comments[profile.username] = caption
                break


    return {"comments" : "bitch"}

def followers1():
    for followeri in profile.get_followers():
        follower_list.append(followeri.username)

    return follower_list

def following1():
    for followingi in profile.get_followees():
        following_list.append(followingi.username)

    return following_list


def image_paths():
    path_of_image = os.listdir('images')
    for i in range(0, len(path_of_image)):
        path_of_image[i]='images/'+path_of_image[i]

    return path_of_image

def image_detection():
    img_detect={}
    lst = image_paths()
    for i in lst:
        text = detect_text(i)
        words = text.split()
        for word in words:
            result = check(word)
            if result == 1:
                img_detect[i] = text
                break
    
    return img_detect







uvicorn.run(app, host="0.0.0.0", port=5200)

                                       