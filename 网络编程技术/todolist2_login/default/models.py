from __future__ import unicode_literals

from django.db import models

# Create your models here.


class Todolist(models.Model):
    content = models.CharField(max_length=100)

