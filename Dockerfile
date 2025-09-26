FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies required for psycopg-binary
RUN apt-get update && apt-get install -y build-essential libpq-dev gcc curl dos2unix \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Ensure entrypoint.sh has correct permissions
RUN dos2unix /airnbn/entrypoint.sh || true
RUN chmod +x /airnbn/entrypoint.sh

ENTRYPOINT ["/airnbn/entrypoint.sh"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
# CMD ["gunicorn","airnbn.wsgi:application","--bind","0.0.0.0:8000","--workers","3"]