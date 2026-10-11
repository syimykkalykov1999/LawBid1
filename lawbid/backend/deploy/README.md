# Поднять тестовый сервер (для владельца, с телефона)

Нужна одна машина с Ubuntu 24.04 (2 процессора, 4 ГБ памяти). Например Hetzner Cloud CX22/CX23, примерно 5–7 евро в месяц.

1. Зайти на hetzner.com/cloud, создать проект, нажать «Add Server».
2. Выбрать Ubuntu 24.04, тип CX22 (или CX23), любую страну.
3. В поле «Cloud config» (внизу, «User data») вставить текст из `cloud-init.yml`.
4. Нажать «Create & Buy now».
5. Через 8–10 минут написать Claude IP-адрес машины. Адрес сервера будет `https://<ip через дефисы>.sslip.io/api/v1`.

Дальше всё обновляется само после каждого изменения в GitHub. Остановить расходы: удалить машину в Hetzner.

Проверка вручную на машине: `docker compose -f /opt/lawbid/lawbid/backend/deploy/docker-compose.yml ps`.
