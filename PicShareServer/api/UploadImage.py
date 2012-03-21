from PicShareServer import settings
import StringIO
from PIL import Image, ImageOps
import os
from django.core.files import File
import time
import random

PICTURE_DIR = 'picture'
AVATAR_DIR = 'avatar'
ORIGINAL_IMAGE_DIR = 'origin'
IMAGE_60_DIR ='X60'
IMAGE_100_DIR = 'X100'
IMAGE_120_DIR = 'X120'
IMAGE_160_DIR = 'X160'
IMAGE_320_DIR = 'X320'
IMAGE_640_DIR = 'X640'


def resize_image(image,targetWidth):
    '''
    If image is bigger than the targetWidth, this method shall resize it.
    Otherwise, this method does nothing.
    '''
    size = targetWidth,targetWidth # neither width nor height could larger than this value
    resultImage = image.copy()
    resultImage.thumbnail(size,Image.ANTIALIAS)
    return resultImage
    
    

def handle_upload_image(i):
    # read image from InMemoryUploadedFile
    memStr = ""
    for c in i.chunks():
        memStr += c

    # create PIL Image instance
    imagefile  = StringIO.StringIO(memStr)
    image = Image.open(imagefile)

    # if not RGB, convert
    if image.mode not in ("L", "RGB"):
        image = image.convert("RGB")

    # generate file name
    timestamp = str(int(time.time()))
    randStr = ''.join(random.sample([chr(i) for i in range(97, 122)], 10))
    filename = timestamp+randStr+'.jpg'
    origin_image_path = os.path.join(settings.MEDIA_ROOT,PICTURE_DIR,ORIGINAL_IMAGE_DIR)
    x120_image_path =  os.path.join(settings.MEDIA_ROOT,PICTURE_DIR,IMAGE_120_DIR)
    x320_image_path = os.path.join(settings.MEDIA_ROOT,PICTURE_DIR,IMAGE_320_DIR)
    x640_image_path = os.path.join(settings.MEDIA_ROOT,PICTURE_DIR,IMAGE_640_DIR)
    paths = {origin_image_path:None,x120_image_path:120,x320_image_path:320,x640_image_path:640}
    for aPath,size in paths.items():
        # do resize
        temp_image = None
        if size is not None:
            temp_image = resize_image(image,size)
        else:
            temp_image = image
        #save to disk
        if not os.path.exists(aPath):
            os.makedirs(aPath)
        
        imagefile = open(os.path.join(aPath,filename), 'w')
        temp_image.save(imagefile,'JPEG', quality=90)
    return filename
