"""todolist3 URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.8/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf.urls import include, url
from django.contrib import admin
from tastypie.api import Api
from default.api.resources import TodolistResource
from default import views

v1_api = Api(api_name='v1')
v1_api.register(TodolistResource())


urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),

    url(r'^$', views.index),

    url(r'^api/todogetlist/$', views.todogetlist),
    url(r'^api/todoadd/$', views.todoadd),
    url(r'^api/todoedit/$', views.todoedit),
    url(r'^api/tododel/$', views.tododel),
    url(r'^jump/$', views.jump),

    url(r'^api/', include(v1_api.urls)),
]
