# Паспорт: сервер

Источник: `syimykkalykov1999/LawBid`, папка `apps/api` (NestJS 11 + Prisma 6), плюс `infra/`, `scripts/`, `.github/workflows/`. Снято 11.10.2026.
Решения по серверу: `lawbid/docs/decisions.md`, раздел 16.

Колонка «Решение» заполняется владельцем: **оставить / убрать / изменить: …**. Ключи и пароли в паспорт не выписываются, только названия переменных.

## 1. Что это и как устроено

- Один сервер API (NestJS) и отдельный фоновый процесс (worker) на том же коде: задачи по расписанию и очереди (BullMQ через Redis).
- Живые события (чат, звонки, счётчики) идут через Socket.IO, между копиями сервера через Redis.
- Объём: 924 файла кода, 72 модуля, 146 таблиц, 63 перечисления, 142 миграции.
- Боевая среда: AWS us-east-1 (ECS, ALB, S3, CloudFront, KMS, SES, ElastiCache Redis), база CockroachDB. Описано в Terraform (`infra/`).
- Выкладка и откат: GitHub Actions (`deploy.yml`, `rollback.yml` — кнопка «Откатить прод»).
- Два режима данных: основная база и отдельная демо-база (`DEMO_DATABASE_URL`, модуль `demo`). Есть третья база для хранения удалённого (`RETENTION_DATABASE_URL`).

| Часть | Решение |
|---|---|
| NestJS + Prisma + CockroachDB | |
| Отдельный worker для задач | |
| Socket.IO + Redis | |
| Демо-база отдельно от основной | |

## 2. Модули (что делает сервер)

Строки — модули из `apps/api/src/modules`, в скобках адрес API. Объём в строках кода без тестов.

### 2.1 Вход и аккаунт
| Модуль | Что делает | Строк | Решение |
|---|---|---|---|
| auth (`/auth`) | Вход по телефону/почте с кодом, Google и Apple, токены, сессии, повторный вход для опасных действий | 6489 | |
| users (`/users/me`) | Свой аккаунт: настройки, тема, удаление | 2806 | |
| profiles (`/attorneys`, `/clients`, `/practice-areas`) | Профили адвоката и клиента, области права | 1944 | |
| verification (`/verification`) | Проверка адвоката: лицензия, документы, автопроверка по реестрам штатов (NY Open Data, Socrata) | 5876 | |
| client-badge (`/verification/client`) | Золотой значок клиента: документы → одобрение → $10/мес | 1384 | |
| attorney-trust (`/trust`) | Рейтинг доверия адвоката, блок номеров адвокатов | 6323 | |
| client-fraud | Поиск мошенников-клиентов по отпечаткам устройства | 2578 | |
| account-bans, blocks | Баны аккаунтов, блокировка пользователей | 485 | |
| privacy (`/users/me/data-export`) | Выгрузка своих данных, обезличивание | 1223 | |
| presence | Статус «в сети» | 187 | |

### 2.2 Кейсы и биды
| Модуль | Что делает | Строк | Решение |
|---|---|---|---|
| cases | Кейсы клиента, жизненный цикл, споры, жалобы на контакт | 8754 | |
| bids | Биды адвокатов | 2064 | |
| negotiations | Только машина состояний предложения (64 строки), отдельного API нет | 64 | |
| case-comments | Комментарии к кейсу | 581 | |
| case-history (`/users/me/case-history`) | История кейсов, выгрузка в PDF | 1080 | |
| case-payments | Оплата адвокату через платформу (Stripe Connect), возвраты, чеки PDF | 4516 | |
| journal | Журнал событий кейса с цепочкой проверки | 256 | |
| assistants (`/cases/:id/bid-draft`, `/admin/teams`) | Помощники адвоката, черновики бидов, задачи адвоката | 4747 | |
| document-templates | Шаблоны документов | 1184 | |
| reviews, client-reviews | Отзывы об адвокате и о клиенте, апелляции | 3398 | |

### 2.3 Лента, контент, общение
| Модуль | Что делает | Строк | Решение |
|---|---|---|---|
| feed (`/feed`) | Лента и рекомендации | 776 | |
| posts | Посты, медиа, вложения, теги, вебхук видео | 2239 | |
| videos | Рилсы (Bunny Stream) | 791 | |
| comments, mentions | Комментарии к постам, упоминания | 876 | |
| follows | Подписки на людей | 705 | |
| search | Поиск, популярные теги | 1655 | |
| stickers (`/stickers`) | Наборы стикеров | 701 | |
| chat (`/conversations`) | Чаты, папки, запросы на переписку; текст сообщений шифруется | 2287 | |
| calls | Аудио/видеозвонки (WebRTC через TURN) | 869 | |
| realtime | Socket.IO шлюз | 589 | |
| notifications | Уведомления, пуш (FCM), тихие часы | 3538 | |
| translation (`/translations`) | Перевод постов через Google Translate | 480 | |
| i18n (`/i18n`) | Тексты приложения из базы, импорт xlsx | 1326 | |
| counters | Счётчики (лайки и т. п.) с пересчётом | 314 | |
| reports (`/reports`), moderation | Жалобы и модерация | 1524 | |
| files (`/files`) | Загрузка файлов в S3, сжатие фото, HEIC, проверка на вирусы (ClamAV) | 3459 | |

