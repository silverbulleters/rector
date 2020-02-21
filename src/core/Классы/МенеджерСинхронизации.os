#Использовать fs
#Использовать gitrunner
#Использовать v8runner
#Использовать v8storage
#Использовать asserts

Перем ТаблицаВерсийХранилища;
Перем ПараметрыЭкспорта;
Перем ТаблицаАвторов;
Перем ЛогЯдра;
Перем ГитРепозиторий;
Перем ХранилищеКонфигурации;
Перем ИмяКонфигурацииПоставщика;
Перем КонфигураторВременнойБазы;
Перем ЭтоПоследнийКоммит;

Процедура ПриСозданииОбъекта(_ПараметрыЭкспорта)
	
	ПараметрыЭкспорта = _ПараметрыЭкспорта;
	
КонецПроцедуры

Процедура ЭкспортироватьХранилище() Экспорт
	ЗаполнитьТаблицуВерсий();
	ЗаполнитьТаблицуАвторов();
	ИнициализироватьGITРепозитарий();

	Для каждого ВерсияХранилища Из ТаблицаВерсийХранилища Цикл
		Если ВерсияХранилища.Номер < ПараметрыЭкспорта.НачальныйНомерКоммита Тогда
			ИнициализироватьGitsync(ВерсияХранилища.Дата);
		КонецЕсли;
		
		ЭтоПоследнийКоммит = ВерсияХранилища.Номер = ТаблицаВерсийХранилища.Количество();

		Если ВерсияХранилища.Номер = 2 Тогда
			ИнициализироватьGitsync(ВерсияХранилища.Дата);
		КонецЕсли;
		// Дополним коментарий номером коммита хранилища
		//
		Если ВерсияХранилища.Комментарий = "" Тогда
			ЛогЯдра.Предупреждение("Коментарий хранилища не установлен!");
			ВерсияХранилища.Комментарий = "Изменение от " + ВерсияХранилища.Дата;
		КонецЕсли;
		
		ВерсияХранилища.Комментарий = СтрШаблон("%1 (1cst-version:%2)", ВерсияХранилища.Комментарий, ВерсияХранилища.Номер);

		ЛогЯдра.Информация("Ищем соответствие автору: " + ВерсияХранилища.Автор);
		ПользовательGit = ТаблицаАвторов.Найти(ВерсияХранилища.Автор, "Автор");
		Если ПользовательGit = Неопределено Тогда
			ПользовательGit = Новый Структура();
			ЛогЯдра.Информация("Автор "+ ВерсияХранилища.Автор + "не найден в файле AUTHORS!");

			Если ПараметрыЭкспорта.ПроверятьАвторов Тогда
				ВызватьИсключение("Ошибка экспорта репозитария!");
			КонецЕсли;

			ПользовательGit.Вставить("ИмяПользователяGit", ВерсияХранилища.Автор);
			ПользовательGit.Вставить("ПочтаПользователяGit",
					 ВерсияХранилища.Автор + "@" + ПараметрыСистемы.ДоменноеИмяПоУмолчанию());
		КонецЕсли;
		ЛогЯдра.Информация("Для автора: " + ВерсияХранилища.Автор + " установленны значения: ");
		ЛогЯдра.Информация("Автор коммита GIT: " + ПользовательGit.ИмяПользователяGit);
		ЛогЯдра.Информация("Почта автора коммита:" + ПользовательGit.ПочтаПользователяGit);
		
		ЛогЯдра.Информация("Получаю " + ВерсияХранилища.Номер + " версию хранилища");
		ПолучитьВерсиюХранилища(ВерсияХранилища); 
		ОпределитьИмяКонфигурацииПоставщика();

		Если НЕ УжеВыгружалась() ИЛИ
			 НЕ ФайлыРавны(НоваяКонфигурацияПоставщика(), СтараяКонфигурацияПоставщика()) Тогда
			ЛогЯдра.Информация("Выгружаю конфигурацию поставщика");
			ВыгрузитьОбновлениеКонфигурацииПоставщика(ВерсияХранилища, ПользовательGit);
		Иначе
			ЛогЯдра.Информация("Выгружаю конфигурацию разработки");
			ВыгрузитьКонфигураациюРазработчика(ВерсияХранилища, ПользовательGit);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры 

