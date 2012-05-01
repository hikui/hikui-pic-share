from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render_to_response, get_object_or_404
from django.template import RequestContext
from PicShare.models import *

def theIndex(request):
	pictures = PictureStatus.objects.all()
	return render_to_response('test.html', {
            'pictures':pictures
            },context_instance=RequestContext(request))
