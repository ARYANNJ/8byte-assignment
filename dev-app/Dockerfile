FROM ghcr.io/aryannj/dev-app:latest

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app


COPY requirements.txt .

RUN pip install --no-cache-dir --no-compile -r requirements.txt

RUN groupadd --system --gid 10001 appgroup && \
    useradd --system --uid 10001 --gid appgroup \
    --no-create-home appuser

COPY --chown=10001:10001 main.py .

USER 10001:10001

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