Процедура ВыгрузитьОбновлениеКонфигурацииПоставщика(ВерсияХранилища, ПользовательGit)
	// Создаем и переходим в ветку base1C
	ЛогЯдра.Информация("Получаю список веток");
	КолекцияВетокРепозитария = ГитРепозиторий.ПолучитьСписокВеток();
	Если КолекцияВетокРепозитария.Найти("base1c", "Имя") = Неопределено Тогда
		ЛогЯдра.Информация("Ветка base1C не существует - создаем и переходим");
		ГитРепозиторий.ПерейтиВВетку("base1c", Истина);
	Иначе
		ЛогЯдра.Информация("Ветка base1C существует - переходим");
		ГитРепозиторий.ПерейтиВВетку("base1c", , Истина);
	КонецЕсли;
	
	// выружаем конфигурацию поставщика
	КаталогИсходниковЭкспорта = ПутьКЭкспортируемымИсходнымФайлам();

	ЗагрузитьВыгрузитьКонфигурацию(НоваяКонфигурацияПоставщика(), КаталогИсходниковЭкспорта);

	ФайлВерсии = ОбъединитьПути(КаталогИсходниковЭкспорта, "Configuration.xml");
	СохранитьИзмененияGit("Обновление конфигурации на версию поставщика: " + ПолучитьВерсиюКонфигурации(ФайлВерсии),
					 ПараметрыСистемы.Имя1С(),
					 ПараметрыСистемы.ПочтовыйЯщик1С(),
					 ВерсияХранилища.Дата);
	
	ГитРепозиторий.ПерейтиВВетку("master", , Истина);
	ПараметрыКоманды = Новый Массив();
	ПараметрыКоманды.Добавить("merge");
	ПараметрыКоманды.Добавить("base1c");
	ПараметрыКоманды.Добавить("-Xtheirs");
	ПараметрыКоманды.Добавить("--no-commit");
	ЛогЯдра.Информация("Мержим изменения из base1C");
	ГитРепозиторий.ВыполнитьКоманду(ПараметрыКоманды);
	ВыгрузитьКонфигураациюРазработчика(ВерсияХранилища, ПользовательGit);

КонецПроцедуры

Процедура ЗагрузитьВыгрузитьКонфигурацию(ИмяФайлаКонфигурации, ЦелевойКаталог)
	Если КонфигураторВременнойБазы = Неопределено Тогда
		ИнициализироватьВременнуюБазу();
	КонецЕсли;
	ЛогЯдра.Информация("Загружаю конфигурацию поставщика во временную ИБ");
	КонфигураторВременнойБазы.ЗагрузитьКонфигурациюИзФайла(ИмяФайлаКонфигурации);
	ЛогЯдра.Информация("Выгружаю исходники конфигурации поставщика");
	КонфигураторВременнойБазы.ВыгрузитьКонфигурациюВФайлы(ЦелевойКаталог);
КонецПроцедуры

Процедура ВыгрузитьКонфигураациюРазработчика(ВерсияХранилища, ПользовательGit)
	ЛогЯдра.Информация("Выгружаем конфигурацию разработчика");
	ФС.КопироватьСодержимоеКаталога(ПутьКВременнымИсходнымФайлам(), ПутьКЭкспортируемымИсходнымФайлам());
	Если ЭтоПоследнийКоммит Тогда
		ОбновитьФайлVERSION(ВерсияХранилища.Номер);
	КонецЕсли;
	СохранитьИзмененияGit(ВерсияХранилища.Комментарий, 
				ПользовательGit.ИмяПользователяGit, 
				ПользовательGit.ПочтаПользователяGit,
				ВерсияХранилища.Дата);
