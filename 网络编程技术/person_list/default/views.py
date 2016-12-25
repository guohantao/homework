#coding=utf-8
from django.shortcuts import render
from django.http import HttpResponseRedirect
from default.models import Personlist
from django.contrib.auth import  authenticate,login,logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
import logging

# Create your views here.

logger = logging.getLogger('django')


def getlist(request):
    personlist = Personlist.objects.all()
    logger.info("XXXXXXXXXXXXXXXXXXXXXXXXlogging")
    return render(request, 'table.html', {'personlist':personlist})

@login_required()
def addlist(request):
    if request.method == 'GET':
        return render(request,'add.html')
    elif request.method == 'POST':
        na= request.POST['name']
        te = request.POST['tel']
        em = request.POST['email']
        add = request.POST['address']
        Q = request.POST['QQ']
        person = Personlist(name=na,tel = te,email = em,address = add,QQ = Q)
        person.save()
        personlist = Personlist.objects.all()

        return render(request,'table.html',{'personlist':personlist})

@login_required()
def updatelist(request):
    if request.method == 'GET':
        person_id = request.GET['personid']
        person = Personlist.objects.get(id=person_id)
        return render(request,'updatepersonlist.html',{'person':person})
    elif request.method == 'POST':
        personid = request.POST['id']
        na = request.POST['name']
        te = request.POST['tel']
        em = request.POST['email']
        add = request.POST['address']
        Q = request.POST['QQ']
        person = Personlist.objects.get(id=personid)
        personlist = Personlist.objects.all()
        person.name=na
        person.tel=te
        person.email=em
        person.address=add
        person.QQ=Q
        person.save()



        return render(request,'table.html',{'personlist':personlist})




def searchlist(request):
    if request.method == 'GET':
        return render(request,'search.html')
    elif request.method == 'POST':
        na = request.POST['name']
        per = Personlist.objects.filter(name=na)
        return render(request,'showsearch.html',{"personlist":per})






@login_required()
def dellist(request):

    personid= request.GET['personid']
    Personlist.objects.get(id=personid).delete()
    personlist = Personlist.objects.all()



    return  render(request,'table.html',{'personlist':personlist})


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
            return HttpResponseRedirect("/login/")
            #重定向到失败页面，省略
        print (request.session.keys())
        #print request.session['_auth_user_id']
        return HttpResponseRedirect("/")

def my_logout(request):
    logout(request)
    print (request.session.keys())
    return HttpResponseRedirect("/")



