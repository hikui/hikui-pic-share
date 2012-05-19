#coding:utf-8
from PicShare.models import *
from django.contrib import admin


class PictureStatusInline(admin.StackedInline):
	model=PictureStatus
	extra=3
class BoardAdmin(admin.ModelAdmin):
	fieldsets=[
		(None, {'fields':['name','category','owner','followers']})
	]
	inlines=[PictureStatusInline]

class PictureStatusAdmin(admin.ModelAdmin):
	list_filter=('status_type',)

	actions = ['mark_as_banned']
	def mark_as_banned(self,request,queryset):
		queryset.update(status_type=4)
	mark_as_banned.short_description=u"封禁所选"

admin.site.register(Category)
admin.site.register(Board,BoardAdmin)
admin.site.register(PictureStatus,PictureStatusAdmin)
admin.site.register(Comment)
admin.site.register(PSMessage)