FROM laudio/pyodbc:3.0.0
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . /app
WORKDIR /app
ENTRYPOINT [ "bash" ]