### 2.4 Деньги и рост
| Модуль | Что делает | Строк | Решение |
|---|---|---|---|
| billing (`/subscriptions`, `/pricing`, `/webhooks`) | Подписка адвоката через Stripe, вебхуки, тестовая «фальшивая оплата» | 5669 | |
| plans (`/client-plans`) | Конструктор тарифов, права по тарифу, платный план клиента | 2013 | |
| subscriptions | Обёртка над подпиской (184 строки) | 184 | |
| promotions | Продвижение кейсов и постов | 3244 | |
| referrals (`/referrals`) | Рефералы (на запуске ВЫКЛ) | 2385 | |
| partners (`/partners`) | Партнёрка (на запуске ВЫКЛ) | 3298 | |
| country-partners | Партнёры стран (на запуске ВЫКЛ) | 2006 | |
| rewards | Премии сотрудникам | 1163 | |
| outreach | Рассылки адвокатам для привлечения, отписки | 4363 | |
| demo (`/demo`) | Демо-режим и демо-аккаунты | 5131 | |
| countries | Страны, лист ожидания | 1147 | |
| feature-flags (`/config`) | Флаги, минимальная версия приложения | 734 | |

### 2.5 Админка и служебное
| Модуль | Что делает | Строк | Решение |
|---|---|---|---|
| admin, admin-auth, admin-access | Админы, роли, вход с паролем и TOTP, журнал действий, дашборд | 5248 | |
| admin-users, admin-cases, admin-content, admin-sanctions | Работа с людьми, кейсами, контентом, санкциями | 6081 | |
| admin-billing | Тарифы, цены, промокоды, возвраты, лимиты мест | 5049 | |
| admin-config, admin-integrations | Настройки и ключи сервисов из админки (шифруются) | 2192 | |
| admin-media, storage | Медиа, хранилище, снимки, очистка | 2527 | |
| admin-ops (`/admin/system-health`) | Здоровье системы | 592 | |
| admin-payroll, treasury | Зарплаты сотрудникам (авто-зарплата ВЫКЛ), расходы и выплаты | 3833 | |
| admin-data-requests | Запросы на данные (закон о приватности) | 683 | |
| admin-email-templates | Шаблоны писем | 796 | |
| support | Поддержка: тикеты, макросы, агенты | 2784 | |
| legal, legal-documents | Юридические документы и согласия | 3120 | |
| workspace | Рабочее место админа | 300 | |
| health (`/health`) | Проверка живости для балансировщика | 171 | |
| dev (`/dev/echo`) | Тестовая заглушка, только при NODE_ENV=development | 51 | |

## 3. Какие данные хранит

База CockroachDB, схема `apps/api/prisma/schema.prisma` (146 таблиц). Медиа и документы хранятся не в базе, а в S3 (два бакета: `media`, `documents`), раздаются через CDN.