КонецПроцедуры

Процедура ОбновитьФайлVERSION(НомерТекущегоКоммита)
	ПутьКФайлуВерсии = ОбъединитьПути(ПутьКЭкспортируемымИсходнымФайлам(), "VERSION");

	ТекстовыйФайл = Новый ЧтениеТекста(ПутьКФайлуВерсии, "utf-8");
	ТекстФайла = ТекстовыйФайл.Прочитать();
	ТекстовыйФайл.Закрыть();

	НовыйТекст = СтрЗаменить(ТекстФайла, "<VERSION>0</VERSION>", "<VERSION>" + НомерТекущегоКоммита +"</VERSION>");

	ЗаписьТекста = Новый ЗаписьТекста(ПутьКФайлуВерсии);
	ЗаписьТекста.Записать(НовыйТекст);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Функция УжеВыгружалась()
	Возврат ФС.ФайлСуществует(СтараяКонфигурацияПоставщика());
КонецФункции

Функция НоваяКонфигурацияПоставщика()
	Возврат ОбъединитьПути(ПараметрыЭкспорта.КаталогВременныхФайлов, 
			ПутьИсходныФайлов(), 
			ПутьКонфигурацииПоставщика(), 
			ИмяКонфигурацииПоставщика);
КонецФункции

Функция ПолучитьВерсиюКонфигурации(ФайлВерсии)

	Файл = Новый ЧтениеТекста(ФайлВерсии);
	ФайлСтрокой = Файл.Прочитать();
	Файл.Закрыть();

	РВ = Новый РегулярноеВыражение("<Version>(.*)<\/Version>");

	Совпадения = РВ.НайтиСовпадения(ФайлСтрокой);
	Если Совпадения.Количество() > 0 И Совпадения[0].Группы.Количество() > 1 Тогда
		Возврат Совпадения[0].Группы[1].Значение; 
	КонецЕсли;

	Возврат "0";

КонецФункции

Функция СтараяКонфигурацияПоставщика()
	Возврат ОбъединитьПути(ПараметрыЭкспорта.КаталогЭкспорта, 
					ПутьИсходныФайлов(), 
					ПутьКонфигурацииПоставщика(), 
					ИмяКонфигурацииПоставщика);
КонецФункции

// Вычиcлсяет значение хеш-суммы (контрольной суммы) для указанного файлов по алгоритму SHA-1.
//
// Параметры:
//  <ПутьКФайлу>  - Строка - Путь к файлу, сумму котрого необходимо вычислить
//
// Возвращаемое значение:
//   Строка   - Контрольная сумма файла
//
Функция ПолучитьСуммуФайлаSHA1(ПутьКФайлу) Экспорт

	Если НЕ ФС.ФайлСуществует(ПутьКФайлу) Тогда
		ВызватьИсключение "Выбран каталог или файла " + ПутьКФайлу +" не существует";
	КонецЕсли;

	Команда = Новый Команда;
	СистемнаяИнформация = Новый СистемнаяИнформация;
    ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
    Если ЭтоWindows Тогда
		Команда.УстановитьКоманду("certutil");
		Команда.ДобавитьПараметр("-hashfile");
		Команда.ДобавитьПараметр(ПутьКФайлу);
		Команда.Исполнить();
		Ответ = Команда.ПолучитьВывод();
		Результат =  СокрЛП(СтрПолучитьСтроку(СтрЗаменить(Ответ, " ", ""), 2));
	Иначе
		Команда.УстановитьКоманду("sha1sum");
		Команда.ДобавитьПараметр(ПутьКФайлу);
		Команда.Исполнить();
		Результат =  СтрРазделить(Команда.ПолучитьВывод(), " ")[0];
	КонецЕсли;
	Сообщить(Результат);
	Возврат Результат;
КонецФункции

