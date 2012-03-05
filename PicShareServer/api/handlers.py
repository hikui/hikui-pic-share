from piston.handler import BaseHandler,AnonymousBaseHandler
from piston.utils import rc
from PicShareServer.PicShare.models import *



class GetAllCategoriesHandler(BaseHandler):
    
    model = Category
    allowed_methods=('GET',)
    exclude = ()
    def read(self,request):
        categories = Category.objects.all()
        resultArray = []
        for aCategory in categories:
            tempDict = {}
            tempDict['category_id'] = aCategory.id
            tempDict['name'] = aCategory.name
            resultArray.append(tempDict)
        return {"categories":resultArray}