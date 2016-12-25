from __future__ import unicode_literals

from django.db import models

# Create your models here.


class Personlist(models.Model):
    name = models.CharField(max_length=10)
    tel = models.CharField(max_length=10)
    email = models.CharField(max_length=10)
    address = models.CharField(max_length=10)
    QQ = models.CharField(max_length=10)