// Сравнивает хеш-суммы 2-х переданных файлов
//
// Параметры:
//  <ПервыйФайл>  - Строка - Путь к первому файлу.
//
//  <ПервыйФайл>  - Строка - Путь ко второму файлу.
//
// Возвращаемое значение:
//   Булево   - Результат сравнения
//
Функция ФайлыРавны(ПервыйФайл , ВторойФайл) Экспорт
	Результат =  ПолучитьСуммуФайлаSHA1(ПервыйФайл) = ПолучитьСуммуФайлаSHA1(ВторойФайл);
	ЛогЯдра.Информация("Сравниваемые файлы " + ?(Результат, " равны." , " не равны"));
	Возврат Результат;
КонецФункции

Процедура ПолучитьВерсиюХранилища(ВерсияХранилища)
	ИмяФайлаКонфигурации =  ОбъединитьПути(ПараметрыЭкспорта.КаталогВременныхФайлов, "export.cf");
	ХранилищеКонфигурации.СохранитьВерсиюКонфигурацииВФайл(ВерсияХранилища.Номер, ИмяФайлаКонфигурации);
	ЗагрузитьВыгрузитьКонфигурацию(ИмяФайлаКонфигурации, ПутьКВременнымИсходнымФайлам());
КонецПроцедуры

Процедура ИнициализироватьВременнуюБазу()
	КонфигураторВременнойБазы = Новый УправлениеКонфигуратором();
	КонфигураторВременнойБазы.УстановитьКонтекст(ПараметрыЭкспорта.ВременнаяБаза_СтрокаПодключения,
	                                             ПараметрыЭкспорта.ВременнаяБаза_Пользователь,
												 ПараметрыЭкспорта.ВременнаяБаза_Пароль);
КонецПроцедуры

Процедура ИнициализироватьGITРепозитарий()
	ГитРепозиторий = Новый ГитРепозиторий();
	ГитРепозиторий.УстановитьРабочийКаталог(ПараметрыЭкспорта.КаталогЭкспорта);
	ГитРепозиторий.Инициализировать();
	ФС.КопироватьСодержимоеКаталога(ОбъединитьПути(ТекущийКаталог(), "resources", "repo"),
									 ПараметрыЭкспорта.КаталогЭкспорта);
	УстановитьНастройкиКоммитера(ГитРепозиторий);
	ГитРепозиторий.УстановитьНастройку("core.quotePath", "true", РежимУстановкиНастроекGit.Локально);
	СохранитьИзмененияGit("Инициализация репозитария",
							ПараметрыСистемы.ИмяКоммитераПоУмолчанию(),
							ПараметрыСистемы.ПочтаКоммитераПоУмолчанию(),
							ПараметрыСистемы.ДатаИнициализацииРепозитория());

	ЛогЯдра.Информация("Инициализирован репозитарий GIT: " + ПараметрыЭкспорта.КаталогЭкспорта);
КонецПроцедуры

Процедура ИнициализироватьGitsync(ДатаКоммита)
	ФС.КопироватьСодержимоеКаталога(ОбъединитьПути(ТекущийКаталог(), "resources", "gitsync"), 
									ПараметрыЭкспорта.КаталогЭкспорта);
	СохранитьИзмененияGit("Инициализация Gitsync",
							ПараметрыСистемы.ИмяКоммитераПоУмолчанию(),
							ПараметрыСистемы.ПочтаКоммитераПоУмолчанию(),
							ДатаКоммита);

КонецПроцедуры

Процедура УстановитьНастройкиКоммитера(ГитРепозиторий, ИмяКоммитера = "", ПочтаКоммитера = "" )
	
	Если ИмяКоммитера = "" Тогда
		ИмяКоммитера = ПараметрыСистемы.ИмяКоммитераПоУмолчанию();
	КонецЕсли;

	Если ПочтаКоммитера = "" Тогда
		ПочтаКоммитера = ПараметрыСистемы.ПочтаКоммитераПоУмолчанию();
	КонецЕсли;
	
	ГитРепозиторий.УстановитьНастройку("user.name", ИмяКоммитера);
	ГитРепозиторий.УстановитьНастройку("user.email", ПочтаКоммитера);
