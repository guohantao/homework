from django.shortcuts import render
from django.http import JsonResponse


# Create your views here.


def index(request):
    return render(request,'index.html')


def apiaddtodo(request):
    if request.method == "POST":
        todo = request.POST['todo']
    else:
        todo = request.GET['todo']
    result ={}
    result['status'] = "success"
    result['message'] = todo +"is added"
    return JsonResponse(result)

