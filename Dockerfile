FROM python:2.7
RUN pip install gordon
ADD app /app
WORKDIR /app
RUN gordon build
