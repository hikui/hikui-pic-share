from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render_to_response, get_object_or_404
from django.template import RequestContext
from PicShare.models import *

def theIndex(request):
	pictures = PictureStatus.objects.all()
	pictureInfoList = list()
	host = request.get_host()
	for aPicture in pictures:
		theDynamicUrl = aPicture.picture.image
		pathList = theDynamicUrl.split('/')
		fileName = pathList[-1]
		static_path = 'http://'+host+'/local_media/picture/X640/'+fileName
		pictureInfoList.append(static_path)
	return render_to_response('test.html', {'pictureInfoList':pictureInfoList},context_instance=RequestContext(request))