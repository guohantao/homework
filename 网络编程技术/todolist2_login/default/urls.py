#coding=utf-8
from django.conf.urls import url

from . import views

urlpatterns = [
     url(r'^$',views.getlist),  #获取todolist列表
     url(r'^add/$',views.addlist),#添加todolist项目
     url(r'^update/$',views.updatelist),#更新todolist项目
     url(r'^del/$',views.dellist),#删除todolist项目


     url(r'^login/$',views.my_login), #登陆
     url(r'^logout/$',views.my_logout),#注销

]