from django.shortcuts import render
from django.http import JsonResponse
from django.http import HttpResponseRedirect
from default.models import Todolist
# Create your views here.

def index(request):
    return render(request, "index.html")


def todogetlist(request):
    dataset = Todolist.objects.all()
    todolist = []
    for item in dataset:
        temp ={"id":item.id,"content":item.content}
        todolist.append(temp)

    res ={"todolist":todolist,'username':"12323"}
    return JsonResponse(res)


def todoadd(request):
    todo = request.POST['todo']
    Todolist.objects.create(content=todo)
    res ={"success":"true",'username':"12323"}
    return JsonResponse(res)


def todoedit(request):
    id = request.POST['id']
    content = request.POST['todo']
    todo = Todolist.objects.get(id=id)
    todo.content =content
    todo.save()
    res ={"success":"true"}
    return JsonResponse(res)

def tododel(request):
    id = request.GET['id']
    Todolist.objects.get(id=id).delete()
    res ={"success":"true",'username':"12323"}
    return JsonResponse(res)
def jump(request):
    print("11111")
    return render(request,'jump.html')