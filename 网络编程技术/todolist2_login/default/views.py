#coding=utf-8
from django.shortcuts import render
from django.http import HttpResponseRedirect
from default.models import Todolist
from django.contrib.auth import  authenticate,login,logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
import logging

# Create your views here.

logger = logging.getLogger('django')


def getlist(request):
    todolist = Todolist.objects.all()
    logger.info("XXXXXXXXXXXXXXXXXXXXXXXXlogging")
    return render(request, 'getlist.html', {'todolist':todolist})

#@login_required()
def addlist(request):
    if request.method == 'GET':
        return render(request,'addlist.html')
    elif request.method == 'POST':
        ct= request.POST['content']
        todo = Todolist(content=ct)
        todo.save()
        todolist = Todolist.objects.all()
        return render(request,'getlist.html',{'todolist':todolist})

#@login_required()
def updatelist(request):
    if request.method == 'GET':
        todoid = request.GET['todoid']
        todo = Todolist.objects.get(id=todoid)
        return render(request,'updatelist.html',{'todo':todo})
    elif request.method == 'POST':
        todoid = request.POST['id']
        content = request.POST['content']
        todo = Todolist.objects.get(id=todoid)
        todolist = Todolist.objects.all()
        todo.content = content
        todo.save()

        return render(request,'getlist.html',{'todolist':todolist})

'''''''@login_required()'''
def dellist(request):
    todoid = request.GET['todoid']
    Todolist.objects.get(id=todoid).delete()
    todolist= Todolist.objects.all()
    return  render(request,'getlist.html',{'todolist':todolist})


def my_login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    elif request.method == 'POST':
        username= request.POST['username']
        password= request.POST['password']
        user = authenticate(username=username,password=password)
        if user is not None:
            if user.is_active:
                login(request,user)
                #重定向到成功页面
            else:
                print ("user is not active")
                #重定向到失败页面，省略
        else:
            print ("user is None")
            #重定向到失败页面，省略
        print (request.session.keys())
        #print request.session['_auth_user_id']
        return HttpResponseRedirect("/")

def my_logout(request):
    logout(request)
    print (request.session.keys())
    return HttpResponseRedirect("/")