| Группа | Таблицы | Решение |
|---|---|---|
| Люди и вход | User, UserIdentifier, Session, AuthEvent, OnboardingState, BlockedEmailDomain, IdentityFingerprint, PushToken | |
| Профили | ClientProfile, AttorneyProfile, AttorneyLicense, AttorneyPracticeArea, PracticeArea, Country, CountryWaitlist, State, NewCaseAlertPractice | |
| Проверка | VerificationRequest, VerificationDocument, VerificationCheck, StateBarRegistry, ClientVerification, AttorneyTrust(+Event), BarNumberBlock(+Event), ClientFraudProfile, ClientFraudEvent | |
| Кейсы | Case, CaseState, Bid, BidOffer, BidDraft, CaseInvite, CaseJournal, ContactDisclosure, ContactIssueReport, CaseDispute, CaseComment(+Like), CaseShare, CasePhoto | |
| Отзывы | Review, ReviewHelpfulVote, ClientReview, ClientReviewHelpfulVote, ClientReviewAppeal | |
| Лента | Post, PostMedia, PostAttachment, Tag, PostTag, Comment, PostLike, PostRepost, CommentLike, PostShare, SavedItem, Follow, UserBlock, VideoAsset, Sticker, StickerPack, UserStickerPack, UserRecentSticker | |
| Чаты и звонки | Conversation, ChatFolder, ConversationParticipant, Message, Call | |
| Уведомления | Notification, NotificationSetting, NotificationQuietHours, AdminBroadcast | |
| Помощники и задачи | AssistantMembership, AssistantActivity, AssistantRequest, AssistantLiabilityAcceptance, AttorneyTask(+Place, Person, Step) | |
| Деньги | StripeCustomer, Subscription, Payment, StripeWebhookEvent, Refund, Plan, PlanPrice, ClientSubscription, ContractGrant, SeatLimitRequest, PromoCode, PromoRedemption, CasePromotion, PromotionView, CasePayment, PaymentRequest, ConnectedCustomer, CasePaymentRefund | |
| Рост | ReferralCode, Referral, Partner, PartnerCommission, CountryPartner, CountryPartnerSettlement, OutreachLead, OutreachActivity, OutreachTemplate, OutreachSuppression, DemoAccount | |
| Модерация | Report, DmcaNotice, ModerationAction, AccountBan | |
| Админка | AdminProfile, AdminRoleTemplate, AdminCredential, AuditLog, DataAccessRequest, DataAccessLog, DataExportJob, SupportTicket, SupportMessage, SupportMacro, SupportAgent, StaffReward, EmailTemplate, PayrollEmployee, PayrollPayout, PayrollAccrual, TreasuryExpense, TreasuryPayout, PayoutAccount, StorageSnapshot | |
| Настройки и тексты | FeatureFlag, AppConfig, IntegrationCredential, IntegrationCustomProvider, I18nLanguage, I18nKey, I18nTranslation, I18nBundleVersion, LegalDocument, UserConsent, DocumentTemplate, File | |

Все таблицы используются кодом (проверено поиском по `src`).

## 4. Внешние сервисы

Ключи большинства сервисов можно задать и в переменных окружения, и из админки (хранятся в базе зашифрованными, `common/secrets`).

| Сервис | Для чего | Переменные (только названия) | Решение |
|---|---|---|---|
| AWS ECS, ALB, автомасштаб | Серверы API и worker | — | |
| AWS S3 + CloudFront + KMS | Файлы, фото, документы | `S3_*`, `MEDIA_CDN_BASE_URL` | |
| AWS SES | Почта (на запуске ВЫКЛ, заявка отклонена 04.10) | `SES_REGION`, `SES_FROM_ADDRESS` | |
| AWS Budgets / ECS API | Защита от перерасхода: сервер сам уменьшает мощность | — | |
| CockroachDB | База | `DATABASE_URL`, `DEMO_DATABASE_URL`, `RETENTION_DATABASE_URL` | |
| Redis | Очереди, живые события, ограничения частоты | `REDIS_URL` | |
| Twilio | СМС с кодом | `TWILIO_*`, `SMS_PROVIDER` | |
| Google / Apple вход | Вход через аккаунты | `GOOGLE_CLIENT_IDS`, `APPLE_BUNDLE_IDS`, `APPLE_TEAM_ID` | |
| Firebase Cloud Messaging | Пуш-уведомления | `FCM_*` | |
| Stripe | Подписки, промокоды, оплата адвокату (Connect) | `STRIPE_*` | |
| Bunny Stream | Видео и рилсы | `BUNNY_*` | |
| Google Translate | Перевод постов | `GOOGLE_TRANSLATE_API_KEY` | |
| Persona | Платная проверка личности (есть заготовка, по умолчанию ручная проверка) | `PERSONA_API_KEY` | |
| NY Open Data / Socrata | Проверка лицензии адвоката по реестрам | `NY_OPEN_DATA_APP_TOKEN` | |
| TURN/STUN (coturn) | Звонки | `TURN_*`, `STUN_URLS` | |
| ClamAV | Проверка файлов на вирусы | `CLAMAV_*` | |
| Sentry | Ошибки сервера | `SENTRY_DSN` | |
| OpenTelemetry + Grafana | Трассировка и графики | `OTEL_EXPORTER_OTLP_ENDPOINT` | |
| Список одноразовых почт | Запрет временных адресов при входе | `DISPOSABLE_DOMAINS_URL` | |

Лимиты расходов на каждый платный сервис (СМС, почта, проверка личности, хранилище, перевод, видео) задаются переменными `BUDGET_*`.

## 5. Фоновые задачи (worker)

48 задач по расписанию (`src/jobs/jobs.constants.ts`): очистка сессий и кодов, напоминания по отзывам и кейсам, автозакрытие и архив кейсов, истечение лицензий и повторная проверка по реестрам, истечение подписок и продвижений, рекомендации ленты и популярные теги, хранение и чистка уведомлений, журнала, хранилища, обезличивание, снимки хранилища, проверка бэкапа, контроль расходов и автомасштаб, партнёры, премии, казна, поддержка, мошенничество, звонки, видео.

