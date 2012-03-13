# Create your views here.
from django.http import HttpResponse
from PicShareServer import settings

def getPicture(request,picId,picSize):
    print picId
    print picSize
    test = {'a':'aa','b':'bb','c':['aaa','bbb','ccc']}
    return HttpResponse(test)