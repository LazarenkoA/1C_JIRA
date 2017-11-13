﻿
Процедура ПолучениеЗадач() Экспорт
	Если РегламентноеЗаданияЗапущено("ПолучениеЗадач") Тогда
		Возврат;  
	КонецЕсли;
	
	РегистрыСведений.Задачи.ОбновитьЗадачи();
КонецПроцедуры

Функция РегламентноеЗаданияЗапущено(ИмяРегламентногоЗадания) Экспорт 
	МетаДанныеЗагрузки = Метаданные.РегламентныеЗадания.Найти(ИмяРегламентногоЗадания);
	РеглЗадание = РегламентныеЗадания.НайтиПредопределенное(МетаДанныеЗагрузки);
	
	Если РеглЗадание <> Неопределено Тогда
		Отбор = Новый Структура("РегламентноеЗадание, Состояние");
		Отбор.РегламентноеЗадание = РеглЗадание;
		Отбор.Состояние = СостояниеФоновогоЗадания.Активно;
		ИсполняющиеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
		
		// Если есть активные фоновые задания - выходим (аля singleton).
		Возврат ИсполняющиеФоновыеЗадания.Количество() > 1;
	КонецЕсли;  
	
	Возврат Ложь;
КонецФункции

Процедура ОповещениеПоЗадачам() Экспорт
	#Область ПривышенияВремениРаботыНадЗадачей
	Попытка
		ЗадачиДерево = Справочники.ШаблоныУведомлений.ПолучитьЗадачиСрокВыполненияКоторыхБольшеЗапланированого();
		
		Для Каждого Стр Из ЗадачиДерево.Строки Цикл
			Если ЗначениеЗаполнено(Стр.Исполнитель) И Стр.Строки.Количество() > 0 Тогда
				УведомленияСервер.Уведомить(Стр.Исполнитель, Справочники.ШаблоныУведомлений.ПривышенияВремениРаботыНадЗадачей, Стр.Строки);
			КонецЕсли;
		КонецЦикла;
		
	Исключение
	КонецПопытки;
	
	#КонецОбласти
	
	#Область СписаноВремениБольшеЧемЗатрачено
	//Попытка
	//	ЗадачиДерево = Справочники.ШаблоныУведомлений.СписаноВремениБольшеЧемЗатрачено();
	//	
	//	Для Каждого Стр Из ЗадачиДерево.Строки Цикл
	//		Если ЗначениеЗаполнено(Стр.Исполнитель) И Стр.Строки.Количество() > 0 Тогда
	//			УведомленияСервер.Уведомить(Стр.Исполнитель, Справочники.ШаблоныУведомлений.СписаноВремениБольшеЧемЗатрачено, Стр.Строки);
	//		КонецЕсли;
	//	КонецЦикла;
	//	
	//Исключение
	//КонецПопытки;
	
	#КонецОбласти
	
	#Область СрокРешениеПоЗадачеИстек
	Попытка
		ЗадачиДерево = Справочники.ШаблоныУведомлений.СрокРешениеПоЗадачеИстек();
		
		Для Каждого Стр Из ЗадачиДерево.Строки Цикл
			Если ЗначениеЗаполнено(Стр.Автор) И Стр.Строки.Количество() > 0 Тогда
				УведомленияСервер.Уведомить(Стр.Автор, Справочники.ШаблоныУведомлений.СрокРешениеПоЗадачеИстек, Стр.Строки);
			КонецЕсли;
		КонецЦикла;
		
	Исключение
	КонецПопытки;
	#КонецОбласти

КонецПроцедуры


// Выполнение регламентных заданий.
//
// Параметры:
//  ИмяЗадания  - Строка - имя регламентного задания;
//  Параметры  - Произвольный - параметры версии.
//
Процедура ВыполнитьРегЗаданиеНаСервере(ИмяЗадания, Параметры = Неопределено) Экспорт 
	Задание = ПолучитьРегламентноеЗадание(ИмяЗадания);
	Если Задание <> Неопределено Тогда
		ВыполнитьРегламентноеЗаданиеВручную(Задание, Параметры);
	КонецЕсли;
КонецПроцедуры

