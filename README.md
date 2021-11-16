# (В РАЗРАБОТКЕ!!!)
# Инструменты подготовки репозитариев для выполнения обновления

[![GitHub release](https://img.shields.io/github/release/silverbulleters/rector.svg?style=flat-square)](https://github.com/silverbulleters/rector/releases)
[![GitHub license](https://img.shields.io/github/license/silverbulleters/rector.svg?style=flat-square)](https://github.com/ArKuznetsov/rector/blob/develop/LICENSE)
[![Build Status](https://img.shields.io/github/workflow/status/silverbulleters/rector/%D0%9A%D0%BE%D0%BD%D1%82%D1%80%D0%BE%D0%BB%D1%8C%20%D0%BA%D0%B0%D1%87%D0%B5%D1%81%D1%82%D0%B2%D0%B0)](https://github.com/silverbulleters/iracli/actions/)
[![Quality Gate](https://open.checkbsl.org/api/project_badges/measure?project=rector&metric=alert_status)](https://open.checkbsl.org/dashboard/index/rector)
[![Coverage](https://open.checkbsl.org/api/project_badges/measure?project=rector&metric=coverage)](https://open.checkbsl.org/dashboard/index/rector)
[![Tech debt](https://open.checkbsl.org/api/project_badges/measure?project=rector&metric=sqale_index)](https://open.checkbsl.org/dashboard/index/rector)

Инструменты для подготовки репозитариев git конфигураций 1С для автоматизации процессов обновления доработанных типовых конфигураций.

## Требования

Требуются следующие библиотеки и инструменты:
- [git](https://git-scm.com) - система контроля версий GIT
- [Платформа 1С: Предприятие 8.3](https://releases.1c.ru/project/Platform83)
- Возможно использование [учебной версии платформы 1С: Предприятие 8.3](https://releases.1c.ru/project/PlTr83)

Для получения нужных версий конфигурации поставщика можно воспользоваться приложением [YARD](https://github.com/arkuznetsov/yard).

## Установка

### Склонировать репозитарий `https://github.com/silverbulleters/rector`

```bat

git clone https://github.com/silverbulleters/rector.git

```

### Собрать пакет `rector`

```bat

cd <каталог репозитария>

opm build .

```

### Установить пакет `rector`

```bat

cd <каталог репозитария>

opm install -f rector*.ospx

```

### Общие параметры `rector`

* **-v, --version** - показать версию приложения
* **--v8version** (переменная среды `RECTOR_V8VERSION`) - маска версии платформы 1С (8.3, 8.3.5, 8.3.6.2299 и т.п.)

## Команда подготовки репозитария для выполнения обновления (`prepare-update, p`)

Команда позволяет подготовить репозитарий git для выполнения обновления конфигурации 1С. Для подготовки репозитария требуется 3 конфигурации:

* обновляемая (доработанная) конфигурация
* исходная конфигурация поставщика
* новая конфигурация поставщика

Каждая из 3-х конфигураций может быть указана в виде:

* Пути к файлу конфигурации CF
* Пути к хранилищу конфигурации (файловое, tcp, http(s))
* Пути к выгруженным исходникам конфигурации

Если путь к исходной конфигурации поставщика не указан, то будет произведена попытка получения конфигурации поставщика из обновляемой конфигурации.

### Общие параметры команды

* **-e, --project-path** (переменная среды `RECTOR_PROJECT_PATH`) - путь к репозитарию подготовки обновления
* **-c, --src-current** (переменная среды `RECTOR_SRC_CURRENT`) - путь к обновляемой (доработанной) конфигурации (cf-файл, хранилище, репозитарий git с xml-выгрузкой конфигурации)
* **-b, --src-base** (переменная среды `RECTOR_SRC_BASE`) - путь к исходной конфигурации поставщика (cf-файл, хранилище, репозитарий git с xml-выгрузкой конфигурации)
* **-n, --src-new** (переменная среды `RECTOR_SRC_NEW`) - путь к новой конфигурации поставщика (cf-файл, хранилище, репозитарий git с xml-выгрузкой конфигурации)

* **-t, --temp-dir** (переменная среды `RECTOR_TEMP_DIR`) - каталог временных файлов
* **-i, --ib-connection** (переменная среды `RECTOR_IB_CONNECTION`) - путь подключения к информационной базе для подготовки обновления

### Дополнительные параметры

#### Обновляемая (доработанная) конфигурация

##### Указан путь к храниищу

* **--cu, --src-current-user** (переменная среды `RECTOR_SRC_CURRENT_USER`) - пользователь хранилища обновляемой конфигурации
* **--cp, --src-current-pwd** (переменная среды `RECTOR_SRC_CURRENT_PWD`) - пароль пользователя хранилища обновляемой конфигурации
* **--cv, --src-current-version** (переменная среды `RECTOR_CURRENT_VERSION`) - версия в хранилище обновляемой конфигурации (по умолчанию последняя версия)

##### Указан путь к репозитарию git с xml-выгрузкой

* **--cb, --src-current-branch** (переменная среды `RECTOR_CURRENT_BRANCH`) - имя ветки в git-репозитарии обновляемой конфигурации
* **--cc, --src-current-commit** (переменная среды `RECTOR_CURRENT_COMMIT`) - хэш коммита в git-репозитарии обновляемой конфигурации

#### Исходная конфигурация поставщика

Если не указан путь к исходной конфигурации поставщика, то будет выполнена попытка получения конфигурации поставщика из обновляемой конфигурации.

##### Указан путь к храниищу

* **--bu, --src-base-user** (переменная среды `RECTOR_SRC_BASE_USER`) - пользователь хранилища исходной конфигурации поставщика
* **--bp, --src-base-pwd** (переменная среды `RECTOR_SRC_BASE_PWD`) - пароль пользователя хранилища исходной конфигурации поставщика
* **--bv, --src-base-version** (переменная среды `RECTOR_SRC_BASE_VERSION`) - версия в хранилище исходной конфигурации поставщика (по умолчанию последняя версия)

##### Указан путь к репозитарию git с xml-выгрузкой

* **--bb, --src-base-branch** (переменная среды `RECTOR_SRC_BASE_BRANCH`) - имя ветки в git-репозитарии исходной конфигурации поставщика
* **--bc, --src-base-commit** (переменная среды `RECTOR_SRC_BASE_COMMIT`) - хэш коммита в git-репозитарии исходной конфигурации поставщика

#### Новая конфигурация поставщика

##### Указан путь к храниищу

* **--nu, --src-new-user** (переменная среды `RECTOR_SRC_NEW_USER`) - пользователь хранилища новой конфигурации поставщика
* **--np, --src-new-pwd** (переменная среды `RECTOR_SRC_NEW_PWD`) - пароль пользователя хранилища новой конфигурации поставщика
* **--nv, --src-new-version** (переменная среды `RECTOR_SRC_NEW_VERSION`) - версия в хранилище новой конфигурации поставщика (по умолчанию последняя версия)

##### Указан путь к репозитарию git с xml-выгрузкой

* **--nb, --src-new-branch** (переменная среды `RECTOR_SRC_NEW_BRANCH`) - имя ветки в git-репозитарии новой конфигурации поставщика
* **--nc, --src-new-commit** (переменная среды `RECTOR_SRC_NEW_COMMIT`) - хэш коммита в git-репозитарии новой конфигурации поставщика

### Примеры

#### Дорабатываемая конфигурация в хранилище

 * Текущая конфигурация поставщика не указывается. Новая конфигурация поставщика в файле CF.

```bat

rector --v8version 8.3.19 prepare-update -e "d:\repo\myConf" -c "tcp://myCRServer/myStorage --cu "User" --cp "Pa$$w0rd" -n "d:\templates\vendor\config\1.2.51.12\1cv8.cf" -t "d:\tmp\myConfTemp"

```

 * Текущая конфигурация поставщика в файле CF. Новая конфигурация поставщика в файле CF.

```bat

rector --v8version 8.3.19 prepare-update -e "d:\repo\myConf" -c "tcp://myCRServer/myStorage" --cu "User" --cp "Pa$$w0rd" -b "d:\templates\vendor\config\1.2.50.32\1cv8.cf" -n "d:\templates\vendor\config\1.2.51.12\1cv8.cf" -t "d:\tmp\myConfTemp"

```

#### Дорабатываемая конфигурация в файле CF

 * Текущая конфигурация поставщика не указывается. Новая конфигурация поставщика в файле CF.

```bat

rector --v8version 8.3.19 prepare-update -e "d:\repo\myConf" -c "d:\repo\myConf\1cv8_2001907071315.cf" --cu "User" --cp "Pa$$w0rd" -n "d:\templates\vendor\config\1.2.51.12\1cv8.cf" -t "d:\tmp\myConfTemp"

```

## Команда подготовки репозитария из хранилища 1С с веткой поставщика (`upload-from-repo, u`)

Команда выгружает версии хранилища 1С в репозитарий git создавая отдельную ветку с конфигурацией поставщика от имени поставщика. При выгрузке выполняется слияние основной ветки с веткой поставщика.

### Параметры команды

* **-e, --project-path** (переменная среды `RECTOR_PROJECT_PATH`) - путь к репозитарию подготовки обновления
* **-s, --storage-path** (переменная среды `RECTOR_STORAGE_PATH`) - путь к хранилищу конфигурации
* **-u, --storage-user** (переменная среды `RECTOR_STORAGE_USER`) - пользователь хранилища конфигурации
* **-p, --storage-pwd** (переменная среды `RECTOR_STORAGE_PWD`) - пароль пользователя хранилища конфигурации
* **-t, --temp-dir** (переменная среды `RECTOR_TEMP_DIR`) - каталог с временных файлов
* **-d, --domain-name** (переменная среды `RECTOR_DOMAIN_NAME`) - доменное имя для новых пользователей GIT
* **-a, --authors-path** (переменная среды `RECTOR_AUTHORS_PATH`) - путь к файлу AUTHORS
* **-c, --check-authors** (переменная среды `RECTOR_CHECK_AUTHORS`) - проверять наличие авторов в файле AUTHORS
* **-U, --ib-user** (переменная среды `RECTOR_IB_USER`) - пользователь информационной базы
* **-P, --ib-pwd** (переменная среды `RECTOR_IB_PWD`) - пароль пользователя информационной базы
* **-C, --ibconnection, --ib-connection** (переменная среды `RECTOR_IB_CONNECTION`) - путь подключения к информационной базе
* **--temp-ib-user** (переменная среды `RECTOR_TEMP_IB_USER`) - пользователь временной информационной базы
* **--temp-ib-pwd** (переменная среды `RECTOR_TEMP_IB_PWD`) - пароль пользователя временной информационной базы
* **--temp-ib-connection** (переменная среды `RECTOR_TEMP_IB_CONNECTION`) - путь подключения к  временной информационной базе
* **-v, --storage-version** (переменная среды `RECTOR_STORAGE_VERSION`) - начальный номер версии хранилища, с которого начинается экспорт

## Команда сборки репозитария git из репозитариев разработки и поставщика. (`collect-from-git, c`)

Выполняет сборку результирующего репозитария git из 2-х репозитариев: разработки и поставщика. При сборке выполняется слияние основной ветки с веткой поставщика.

## В РАЗРАБОТКЕ!!!
