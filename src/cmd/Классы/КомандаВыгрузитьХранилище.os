#Использовать fs
#Использовать logos

Перем Лог;
Перем ПараметрыЭкспорта;

Процедура ПриСозданииОбъекта()
	

КонецПроцедуры

Процедура ОписаниеКоманды(КомандаПриложения) Экспорт
	
КомандаПриложения.Опция("p projectPath", "", "Путь к каталогу для экспорта")
	.ТСтрока()
	.ВОкружении("PREPARE_BASE_PROJECT_PATH");;

КомандаПриложения.Опция("s storage-path", "", "Путь к хранилищу конфигурации")
	.ТСтрока()
	.ВОкружении("PREPARE_BASE_STORAGE_PATH");
	
КомандаПриложения.Опция("u storage-user", "", "Пользователь хранилища конфигурации")
	.ТСтрока()
	.ВОкружении("PREPARE_BASE_USER");

КомандаПриложения.Опция("p storage-pwd", "", "Пароль пользователя хранилища конфигурации")
	.ТСтрока()
	.ВОкружении("PREPARE_BASE_PASSWORD PREPARE_BASE_PWD");

КомандаПриложения.Опция("t tempDir", "", "Каталог с времменными файлами")
	.ТСтрока()
	.ВОкружении("PREPARE_BASE_TEMP_DIR");

КомандаПриложения.Опция("d domenName", "", "Доменное имя для новых пользователей GIT")
	.ТСтрока()
	.ВОкружении("PREPARE_BASE_DOMAIN_NAME");

КомандаПриложения.Опция("a autorsPath", "", "Путь к файлу AUTHORS")
	.ТСтрока()
	.ВОкружении("PREPARE_BASE_AUTHORS_PATH");

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
	ПараметрыЭкспорта.ПутьХранилища = КомандаПриложения.ЗначениеОпции("storage-path");
	ПараметрыЭкспорта.ПользовательХранилища = КомандаПриложения.ЗначениеОпции("storage-user");
	ПараметрыЭкспорта.ПарольПользователяХранилища = КомандаПриложения.ЗначениеОпции("storage-pwd");
	
	КаталогЭкспорта	= КомандаПриложения.ЗначениеОпции("projectPath");
	Если КаталогЭкспорта = "" Тогда
		Лог.Информация("Устанавливаем каталог экспорта по умолчанию");
		КаталогЭкспорта = ОбъединитьПути(ТекущийКаталог(), ПараметрыПриложения.КаталогЭкспорта());
		ФС.ОбеспечитьПустойКаталог(КаталогЭкспорта);
	КонецЕсли;

	КаталогВременныхФайлов = КомандаПриложения.ЗначениеОпции("tempDir");
	Если КаталогЭкспорта = "" Тогда
		Лог.Информация("Устанавливаем каталог временных файлов по умолчанию");
		КаталогВременныхФайлов = ОбъединитьПути(ТекущийКаталог(), ПараметрыПриложения.КаталогВременныхФайлов());
		ФС.ОбеспечитьПустойКаталог(КаталогВременныхФайлов);
	КонецЕсли;


	ПутьКФайлуAUTHORS = КомандаПриложения.ЗначениеОпции("autorsPath");
	Если ПутьКФайлуAUTHORS = "" Тогда
		Лог.Информация("Используем файл AUTHORS по умолчанию");
		ПутьКФайлуAUTHORS = ОбъединитьПути(ТекущийКаталог(), "resources", "gitsync", "AUTHORS");
	КонецЕсли;

	ПараметрыЭкспорта.КаталогЭкспорта = КаталогЭкспорта;
	ПараметрыЭкспорта.КаталогВременныхФайлов = КаталогВременныхФайлов;
	ПараметрыЭкспорта.ПутьКФайлуAUTHORS = ПутьКФайлуAUTHORS;
	
КонецПроцедуры

Процедура ЭкспортироватьХранилище()
	
	МенеджерСинхронизации = Новый МенеджерСинхронизации(ПараметрыЭкспорта);
	МенеджерСинхронизации.ЭкспортироватьХранилище();

КонецПроцедуры

Лог = ПараметрыПриложения.Лог();