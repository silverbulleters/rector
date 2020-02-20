#Использовать fs
#Использовать logos

Перем Лог;
Перем ПараметрыЭкспорта;

Процедура ПриСозданииОбъекта()
	

КонецПроцедуры

Процедура ОписаниеКоманды(КомандаПриложения) Экспорт
	
	КомандаПриложения.Опция("e projectPath", "", "Путь к каталогу для экспорта")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_PROJECT_PATH");;

	КомандаПриложения.Опция("s storage-path", "", "Путь к хранилищу конфигурации")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_STORAGE_PATH");
		
	КомандаПриложения.Опция("u storage-user", "", "Пользователь хранилища конфигурации")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_USER");

	КомандаПриложения.Опция("p storage-psw", "", "Пароль пользователя хранилища конфигурации")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_USER");

	КомандаПриложения.Опция("t temp-dir", "", "Каталог с времменными файлами")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_TEMP_DIR");

	КомандаПриложения.Опция("d domain-name", "", "Доменное имя для новых пользователей GIT")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_DOMAIN_NAME");

	КомандаПриложения.Опция("a authors-path", "", "Путь к файлу AUTHORS")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_AUTHORS_PATH");

	КомандаПриложения.Опция("c check-authors", "", "Проверять наличие авторов в файле AUTHORS")
		.Флаговый()
		.ВОкружении("PREPARE_BASE_CHACK_AUTHORS")
		.ПоУмолчанию(Ложь);

	КомандаПриложения.Опция("temp-ib-user", "", "пользователь временной информационной базы")
		.ТСтрока()
		.ВОкружении("PREPARE_TEMP_BASE_USR PREPARE_TEMP_BASE_USER");

	КомандаПриложения.Опция("temp-ib-pwd", "", "пароль пользователя временной информационной базы")
		.ТСтрока()
		.ВОкружении("PREPARE_TEMP_BASE_PASSWORD PREPARE_TEMP_BASE_PWD");

	КомандаПриложения.Опция("temp-ib-connection", "", "путь подключения к  временной информационной базе")
		.ТСтрока()
		.ВОкружении("PREPARE_TEMP_BASE_CONNECTION PREPARE_TEMP_BASECONNECTION");
		
	КомандаПриложения.Аргумент("CONFIG", "", "путь к файлу настройки экспорта")
		.ТСтрока()
		.ВОкружении("PREPARE_BASE_CONFIG")
		.Обязательный(Ложь)
		.ПоУмолчанию(ОбъединитьПути(ТекущийКаталог(), ПараметрыПриложения.ИмяФайлаНастройкиПакетнойСинхронизации()));
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт

	ИнициализацияПроекта(КомандаПриложения);
	ЭкспортироватьХранилище();
	
КонецПроцедуры

Процедура ИнициализацияПроекта(КомандаПриложения)

	ПараметрыЭкспорта = ПараметрыПриложения.СтруктураПараметровПриложения();
	ПараметрыЭкспорта.Хранилище_Путь = КомандаПриложения.ЗначениеОпции("storage-path");
	ПараметрыЭкспорта.Хранилище_Пользователь = КомандаПриложения.ЗначениеОпции("storage-user");
	ПараметрыЭкспорта.Хранилище_Пароль = КомандаПриложения.ЗначениеОпции("storage-psw");
	
	БазаСинхронизации_СтрокаПодключения = КомандаПриложения.ЗначениеОпции("ib-connection");
	Если БазаСинхронизации_СтрокаПодключения <> "" Тогда
		Лог.Информация("Используем существующую ИБ для подключения к хранилищу");
		ПараметрыЭкспорта.БазаСинхронизации_СтрокаПодключения = БазаСинхронизации_СтрокаПодключения;
		ПараметрыЭкспорта.БазаСинхронизации_Пользователь = КомандаПриложения.ЗначениеОпции("ib-user"); 
		ПараметрыЭкспорта.БазаСинхронизации_Пароль = КомандаПриложения.ЗначениеОпции("ib-pwd"); 
	КонецЕсли;

	КаталогЭкспорта	= КомандаПриложения.ЗначениеОпции("projectPath");
	Если КаталогЭкспорта = "" Тогда
		Лог.Информация("Устанавливаем каталог экспорта по умолчанию");
		КаталогЭкспорта = ПараметрыПриложения.КаталогЭкспорта();
		Лог.Информация("Каталог экспорта по умолчанию: " + КаталогЭкспорта);
	КонецЕсли;

	КаталогВременныхФайлов = КомандаПриложения.ЗначениеОпции("temp-dir");
	Если КаталогВременныхФайлов = "" Тогда
		Лог.Информация("Устанавливаем каталог временных файлов по умолчанию");
		КаталогВременныхФайлов = ПараметрыПриложения.КаталогВременныхФайлов();
		Лог.Информация("Каталог временных файлов: " + КаталогВременныхФайлов);
	КонецЕсли;

	ПутьКФайлуAUTHORS = КомандаПриложения.ЗначениеОпции("authors-path");
	Если ПутьКФайлуAUTHORS = "" Тогда
		Лог.Информация("Используем файл AUTHORS по умолчанию");
		ПутьКФайлуAUTHORS = ОбъединитьПути(ТекущийКаталог(), "resources", "gitsync", "AUTHORS");
	КонецЕсли;

	ПараметрыЭкспорта.КаталогЭкспорта = КаталогЭкспорта;
	ПараметрыЭкспорта.КаталогВременныхФайлов = КаталогВременныхФайлов;
	ПараметрыЭкспорта.ПутьКФайлуAUTHORS = ПутьКФайлуAUTHORS;
	ПараметрыЭкспорта.ПроверятьАвторов = КомандаПриложения.ЗначениеОпции("check-authors");;

	ВременнаяБаза_СтрокаПодключения = КомандаПриложения.ЗначениеОпции("temp-ib-connection");
	Если ВременнаяБаза_СтрокаПодключения <> "" Тогда
		Лог.Информация("Используем существующую ИБ для разбора конфигурации поставщика");
		ПараметрыЭкспорта.ВременнаяБаза_СтрокаПодключения = ВременнаяБаза_СтрокаПодключения;
		ПараметрыЭкспорта.ВременнаяБаза_Пользователь = КомандаПриложения.ЗначениеОпции("temp-ib-user"); 
		ПараметрыЭкспорта.ВременнаяБаза_Пароль = КомандаПриложения.ЗначениеОпции("temp-ib-pwd"); 
	КонецЕсли;

КонецПроцедуры

Процедура ЭкспортироватьХранилище()
	
	МенеджерСинхронизации = Новый МенеджерСинхронизации(ПараметрыЭкспорта);
	МенеджерСинхронизации.ЭкспортироватьХранилище();

КонецПроцедуры

Лог = ПараметрыПриложения.Лог();