#coding:utf-8
from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save

'''
每个用户维护自己的一组Board，
每张图片一旦被上传，则与用户无关，每个用户上传图片，或者repin图片之后，都有自己的
PictureStatus，用户只能维护PictureStatus（写description、从board删除等等）。
PictureStatus依附于一个Board，一个Board有自己的owner，所以PictureStatus只有一个owner。
每个PictureStatus被建立的时候，就在其对应的Picture的retain值+1，每次删除PictureStatus
时，对应的Picture的retain值-1，并且计算是否为0，如果为0，则删除Picture本身。
Picture对外不可见（API不可见），API所有的图片操作都基于PictureStatus。
每个Board可以指定Category，Category在“广场”功能中使用。

repin操作：新建一个PictureStatus，repin用户自己写description，并依附于指定的Board

Follow逻辑：一个用户可以关注一个Board，或者另一个用户。关注一个用户即关注该用户的所有Board，
并且将用户添加到following中。反之亦然。

'''


class Category(models.Model):
    name = models.CharField(max_length=10, unique=True)

class Board(models.Model):
    name      = models.TextField(max_length=140)
    owner     = models.ForeignKey(User, related_name='my_boards') #User自己建的
    followers = models.ManyToManyField(User,related_name='following_boards',null=True,blank=True) #关注的用户
    category  = models.ForeignKey(Category, null=True,blank=True, related_name='boards') #在Explore中使用
    def __unicode__(self):
        return "board-name:"+self.name

class Picture(models.Model):
    timestamp = models.DateTimeField()
    image     = models.CharField(max_length=256) #image url
    location  = models.CharField(max_length=20, null=True, blank=True)
    STATUS_TYPE_CHOICES=(
        (1,u'正常'),
        (2,u'封禁'),
    )
    status_type  = models.IntegerField(choices=STATUS_TYPE_CHOICES,default=1)
    retain_count = models.IntegerField(default=1) #用户repin之后，retain_count+1，当retain_count=0时，删除Pic。创建时，retain_count=1。
    def __unicode__(self):
        return "picture:"+self.image+",retain:"+str(self.retain_count)
    def retain(self):
        self.retain_count = self.retain_count+1
        self.save()
    def release(self):
        self.retain_count = self.retain_count-1
        if self.retain_count == 0:
            self.delete()
        else:
            self.save

class PictureStatus(models.Model):
    picture     = models.ForeignKey(Picture)
    description = models.CharField(max_length=140, null=True, blank=True)
    STATUS_TYPE_CHOICES=(
        (1,u'原创'),
        (2,u'转发'),
        (3,u'被举报'),
        (4,u'封禁'),
    )
    board       = models.ForeignKey(Board,related_name='pictureStatuses')
    via         = models.ForeignKey(User, null=True, blank=True) #从哪个用户得到此图片，只在status_type=2时才出现
    status_type = models.IntegerField(choices=STATUS_TYPE_CHOICES,default=1)

    def __unicode__(self):
        return "picture:"+unicode(self.picture)

class UserAddition(models.Model):
    user         = models.OneToOneField(User,related_name='addition')
    nick         = models.CharField(max_length=50)
    avatar       = models.CharField(max_length=255,null=True, blank=True)
    location     = models.CharField(max_length=20, null=True, blank=True)
    introduction = models.TextField()
    def create_user_addition(sender, instance, created, **kwargs):
        if created:
            UserAddition.objects.create(user=instance)
    post_save.connect(create_user_addition, sender=User)
    
class Comment(models.Model):
    picture_status = models.ForeignKey(PictureStatus, related_name = 'comments')
    by             = models.ForeignKey(User, related_name='my_comments') #发表评论的用户
    text           = models.CharField(max_length=140, null=True, blank=True)
    to             = models.ForeignKey(User, related_name = 'comments_to_me') #有关用户

class PSMessage(models.Model):
    '''
    作为“消息”使用。当有人评论你的ps或者有人follow你的时候，产生消息。
    客户端可以定时循环请求这个model。
    '''
    by   = models.ForeignKey(User)
    to   = models.ForeignKey(User, related_name = 'messages_to_me') #有关用户
    text =  models.CharField(max_length=140, null=True, blank=True)
    PSMESSAGE_TYPES=(
        (1,u'Following Message'),
        (2,u'Commentment Message'),
    )
    message_type = models.IntegerField(choices=PSMESSAGE_TYPES)
    extra        = models.CharField(max_length = 140, null=True, blank=True) #其他信息，比如被评论的psId，用于客户端连接到ps detail。