// MIT License
// Copyright (c) 2020 Silverbulleters LLC
// All rights reserved.

#Использовать fs
#Использовать gitrunner
#Использовать asserts
#Использовать logos

Перем Лог;
Перем ПараметрыОбновления;
Перем МенеджерСинхронизации;

Процедура ОписаниеКоманды(КомандаПриложения) Экспорт
	
	КомандаПриложения.Опция("e project-path", "", "Путь к репозитарию с результатами слияния")
		.ТСтрока()
		.Обязательный(Ложь)
		.ВОкружении("RECTOR_PROJECT_PATH");

	КомандаПриложения.Опция("b src-base", "", "Путь к репозитарию базовой конфигурации")
		.ТСтрока()
		.Обязательный(Ложь)
		.ВОкружении("RECTOR_SRC_BASE");

	КомандаПриложения.Опция("bb src-base-branch", "", "Имя ветки в git-репозитарии базовой конфигурации")
		.ТСтрока()
		.Обязательный(Ложь)
		.ВОкружении("RECTOR_SRC_BASE_BRANCH");

	КомандаПриложения.Опция("bc src-base-commit", "", "Хэш начального коммита в git-репозитарии базовой конфигурации")
		.ТСтрока()
		.Обязательный(Ложь)
		.ВОкружении("RECTOR_SRC_BASE_COMMIT");

	КомандаПриложения.Опция("d src-develop", "", "Путь к исходникам конфигурации")
		.ТСтрока()
		.Обязательный(Истина)
		.ВОкружении("RECTOR_SRC_DEVELOP");

	КомандаПриложения.Опция("db src-develop-branch", "", "Имя ветки в git-репозитарии конфигурации")
		.ТСтрока()
		.Обязательный(Ложь)
		.ВОкружении("RECTOR_SRC_DEVELOP_BRANCH");

	КомандаПриложения.Опция("dc src-develop-commit", "", "Хэш начального коммита в git-репозитарии конфигурации")
		.ТСтрока()
		.Обязательный(Ложь)
		.ВОкружении("RECTOR_SRC_DEVELOP_COMMIT");

	КомандаПриложения.Опция("t temp-dir", "", "Каталог с временными файлами")
		.ТСтрока()
		.Обязательный(Ложь)
		.ВОкружении("RECTOR_TEMP_DIR");

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт

	Лог.Предупреждение("Команда не реализована!");

КонецПроцедуры // ВыполнитьКоманду()

Лог = ПараметрыПриложения.Лог();
