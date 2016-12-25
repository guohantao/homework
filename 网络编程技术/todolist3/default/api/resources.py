__author__ = 'wzl'

from tastypie.resources import ModelResource
from default.models import Todolist


class TodolistResource(ModelResource):
    class Meta:
        queryset = Todolist.objects.all()
        allowed_methods = ['get']