from django.shortcuts import render, redirect
from .models import *
# Create your views here.
def Insertpage(request):
    return render(request,"insert.html")

def Insertdata(request):
    #Data come from html view
    fname=request.POST['fname']
    lname=request.POST['lname']
    mail=request.POST['mail']
    phone=request.POST['phone']

    #Creating object of the model Class
    #inserting data into the table
    newuser=register.objects.create(Firstname=fname,Lastname=lname,Email=mail,Contact=phone)

    #After insert render on show.html
    return redirect(Showpage) 

def Showpage(request):
    #select * from table
    all_data=register.objects.all()
    return render(request,"show.html",{'key1':all_data})

def Editpage(request,pk):
    #fetching the data of particular ID
    get_data=register.objects.get(id=pk)
    return render(request,"edit.html",{'key2':get_data})

def Update(request,pk):
    updatedata=register.objects.get(id=pk)
    updatedata.Firstname=request.POST['fname']
    updatedata.Lastname=request.POST['lname']
    updatedata.Email=request.POST['mail']
    updatedata.Contact=request.POST['phone']
    #query for save
    updatedata.save()
    return redirect(Showpage) 

def Delete(request,pk):
    deletedata=register.objects.get(id=pk)
    #quere for delete
    deletedata.delete()
    return redirect(Showpage) 