КонецПроцедуры

Процедура СохранитьИзмененияGit(Комментарий, ИмяКоммитера, ПочтаКоммитера, ДатаКоммита="")
	ЛогЯдра.Информация("Дата комита устанавливается на: " + ДатаКоммита);
	Если ДатаКоммита = "" Тогда
		ДатаКоммита = ТекущаяДата();
	КонецЕсли;

	ДатаДляГит = ДатаPOSIX(ДатаКоммита);
	ЛогЯдра.Информация("Добавляем изменения в индекс Git");

	ГитРепозиторий.ДобавитьФайлВИндекс(".");
	ГитРепозиторий.УстановитьНастройку("user.name", ИмяКоммитера);
	ГитРепозиторий.УстановитьНастройку("user.email", ПочтаКоммитера);
	ПредставлениеАвтора = ИмяКоммитера + " <" + ПочтаКоммитера + ">";
	ЛогЯдра.Информация("Добавляем изменения в Git");
	ГитРепозиторий.Закоммитить(Комментарий, Истина, , ПредставлениеАвтора, ДатаДляГит, , ДатаДляГит);
КонецПроцедуры

Процедура ЗаполнитьТаблицуВерсий()
	Если ТаблицаВерсийХранилища = Неопределено Тогда
		КонфигураторБазыСинхронизации = Неопределено;
		Если ЗначениеЗаполнено(ПараметрыЭкспорта.БазаСинхронизации_СтрокаПодключения) Тогда
			КонфигураторБазыСинхронизации = Новый УправлениеКонфигуратором();
			КонфигураторБазыСинхронизации.УстановитьКонтекст(ПараметрыЭкспорта.БазаСинхронизации_СтрокаПодключения,
															 ПараметрыЭкспорта.БазаСинхронизации_Пользователь,
															 ПараметрыЭкспорта.БазаСинхронизации_Пароль);
			КонфигураторБазыСинхронизации.УстановитьКодЯзыка("RU");
		КонецЕсли;
		ХранилищеКонфигурации = Новый МенеджерХранилищаКонфигурации(ПараметрыЭкспорта.Хранилище_Путь,
																	КонфигураторБазыСинхронизации);
		
		Если ЗначениеЗаполнено(ПараметрыЭкспорта.Хранилище_Пользователь) Тогда
			ХранилищеКонфигурации.УстановитьПараметрыАвторизации(ПараметрыЭкспорта.Хранилище_Пользователь, ПараметрыЭкспорта.Хранилище_Пароль);
		КонецЕсли;
		ЛогЯдра.Информация("Выгружаю таблицу авторов хранилища конфигурации");
		ТаблицаВерсийХранилища = ХранилищеКонфигурации.ПолучитьТаблицуВерсий();
	КонецЕсли;
	ЛогЯдра.Информация("В хранилище найдено " + ТаблицаВерсийХранилища + " версий");
КонецПроцедуры