| Часть | Решение |
|---|---|
| Все 48 задач переносить | |

## 6. Мусор и неиспользуемый код

| Что | Где | Предложение | Решение |
|---|---|---|---|
| Тестовая заглушка `/dev/echo` | `modules/dev` | убрать, нужна была до появления настоящих адресов | |
| Модуль negotiations без своего API, только машина состояний | `modules/negotiations` | влить в bids | |
| Модуль subscriptions (184 строки), обёртка рядом с billing и plans | `modules/subscriptions` | влить в billing | |
| Две системы подписок: старая `Subscription` (адвокат) и новая `Plan`/`ClientSubscription`; в коде есть ветка «legacy» для старых подписчиков | `modules/plans/entitlements.service.ts`, `admin-plans.service.ts` | оставить одну систему `Plan`, если на боевой базе нет платных подписчиков | |
| Перенос старых профилей из данных онбординга (`legacyProfile`) | `users/services/user-profiles.service.ts` | убрать, если перед запуском база стирается | |
| «Фальшивая оплата» и фальшивый Bunny для разработки | `billing/fake-checkout.controller.ts`, `tools/fake-bunny.mjs` | оставить только для разработки | |
| Папка с xlsx обновлений ключей | `tmp-import/` в корне | не переносить, переводы уже готовы | |
| Скрипт проверки миграций с предыдущей версии | `scripts/migrate-from-previous.mjs` | не нужен в чистом репозитории, начнём с одной миграции | |
| 142 миграции | `prisma/migrations` | склеить в одну начальную | |
| Демо-сиды под конкретных людей | `scripts/seed-demo-sima.mjs`, `seed-demo-team.mjs` | объединить в один `seed-demo` | |
| Старые документы этапов и аудиты | `docs/01_…07_`, `AUDIT_*`, `REMAINING.md` | не переносить, есть ТЗ и решения | |
| Нагрузочные тесты k6 | `apps/api/k6` | оставить (нагрузочный тест после запуска) | |
| MinIO и MailHog в `docker-compose.yml` | корень | оставить для локальной разработки | |

Неподключённых модулей и неиспользуемых таблиц не найдено.

## 7. Известные ошибки, которые нельзя повторить

- 07.10. Фото и аватары пустые: CDN не мог расшифровать файлы из S3 (ключ KMS). Исправлено в PR #109, нужны `terraform apply` и выкладка. В новом репозитории сразу дать CDN право на ключ KMS.
- Доступ к базе открыт всем адресам. Сузить до серверов AWS.
- Почта SES отклонена AWS 04.10, сервер должен работать без почты (вход по СМС).
- Предел автомасштаба API: 4 копии, поднимать до 10 только при нагрузке или перед большой рекламой.
- Перед запуском стереть данные тестеров (база, файлы, видео): `scripts/prelaunch-wipe.ts`, запускает владелец.
- Флаги на запуск: ВКЛ подписки, промокоды, рилсы; ВЫКЛ рефералы, партнёрка, авто-зарплата, партнёры стран, «Вывести», оплата адвокату в приложении, почта.
- Не сделано, перенести в план: сжатие ответов (gzip), ночной нагрузочный тест, перевод 399 английских текстов.

## 8. План переноса (принято владельцем 11.10.2026, предложения по умолчанию)

Владелец принял мои предложения из раздела 6. Что это значит для чистого репозитория:

| Что | Как переносим |
|---|---|
| Подписки | Одна система: новый конструктор тарифов (`Plan`, `PlanPrice`, `ClientSubscription`). Старая `Subscription` и ветка «legacy» не переносятся. Перед запуском база стирается, платных подписчиков нет, миграция данных не нужна. |
| Миграции | Склеить 142 миграции в одну начальную. |
| `/dev/echo` | Не переносить. |
| `tmp-import/` | Не переносить, переводы уже готовы. |
| Модули-обёртки `negotiations` и `subscriptions` | Влить в `bids` и `billing`. |
| Перенос старых профилей онбординга (`legacyProfile`) | Не переносить. |
| `scripts/migrate-from-previous.mjs`, старые документы этапов и аудиты | Не переносить. |
| Демо-сиды под конкретных людей | Свести в один `seed-demo`. |
| Всё остальное (модули, таблицы, 48 задач, k6, docker-compose) | Переносить как есть. |

Вход в тестовой сборке: демо-режим, любой номер, код `000000`. Настоящий Twilio только на этапе 4–5 и с тестовыми ключами (решение владельца 11.10).
