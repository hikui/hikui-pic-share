# Create your views here.
from django.http import HttpResponse
from PicShareServer import settings
import os

def getPicture(request,picPath,img_type):
    picSize = int(request.GET.get('size',-1))
    MIME_type_mapping = {
        '.jpg':'image/jpeg',
        '.png':'image/png',
        '.gif':'image/gif'
    }
    size_path_mapping = {
        -1:'origin',
         60:'X60',
        120:'X120',
        320:'X320',
        640:'X640'
    }
    filename,extension = os.path.splitext(picPath)
    mime_type = MIME_type_mapping.get(extension)
    localpath = size_path_mapping.get(picSize)
    if mime_type is not None and localpath is not None:
        image_path = str()
        if img_type == 0:
            image_path = os.path.join(settings.MEDIA_ROOT,'picture',localpath,picPath)
        elif img_type == 1:
            image_path = os.path.join(settings.MEDIA_ROOT,'avatar',localpath,picPath)
        image = open(image_path, "rb").read()
        return HttpResponse(image,mimetype=mime_type)
    return HttpResponse()