// Получает таблицу авторов из файла
//
// Параметры:
//   ПутьКФайлуАвторов - Строка - путь к файлу авторов
//
Процедура ЗаполнитьТаблицуАвторов() Экспорт
	
	СтандартнаяОбработка = Истина;

	ТаблицаАвторов = НоваяТаблицаАвторов();

	Если СтандартнаяОбработка Тогда
		ПрочитатьФайлАвторов(ПараметрыЭкспорта.ПутьКФайлуAUTHORS, ТаблицаАвторов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрочитатьФайлАвторов(ПутьКФайлуАвторов, ТаблицаАвторов)
	
	Если НЕ ЗначениеЗаполнено(ПутьКФайлуАвторов) Тогда
		Возврат;
	КонецЕсли;

	Файл = Новый Файл(ПутьКФайлуАвторов);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли;

	ТекстовыйФайл = Новый ЧтениеТекста(ПутьКФайлуАвторов, "utf-8");
	ТекстФайла = ТекстовыйФайл.Прочитать();
	
	МассивСтрокФайла = СтрРазделить(ТекстФайла, Символы.ПС, Ложь);

	Для каждого СтрокаФайла Из МассивСтрокФайла Цикл

		Если СтрНачинаетсяС(СокрЛП(СтрокаФайла), "//") Тогда
			Продолжить;
		КонецЕсли;

		МассивКлючей =  СтрРазделить(СтрокаФайла, "=", Ложь);

		НоваяСтрока = ТаблицаАвторов.Добавить();
		НоваяСтрока.Автор = СокрЛП(МассивКлючей[0]);
		ПредставлениеАвтора = СокрЛП(МассивКлючей[1]);
		
		НоваяСтрока.ИмяПользователяGit = СтрРазделить(ПредставлениеАвтора,"<")[0];
		НоваяСтрока.ПочтаПользователяGit = СтрЗаменить(СтрРазделить(ПредставлениеАвтора, "<")[1], ">", "");
	КонецЦикла;

	ТекстовыйФайл.Закрыть();

	Если ТекстовыйФайл <> Неопределено Тогда
		ОсвободитьОбъект(ТекстовыйФайл);
	КонецЕсли;

КонецПроцедуры

Функция НоваяТаблицаАвторов()
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Автор");
	Таблица.Колонки.Добавить("ИмяПользователяGit");
	Таблица.Колонки.Добавить("ПочтаПользователяGit");
	
	Возврат Таблица;
	
КонецФункции

Функция ДатаPOSIX(Знач Дата)
	
	Возврат "" + Год(Дата) + "-" + ФорматДвузначноеЧисло(Месяц(Дата)) + "-" + ФорматДвузначноеЧисло(День(Дата)) + " "
	+ ФорматДвузначноеЧисло(Час(Дата)) + ":" + ФорматДвузначноеЧисло(Минута(Дата))
	+ ":" + ФорматДвузначноеЧисло(Секунда(Дата));
	
КонецФункции

Функция ФорматДвузначноеЧисло(ЗначениеЧисло)
	ЧислоСтрокой = Строка(ЗначениеЧисло);
	Если СтрДлина(ЧислоСтрокой) < 2 Тогда
		ЧислоСтрокой = "0" + ЧислоСтрокой;
	КонецЕсли;
	
	Возврат ЧислоСтрокой;
КонецФункции

Функция ОпределитьИмяКонфигурацииПоставщика()
	КаталогСКОнфигурациейПоставщика = ОбъединитьПути(ПараметрыЭкспорта.КаталогВременныхФайлов, ПутьИсходныФайлов(), ПутьКонфигурацииПоставщика());
	Сообщить(КаталогСКОнфигурациейПоставщика);
	НайденныеФайлы = НайтиФайлы(КаталогСКОнфигурациейПоставщика, "*.cf");
	Ожидаем.Что(НайденныеФайлы.Количество()).Равно(1);
	ИмяКонфигурацииПоставщика = НайденныеФайлы[0].Имя;
	ЛогЯдра.Информация("Найдена конфигурация поставщика: " + ИмяКонфигурацииПоставщика);
КонецФункции

Функция ПутьКонфигурацииПоставщика()
	Возврат ОбъединитьПути("Ext", "ParentConfigurations");
КонецФункции

Функция ПутьКВременнымИсходнымФайлам()
	Возврат ОбъединитьПути(ПараметрыЭкспорта.КаталогВременныхФайлов, ПутьИсходныФайлов());
КонецФункции

Функция ПутьКЭкспортируемымИсходнымФайлам()
	Возврат ОбъединитьПути(ПараметрыЭкспорта.КаталогЭкспорта, ПутьИсходныФайлов());
КонецФункции

Функция ПутьИсходныФайлов() Экспорт
	Возврат ОбъединитьПути("src", "cf");
КонецФункции

ЛогЯдра = ПараметрыСистемы.Лог();
