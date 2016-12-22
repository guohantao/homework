#coding=utf-8
from django.shortcuts import render

# Create your views here.
todolist =[]
todo = {'id':1, 'content':'上午八点半教三139听报告'}
todolist.append(todo)
todo = {'id':2, 'content':'晚上7点参加秋之韵决赛'}
todolist.append(todo)


def getlist(request):
    return render(request, 'getlist.html', {'todolist':todolist})

def addlist(request):
    if request.method == 'GET':
        return render(request,'addlist.html')
    elif request.method == 'POST':
        content = request.POST['content']
        todo = {'id':len(todolist)+1,'content':content}
        todolist.append(todo)
        return render(request,'getlist.html',{'todolist':todolist})

def updatelist(request):
    if request.method == 'GET':
        todoid = request.GET['todoid']
        todo = todolist[int(todoid)-1]
        return render(request,'updatelist.html',{'todo':todo})
    elif request.method == 'POST':
        todoid = request.POST['id']
        content = request.POST['content']
        todolist[int(todoid)-1]['content']=content
        return render(request,'getlist.html',{'todolist':todolist})


def dellist(request):
    todoid = request.GET['todoid']
    todolist.pop(int(todoid)-1)
    for i in range(len(todolist)):
        todolist[i]['id'] = i+1
    return  render(request,'getlist.html',{'todolist':todolist})
