FROM python:3.9

WORKDIR /app

RUN apt-get update

COPY . /app

RUN pip install --no-cache-dir django mysqlclient

EXPOSE 8000

CMD ["python","manage.py","runserver","0.0.0.0:8000"]
