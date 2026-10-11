# Payments disclaimer / Дисклеймер об оплате

Shown in the LawBid app before a client pays an attorney, when an attorney connects a Stripe account, and on every payment record. Editable in the admin: Деньги → Оплаты адвокатам → Юридический текст. Default text below (to be reviewed by a lawyer before launch).

## English

LawBid only provides the technical means to pay. Your payment goes directly to the attorney's own Stripe account; LawBid is not a party to the agreement between you and the attorney, receives no share of the attorney's fee, is not a law firm and does not provide legal services. Payment terms, refunds and disputes are between you and the attorney. Payments are processed by Stripe under Stripe's terms.

## Русский

LawBid только предоставляет техническую возможность оплаты. Платёж идёт напрямую адвокату на его счёт в Stripe; LawBid не является стороной соглашения между вами и адвокатом, не получает долю гонорара, не является юридической фирмой и не оказывает юридических услуг. Условия оплаты, возвраты и споры решаются между вами и адвокатом. Обработку платежей выполняет Stripe по его условиям.

## Why no percentage commission

ABA Model Rule 5.4 (and the equivalent rule in every state) forbids a lawyer from sharing legal fees with a non-lawyer. A platform commission that is a percentage of the attorney's fee can be read as exactly that, so LawBid charges none: the attorney pays only a subscription, and the platform settings offer at most a flat service charge per payment (off by default). Stripe's own card-processing cost is passed to the client by default so the attorney receives the full amount.

## Комиссия Stripe — кто платит (решение владельца, 2026-10-05, уточнено 03:01)

Платёж списывается напрямую на Stripe-аккаунт адвоката (direct charge), поэтому плату Stripe (2.9 % + 30 ¢) Stripe удерживает с адвоката, никогда с LawBid. Кто её покрывает — дело адвоката и клиента, LawBid не вмешивается, и это согласуется по каждому счёту как бид (уточнение 03:03): адвокат в счёте предлагает вариант («платит клиент» сверх суммы / «плачу я» из суммы / «пополам»; его настройка в «Приём оплат» лишь предзаполняет первое предложение), клиент видит разбивку (сумма адвокату, комиссия Stripe, итого) и принимает или предлагает своё, адвокат принимает или отвечает; оплата возможна только после согласия обеих сторон (оплата предложения адвоката и есть согласие); статусы «предложено / встречное / согласовано» в чате; лимит встречных предложений задаётся в админке (по умолчанию 5, как раунды бидов). В админке (Деньги → Оплаты адвокатам) только удобство для владельца: значение по умолчанию для адвокатов, которые ещё не выбирали, ставка Stripe как число (при изменении тарифа меняется цифра, не код) и обзор — кто что выбрал, статусы, споры, CSV. Юнит-тест проверяет, что ни при одном сочетании баланс платформы не уходит в минус.