// Функция - Выполнить регламентное задание вручную.
// Копия типовой функции из модуля РегламентныеЗаданияСлужебный, в типовом методе нельзя было передать параметры.
// Параметры:
//  Задание  - Строка - имя регламентного задания;
//  Параметры  - Произвольный - параметры версии.
//
// Возвращаемое значение:
//  Структура - параметры выполнения регламентного задания.
//
Функция ВыполнитьРегламентноеЗаданиеВручную(Знач Задание, Параметры) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыВыполнения = ПараметрыВыполненияРегламентногоЗадания();
	ПараметрыВыполнения.ПроцедураУжеВыполняется = Ложь;
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Задание);
	
	Если Параметры <> Неопределено Тогда
		Задание.Параметры.Добавить(Параметры);
	КонецЕсли;
	
	ПараметрыВыполнения.ЗапускВыполнен = Ложь;
	СвойстваПоследнегоФоновогоЗадания = РегламентныеЗаданияСлужебный.ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);
	
	Если СвойстваПоследнегоФоновогоЗадания <> Неопределено
		И СвойстваПоследнегоФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		ПараметрыВыполнения.МоментЗапуска  = СвойстваПоследнегоФоновогоЗадания.Начало;
		Если ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.Наименование) Тогда
			ПараметрыВыполнения.ПредставлениеФоновогоЗадания = СвойстваПоследнегоФоновогоЗадания.Наименование;
		Иначе
			ПараметрыВыполнения.ПредставлениеФоновогоЗадания = РегламентныеЗаданияСлужебный.ПредставлениеРегламентногоЗадания(Задание);
		КонецЕсли;
	Иначе
		НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1'"), РегламентныеЗаданияСлужебный.ПредставлениеРегламентногоЗадания(Задание));
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(Задание.Метаданные.ИмяМетода, Задание.Параметры, Строка(Задание.УникальныйИдентификатор), НаименованиеФоновогоЗадания);
		ПараметрыВыполнения.ИдентификаторФоновогоЗадания = Строка(ФоновоеЗадание.УникальныйИдентификатор);
		ПараметрыВыполнения.МоментЗапуска = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗадание.УникальныйИдентификатор).Начало;
		ПараметрыВыполнения.ЗапускВыполнен = Истина;
	КонецЕсли;
	
	ПараметрыВыполнения.ПроцедураУжеВыполняется = НЕ ПараметрыВыполнения.ЗапускВыполнен;
	Возврат ПараметрыВыполнения;
	
КонецФункции

Функция ПараметрыВыполненияРегламентногоЗадания() 
	
	Результат = Новый Структура;
	Результат.Вставить("МоментЗапуска");
	Результат.Вставить("ИдентификаторФоновогоЗадания");
	Результат.Вставить("ПредставлениеФоновогоЗадания");
	Результат.Вставить("ПроцедураУжеВыполняется");
	Результат.Вставить("ЗапускВыполнен");
	Возврат Результат;
	
КонецФункции

// Выполнение регламентных заданий.
//
// Параметры:
//  ИмяЗадания  - Строка - имя регламентного задания.
//
// Возвращаемое значение:
//  РегламентноеЗадание - возвращает найденное регламентное задание.
//
Функция ПолучитьРегламентноеЗадание(ИмяЗадания) Экспорт 
	УстановитьПривилегированныйРежим(Истина);
	
	Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", ИмяЗадания));
	Если Задания.Количество() > 0 Тогда
		Возврат Задания[0];
	КонецЕсли;
КонецФункции

Процедура ПолучениеСписаниеВремени() Экспорт
	Если РегламентноеЗаданияЗапущено("ПолучениеСписаниеВремени") Тогда
		Возврат;  
	КонецЕсли;

	РегистрыСведений.СписаниеВремени.ОбновитьЗаписи();	
КонецПроцедуры

Процедура ПолучениеИсторииИзменениеСтатусов() Экспорт
	Если РегламентноеЗаданияЗапущено("ПолучениеИсторииИзменениеСтатусов") Тогда
		Возврат;  
	КонецЕсли;

	РегистрыСведений.Задачи.ОбновитьЗадачи();	// Это нужно, что бы не получилось так, что по истории задача закрыта, а по факту нет
	РегистрыСведений.ИсторияИзмененияСтатусов.ОбновитьЗаписи();
КонецПроцедуры

Процедура ЧисткаУдаленныхЗадач() Экспорт
	Если РегламентноеЗаданияЗапущено("ЧисткаУдаленныхЗадач") Тогда
		Возврат;  
	КонецЕсли;

	РегистрыСведений.Задачи.ЧисткаУдаленныхЗадач();	
КонецПроцедуры

