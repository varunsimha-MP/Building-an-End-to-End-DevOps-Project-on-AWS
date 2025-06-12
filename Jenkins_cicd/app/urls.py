from django.urls import path
from . import views

urlpatterns = [
    path("",views.Insertpage,name='insertpage'),
    path("insert",views.Insertdata,name='insert'),
    path("showpage",views.Showpage,name='show'),
    path("editpage/<int:pk>",views.Editpage,name='edit'),
    path("update/<int:pk>",views.Update,name='update'),
    path("delete/<int:pk>",views.Delete,name='delete')
]
