FROM python:3.11-slim as builder

WORKDIR /app
COPY requirements.txt .
# Устанавливаем зависимости в виртуальное окружение
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Финальный образ
FROM python:3.11-slim

# Безопасность: не используем root-пользователя
RUN useradd -m -u 1001 appuser
USER appuser
WORKDIR /home/appuser

# Копируем зависимости из стадии builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Копируем исходный код
COPY --chown=appuser:appuser app.py .

# Открываем порт и запускаем приложение
EXPOSE 5000
CMD ["python", "app.py"]
