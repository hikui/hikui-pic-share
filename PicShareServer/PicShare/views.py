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

def search(request):
	keyword = request.GET.get('keyword')
	if keyword is None:
		return render_to_response('search.html',context_instance=RequestContext(request))
	else:
		host = request.get_host()
		if keyword == "":
			pictures = PictureStatus.objects.all()
			pictureInfoList = list()
			for aPicture in pictures:
				theDynamicUrl = aPicture.picture.image
				pathList = theDynamicUrl.split('/')
				fileName = pathList[-1]
				static_path = 'http://'+host+'/local_media/picture/X640/'+fileName
				pictureInfoList.append(static_path)
			return render_to_response('test.html', {'pictureInfoList':pictureInfoList},context_instance=RequestContext(request))
		else:
			from django.db.models import Q
			pictureInfoSet = set()
			q1 = Q(name__contains=keyword)
			q2 = Q(description__contains=keyword)
			resultBoards = Board.objects.filter(q1)
			for aBoard in resultBoards:
				pss = aBoard.pictureStatuses.all()
				for aPicture in pss:
					theDynamicUrl = aPicture.picture.image
					pathList = theDynamicUrl.split('/')
					fileName = pathList[-1]
					static_path = 'http://'+host+'/local_media/picture/X640/'+fileName
					pictureInfoSet.add(static_path)
			resultPictureStatus = PictureStatus.objects.filter(q2)
			for aPicture in resultPictureStatus:
				theDynamicUrl = aPicture.picture.image
				pathList = theDynamicUrl.split('/')
				fileName = pathList[-1]
				static_path = 'http://'+host+'/local_media/picture/X640/'+fileName
				pictureInfoSet.add(static_path)
			return render_to_response('test.html', {'pictureInfoList':pictureInfoSet},context_instance=RequestContext(request))