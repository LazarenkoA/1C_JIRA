﻿/////////////// Защита модуля ///////////////
// @protect                                //
/////////////////////////////////////////////


#Область ОписаниеПеременных

&НаКлиенте
Перем ВсеЗаданияВыполнены, ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, "Обработка не работает в веб клиенте");
		Возврат;
	#КонецЕсли
	
	ОбновитьДоступностьПолей();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьКонфигурацию(Команда)
	СписокЭлементов = Новый Массив();
	Если Не ПроверитьЗаполнениеВГруппе(Элементы.грОбщая.Имя, СписокЭлементов) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = СтрШаблон("Поля ""%1"" обязательны к заполнению", СтрСоединить(СписокЭлементов, ","));
		Сообщение.Сообщить();
		Возврат;  
	КонецЕсли;
	
	Если ФормироватьРелизНот И (Не ЗначениеЗаполнено(Объект.URL_JIRA) ИЛИ 
		Не ЗначениеЗаполнено(Объект.ПользовательJIRA) ИЛИ 
		Не ЗначениеЗаполнено(Объект.ПарольJIRA)) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Заполните данные для авторизации в JIRA";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если ФормироватьРелизНот Тогда
		БФТ_ОбщиеМетодыАРМаСборокНаКлиенте.ЗагрузитьИзменения(ЭтаФорма, ПолучитьЕдинственнуюНастройкуПодключенияКРепозиторию());
		ВыполнитьРегЗаданиеПоОбновлениюИзменений1СНаСервере();
	КонецЕсли;
	
	НомераВыгружаемыхРевизий = ПолучитьНомераВыгружаемыхРевизий(Объект.НомерРевизии);
	
	Если ВсеЗаданияВыполнены = Ложь Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Процесс уже запущен";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	ВсеЗаданияВыполнены = Ложь;
	
	Задания.ПолучитьЭлементы().Очистить();
	Для Каждого НомерРевизии Из НомераВыгружаемыхРевизий Цикл
		СтрокаЛогаРодитель = Задания.ПолучитьЭлементы().Добавить();
		СтрокаЛогаРодитель.Комментарий = СтрШаблон("Выгрузка ревизии %1", Формат(НомерРевизии, "ЧГ="));
		СтрокаЛогаРодитель.АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
		СтрокаЛогаРодитель.Картинка = 0;
		
		ИнициализироватьШаги(СтрокаЛогаРодитель);
		
		СтрокаЛогаРодитель.ИдентификаторЗадания = ВыгрузитьНаСервере(НомерРевизии, СтрокаЛогаРодитель.АдресХранилища);
	КонецЦикла;
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИнициализироватьШаги(СтрокаЛогаРодитель)
	
	НовСтр = СтрокаЛогаРодитель.ПолучитьЭлементы().Добавить();
	НовСтр.Комментарий = "Создание временной файловой БД";
	НовСтр.Метод = "СоздатьВременнуюБД";
	НовСтр.Картинка = 0;
	
	НовСтр = СтрокаЛогаРодитель.ПолучитьЭлементы().Добавить();
	НовСтр.Комментарий = "Получить конфигурацию из хранилища";
	НовСтр.Метод = "ПолучитьКонфигурациюИзХранилища";
	НовСтр.ОбратныйМетод = "ПолучитьКонфигурациюИзВременногоХранилища";
	НовСтр.Картинка = 0;
	
	//НовСтр = НовСтр.ПолучитьЭлементы().Добавить();
	//НовСтр.Комментарий = "Защита конфигурации";
	//НовСтр.Картинка = 0;
	
	Если Объект.ВыгружатьФайлы Тогда
		//НовСтр = СтрокаЛогаРодитель.ПолучитьЭлементы().Добавить();
		//НовСтр.Комментарий = "Создание временного пользователя в хранилище";
		//НовСтр.Метод = "СозданиеВременногоПользователя";
		//НовСтр.Картинка = 0;
		
		НовСтр = СтрокаЛогаРодитель.ПолучитьЭлементы().Добавить();
		НовСтр.Комментарий = "Предварительное отделение конфигурации БФТ";
		НовСтр.Метод = "ОтделениеКонфигурацииБФТ";
		НовСтр.Картинка = 0;
		
		НовСтр = СтрокаЛогаРодитель.ПолучитьЭлементы().Добавить();
		НовСтр.Комментарий = "Выгрузка конфигурации в файлы";
		НовСтр.Метод = "ВыгрузитьКонфигурациюВФайлы";
		НовСтр.Картинка = 0;
		
		НовСтр = СтрокаЛогаРодитель.ПолучитьЭлементы().Добавить();
		НовСтр.Комментарий = "Окончательное отделение конфигурации БФТ";
		НовСтр.Метод = "ОтделитьПодсистемуБФТ";
		НовСтр.Картинка = 0;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЕдинственнуюНастройкуПодключенияКРепозиторию()
	Возврат Справочники.БФТ_НастройкаПодключенияКРепозиторию.ПолучитьЕдинственнуюНастройкуПодключенияКРепозиторию();	
КонецФункции

&НаСервереБезКонтекста
Процедура ВыполнитьРегЗаданиеПоОбновлениюИзменений1СНаСервере()
	// Общие рег. задания в области не видны.
	ТекСеансРазделен = ПараметрыСеанса.ОбластьДанныхИспользование;
	ПараметрыСеанса.ОбластьДанныхИспользование = Ложь;
	Попытка
		Задание = РегламентноеЗаданиеЗагрузкаЛога();
		Если Задание <> Неопределено Тогда
			РегламентныеЗаданияСлужебный.ВыполнитьРегламентноеЗаданиеВручную(Задание.УникальныйИдентификатор);
		КонецЕсли;
		
		ПараметрыСеанса.ОбластьДанныхИспользование = ТекСеансРазделен;
	Исключение
		ПараметрыСеанса.ОбластьДанныхИспользование = ТекСеансРазделен;
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РегламентноеЗаданиеЗагрузкаЛога()
	Перем Задание;
	
	// Общие рег. задания в области не видны.
	ТекСеансРазделен = ПараметрыСеанса.ОбластьДанныхИспользование;
	ПараметрыСеанса.ОбластьДанныхИспользование = Ложь;
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		
		Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(
		Новый Структура("Метаданные", "БФТ_АнализИзмененийХранилища1С"));
		
		Если Задания.Количество() > 0 Тогда
			Задание = Задания[0];
		КонецЕсли;
		
		ПараметрыСеанса.ОбластьДанныхИспользование = ТекСеансРазделен;
	Исключение
		ПараметрыСеанса.ОбластьДанныхИспользование = ТекСеансРазделен;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Задание;
КонецФункции

&НаСервере
Функция ВыгрузитьНаСервере(НомерРевизии, АдресХранилища)
	
	ФЗ = РеквизитФормыВЗначение("Объект").ВыгрузитьКонфигурациюВФайлы(НомерРевизии, ПутьКСохраняемойКонфигурации, АдресХранилища, Объект.ВыгружатьФайлы, ВыгружатьЗащищеннуюКонфигурацию, ПутьКОбфускатору);  
	Возврат ФЗ.УникальныйИдентификатор;
	
КонецФункции

&НаКлиенте
Функция ПолучитьНомераВыгружаемыхРевизий(НомерРевизии)
	Перем НомерРевизииЧислом;
	
	Ответ = Новый Массив();
	ПроверитьЗначениеНаСоответствие(НомерРевизии, НомерРевизииЧислом);
	
	Если НомерРевизииЧислом.Количество() = 2 Тогда
		Для а = НомерРевизииЧислом[0] По НомерРевизииЧислом[1] Цикл
			Ответ.Добавить(а);  
		КонецЦикла;
	Иначе
		Ответ = НомерРевизииЧислом;
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

&НаКлиенте
Процедура ПроверитьЗначениеНаСоответствие(НомерРевизии, НомерРевизииЧислом)
	НомерРевизииСтрокой = ?(ТипЗнч(НомерРевизии) = Тип("Число"), Формат(НомерРевизии, "ЧГ="), НомерРевизии);
	ТолькоЦифрыВСтроке = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерРевизииСтрокой, Ложь, Ложь);  
	РазбитоеЗначение = СтрРазделить(НомерРевизииСтрокой, "-", Ложь);
	НомерРевизииЧислом = Новый Массив();
	
	Если ((Не ТолькоЦифрыВСтроке И РазбитоеЗначение.Количество() <> 2) ИЛИ 
		(РазбитоеЗначение.Количество() = 2 И
		(Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(РазбитоеЗначение[0], Ложь, Ложь) ИЛИ 
		Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(РазбитоеЗначение[1], Ложь, Ложь)))) 
		И Не АктуальнаяВерсия Тогда
		ВызватьИсключение "Введено неверное значение в поле ""Номер ревизии""";
	КонецЕсли;
	
	Если РазбитоеЗначение.Количество() = 2 Тогда
		Начало = Число(РазбитоеЗначение[0]);
		Конец = Число(РазбитоеЗначение[1]);
		НомерРевизииЧислом.Добавить(Число(Начало));
		НомерРевизииЧислом.Добавить(Число(Конец));
		
		Если Начало >= Конец Тогда
			ВызватьИсключение "Введено неверное значение в поле ""Номер ревизии""
			|Начальный номер ревизии должен быть меньше чем конечный";
		КонецЕсли;
	Иначе
		НомерРевизииЧислом.Добавить(Число(НомерРевизииСтрокой));
	КонецЕсли;
КонецПроцедуры

#region ДлительныеОперации

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Для Каждого Задание Из Задания.ПолучитьЭлементы() Цикл
		Попытка
			ЗаданиеВыполнено = ЗаданиеВыполнено(Задание.ИдентификаторЗадания);
			ДанныеФЗ = БФТ_ДлительныеОперацииСервер.ПолучитьДанныеФЗ(Задание.ИдентификаторЗадания);
			
			Если ДанныеФЗ = Неопределено ИЛИ ТипЗнч(ДанныеФЗ) <> Тип("Массив") ИЛИ (ТипЗнч(ДанныеФЗ) = Тип("Массив") И ДанныеФЗ.Количество() = 0) Тогда
				ЭтаФорма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
				Продолжить;
			КонецЕсли;
			Если Не ЗаданиеВыполнено Тогда
				ЭтаФорма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
			КонецЕсли;
			
			ВсеВыполнено = Истина;
			Для Каждого ПодЗадание Из Задание.ПолучитьЭлементы() Цикл
				Для Каждого Данные Из ДанныеФЗ Цикл
					Если ПодЗадание.Метод = Данные.ТекущийШаг И Не ЗаданиеВыполнено Тогда
						ПодЗадание.Картинка = 1;
						Задание.Картинка = 1;
					КонецЕсли;
					Если Данные.ВыполненныеШаги.Найти(ПодЗадание.Метод) <> Неопределено Или ЗаданиеВыполнено Тогда
						ПодЗадание.Картинка = 2;
						
						// Получаем данные ФЗ.
						Если ЗначениеЗаполнено(ПодЗадание.ОбратныйМетод) Тогда
							Выполнить(СтрШаблон("%1(Задание.АдресХранилища, Задание.Комментарий)", ПодЗадание.ОбратныйМетод));  
						КонецЕсли;
						
					КонецЕсли;
				КонецЦикла;
				
				Если ПодЗадание.Картинка = 1 Тогда
					ВсеВыполнено = Ложь;
				КонецЕсли;
			КонецЦикла;
			
			ВсеЗаданияВыполнены = ВсеВыполнено;
			Если ВсеВыполнено Тогда
				Задание.Картинка = 2;
			КонецЕсли;
		Исключение
			Задание.Картинка = 3;
			Задание.ТекстОшибки = "Ошибка:
			|" + ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеРегламентногоЗадания()
	Если РегламентноеЗаданияЗапущено("БФТ_АнализИзмененийХранилища1С") Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеРегламентногоЗадания", 1, Истина);
	Иначе
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ЗапуститьФормированиеРелизНот();
	КонецЕсли;
КонецПроцедуры

#endregion

#region callback

&НаКлиенте
Процедура ПолучитьКонфигурациюИзВременногоХранилища(АдресХранилища, Комментарий)
	Если Не ПолучитьФайл(АдресХранилища, СтрШаблон("%1.cf", Комментарий), Истина) Тогда
		Возврат;	
	КонецЕсли;
	
	Если ФормироватьРелизНот Тогда
		Состояние("Формируем Release note");
		СформироватьРелизНот();
	КонецЕсли;
КонецПроцедуры

#endregion

&НаСервере
Функция ПроверитьЗаполнениеВГруппе(ИмяГруппыРодителя, СписокЭлементов)
	Группа = Элементы.Найти(ИмяГруппыРодителя);
	Если Группа = Неопределено Тогда
		Возврат Истина;  
	КонецЕсли;
	
	Для Каждого Элем Из Группа.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(Элем) = Тип("ПолеФормы") И
			Элем.Вид = ВидПоляФормы.ПолеВвода И
			Элем.АвтоОтметкаНезаполненного = Истина И
			Не ЗначениеЗаполнено(Вычислить(Элем.ПутьКДанным))
			И Элем.Видимость Тогда
			
			Имя = ?(ЗначениеЗаполнено(Элем.Заголовок), Элем.Заголовок, Элем.Имя);
			СписокЭлементов.Добавить(Имя); 
		ИначеЕсли ТипЗнч(Элем) = Тип("ГруппаФормы") Тогда
			ПроверитьЗаполнениеВГруппе(Элем.Имя, СписокЭлементов);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокЭлементов.Количество() = 0;
КонецФункции

&НаКлиенте
Процедура ОбработкаРезультатаВопроса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПрерватьВыполнениеФоновыхЗаданий(); 
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрерватьВыполнениеФоновыхЗаданий()
	Строки = РеквизитФормыВЗначение("Задания").Строки.НайтиСтроки(Новый Структура("Картинка", 1));
	Для Каждого Стр Из Строки Цикл
		Стр.Картинка = 0;
		ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Стр.ИдентификаторЗадания);  
		Если ФЗ <> Неопределено Тогда
			ФЗ.Отменить();  
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НомерРевизииПриИзменении(Элемент)
	Объект.НомерРевизии = СокрЛП(Объект.НомерРевизии);
КонецПроцедуры


&НаКлиенте
Процедура ЗаданияПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.Задания.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ТекстОшибки) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = ТекущиеДанные.ТекстОшибки;
		Сообщение.Сообщить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПутьКСохраняемойКонфигурацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПутьКонфигурации = ЗапроситьПутьСохраняемойКонфигурации();
	Если ЗначениеЗаполнено(ПутьКонфигурации) Тогда
		ПутьКСохраняемойКонфигурации = ПутьКонфигурации;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ЗапроситьПутьСохраняемойКонфигурации()
	Диалог           = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог сохранения файлов конфигурации";
	Если Диалог.Выбрать() Тогда
		Возврат Диалог.Каталог;
	КонецЕсли;  
КонецФункции

&НаКлиенте
Процедура АктуальнаяВерсияПриИзменении(Элемент)
	Если АктуальнаяВерсия Тогда
		Объект.НомерРевизии = "-1";
		НаДату = ТекущаяДата();
		Элементы.НомерРевизии.Доступность = Ложь;
	Иначе
		Объект.НомерРевизии = "";
		Элементы.НомерРевизии.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыгружатьФайлыПриИзменении(Элемент)
	ОбновитьДоступностьПолей();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьПолей()
	Элементы.ПутьКСохраняемойКонфигурации.ТолькоПросмотр = Не Объект.ВыгружатьФайлы;	
	Элементы.ПутьКСохраняемойКонфигурации.АвтоОтметкаНезаполненного = Не Элементы.ПутьКСохраняемойКонфигурации.ТолькоПросмотр;
	Элементы.ПутьКОбфускатору.АвтоОтметкаНезаполненного = ВыгружатьЗащищеннуюКонфигурацию;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьРелизНот()
	Если РегламентноеЗаданияЗапущено("БФТ_АнализИзмененийХранилища1С") Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеРегламентногоЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, Неопределено);
		ФормаДлительнойОперации.Заголовок = "Дождитесь окончания загрузки истории хранилища в базу";
		ФормаДлительнойОперации.Элементы.ДекорацияДлительнаяОперация.Картинка = БиблиотекаКартинок.ДлительныеОперации_Пес;
	Иначе
		ЗапуститьФормированиеРелизНот();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФормированиеРелизНот()
	Объект.Cookie = "";
	СписокЗадач = ПолучитьСписокЗадач();
	МассивЗадач = СтрРазделить(СписокЗадач, ",", Ложь);
	ПолучитьРелизНот(МассивЗадач);
	
	УстановитьОтметкуОВыгрузке();
КонецПроцедуры

#region РаботаС_HTTP

&НаКлиенте
Процедура АвторизацияВЖире()
	#Если Не ВебКлиент Тогда
	// В веб клиенте не поддерживается ПереносСтрокJSON.

	СтруктураТела = Новый Структура("username, password", Объект.ПользовательJIRA, Объект.ПарольJIRA);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, " ", Истина);  
	ЗаписьJSON.УстановитьСтроку(ПараметрыJSON);
	ЗаписатьJSON(ЗаписьJSON, СтруктураТела);           
	ДанныеДляАвторизации = ЗаписьJSON.Закрыть();
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Объект.URL_JIRA);
	
	Прокси = Новый ИнтернетПрокси(Истина);
	ssl = Новый ЗащищенноеСоединениеOpenSSL(
	Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Авто),
	Новый СертификатыУдостоверяющихЦентровWindows());
	
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост,,,,,, ssl);
	HTTPЗапрос = Новый HTTPЗапрос("rest/auth/1/session", ПолучитьЗаголовки());       
	HTTPЗапрос.УстановитьТелоИзСтроки(ДанныеДляАвторизации, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	ФайлОтвет = ПолучитьИмяВременногоФайла();
	Ответ = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос, ФайлОтвет);
	Если Ответ.КодСостояния = 200 Тогда 
		Объект.Cookie = Ответ.Заголовки["Set-Cookie"];
	Иначе
		ВызватьИсключение СтрШаблон("Ошибка авторизации в жире, код состояния %1", Ответ.КодСостояния);
	КонецЕсли;
	
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗаголовки()
	Заголовки = Новый Соответствие();
	//Заголовки.Вставить("Connection", "keep-alive");
	//Заголовки.Вставить("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
	Заголовки.Вставить("Content-type", "application/json;charset=utf-8");
	//Заголовки.Вставить("Accept", "application/json, text/javascript, */*; q=0.01");
	//Заголовки.Вставить("Accept-Language", "Accept-Encoding	gzip, deflate");
	//Заголовки.Вставить("X-Requested-With", "XMLHttpRequest");
	//Заголовки.Вставить("Content-Length", "59");
	
	Возврат Заголовки;
КонецФункции

&НаКлиенте
Функция ВыполнитьGETЗапрос(URL)
	Перем ssl;
	
	html = "";

	#Если Не ВебКлиент Тогда
		
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	Если Не ЗначениеЗаполнено(Объект.Cookie) Тогда
		АвторизацияВЖире();
	КонецЕсли;
	
	Заголовки = ПолучитьЗаголовки();
	Заголовки.Вставить("Cookie", Объект.Cookie);
	
	Если ВРег(СтруктураURI.Схема) = "HTTPS" Тогда
		ssl = Новый ЗащищенноеСоединениеOpenSSL(
		Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Авто),
		Новый СертификатыУдостоверяющихЦентровWindows());
	КонецЕсли;
	
	ФайлОтвет = ПолучитьИмяВременногоФайла();
	Попытка
		HTTPСоединение = Новый HTTPСоединение(СтруктураURI.ИмяСервера,,,,,, ssl);
		HTTPЗапрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере, Заголовки);
		Ответ = HTTPСоединение.Получить(HTTPЗапрос, ФайлОтвет);  
		
		Если Ответ.КодСостояния = 200 Тогда 
			HTMLФайл = Новый ТекстовыйДокумент();
			HTMLФайл.Прочитать(ФайлОтвет, КодировкаТекста.UTF8);
			html = HTMLФайл.ПолучитьТекст(); 
		ИначеЕсли Ответ.КодСостояния = 400 Тогда 
			HTMLФайл = Новый ТекстовыйДокумент();
			HTMLФайл.Прочитать(ФайлОтвет, КодировкаТекста.UTF8);
			html = HTMLФайл.ПолучитьТекст(); 
		Иначе
			ВызватьИсключение СтрШаблон("Ошибка выполнения GET запроса, код состояния %1", Ответ.КодСостояния);
		КонецЕсли;
		
		УдалитьФайлы(ФайлОтвет);
	Исключение
		УдалитьФайлы(ФайлОтвет);
		ВызватьИсключение;
	КонецПопытки;
	
	#КонецЕсли
	
	Возврат html;
КонецФункции

#endregion

&НаКлиенте
Процедура ПолучитьРелизНот(МассивЗадачИсходный)
	
	#Если Не ВебКлиент Тогда

	// Разработчик может в комментарии написать подзадачу, а не основную задачу,
	// поэтому нам нужно выяснить какие задачи являются подзадачами и получить по ним основные.
	МассивПодзадач = ОтделитьПодзадачи(МассивЗадачИсходный);
	
	// Из основного списка удаляем подзадачи.
	ИсхМассивСтрокой = СтрСоединить(МассивЗадачИсходный, ",");
	МассивПодзадачСтрокой = СтрСоединить(МассивПодзадач, ",");
	МассивЗадачИсходныйСтрокой = СтрЗаменить(ИсхМассивСтрокой, МассивПодзадачСтрокой, "");
	
	// Теперь добавляем основные задачи по подзадачам.
	РодительскиеЗадачи = ПолучитьРодительскиеЗадачи(МассивПодзадач);
	РодительскиеЗадачиСтрокой = СтрСоединить(РодительскиеЗадачи, ",");
	МассивЗадачИсходный = СтрРазделить(МассивЗадачИсходныйСтрокой + "," + РодительскиеЗадачиСтрокой , ",", Ложь);
	
	РазбитыйМассивЗадач = ОбщегоНазначенияКлиентСервер.РазбитьМассив(МассивЗадачИсходный, 10);
	Для Каждого МассивЗадач Из РазбитыйМассивЗадач Цикл
		// https://jira.bftcom.com
		ЗадачиСтрокой = СтрСоединить(МассивЗадач, ",");
		URL = СтрШаблон("%1/rest/api/2/search?jql=key in(%2)", Объект.URL_JIRA, ЗадачиСтрокой);
		Результат = ВыполнитьGETЗапрос(URL);	
		Если Не ЗначениеЗаполнено(Результат) Тогда
			Продолжить;	
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Результат);
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);
		ЧтениеJSON.Закрыть();
		
		Ошибки = ОтветОбъект["errorMessages"];
		Если Ошибки <> Неопределено Тогда
			РелизНот = РелизНот + СтрШаблон("Ошибка получения Release note задач ""%1"": 
			|%2%3
			|
			|", ЗадачиСтрокой, Символы.Таб, СтрСоединить(Ошибки, Символы.ПС));
			Продолжить;
		КонецЕсли;
		
		Задачи = ОтветОбъект["issues"];
		Если Задачи = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		Описание = "";
		Для Каждого Задача Из Задачи Цикл
			СвойствоЗадачи = Задача["fields"];
			// На данном этапе не должно быть подзадач, тут только основные задачи.
			
			//Если СвойствоЗадачи["parent"] <> Неопределено Тогда
			//	ОсновнаяЗадача = СвойствоЗадачи["parent"];
			//	СвойствоЗадачи = ОсновнаяЗадача["fields"];
			//Иначе
			//	ОсновнаяЗадача = Задача;	
			//КонецЕсли;
			
			Подзадачи = СвойствоЗадачи["subtasks"];
			СостояниеЗадачи = ПроверитьСостояниеПодзадач(Подзадачи);
			Если СвойствоЗадачи = Неопределено Тогда
				Описание = Описание + СтрШаблон("(%1) ""Ошибка получения свойств задачи""", Задача["key"]);
				Продолжить;
			КонецЕсли;
			
			ReleaseNote = СвойствоЗадачи["customfield_12913"];
			РелизНот = РелизНот + СтрШаблон("[%1] ""%2"" - (%3)
			|%4 Release note: ""%5""
			|
			|", Задача["key"], СвойствоЗадачи["summary"], СостояниеЗадачи, Символы.Таб, ?(ЗначениеЗаполнено(ReleaseNote), ReleaseNote, "Не задан"));
		КонецЦикла;
		
	КонецЦикла;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Функция ПроверитьСостояниеПодзадач(Подзадачи)
	ЗакрытаРазработка = Ложь;
	ЗакрытоТестирование = Ложь;
	Для Каждого Задача Из Подзадачи Цикл
		СвойствоЗадачи = Задача["fields"];
		Если СвойствоЗадачи = Неопределено Тогда                                  
			Продолжить;
		КонецЕсли;
		
		// ID-10108 = Разработка (Дефект).
		// ID-10 = Разработка
		// ID-10107 = Тестирование (Дефект)
		// ID-11 = Тестирование (Доработка)
		// HTTPS://jira.bftcom.com/rest/api/2/issuetype/.
		Тип = СвойствоЗадачи["issuetype"];
		ТипРазработка = (Тип["id"] = "10108" Или Тип["id"] = "10"); 
		ТипТестирование = (Тип["id"] = "10107" Или Тип["id"] = "11"); 
		
		// HTTPS://jira.bftcom.com/rest/api/2/status/.
		СтатусЗакрыт = СвойствоЗадачи["status"]["id"] = "6"; // ID-6 значит закрыт.
		
		Если Не ЗакрытаРазработка Тогда
			ЗакрытаРазработка =  ТипРазработка И СтатусЗакрыт;
		КонецЕсли;
		Если Не ЗакрытоТестирование Тогда
			ЗакрытоТестирование = ТипТестирование И СтатусЗакрыт;
		КонецЕсли;
	КонецЦикла;
	
	Ответ = "";
	Если ЗакрытаРазработка И Не ЗакрытоТестирование Тогда
		Ответ = "Задача реализована, но не протестирована";		
	ИначеЕсли ЗакрытоТестирование Тогда
		Ответ = "Задача протестирована";	
	ИначеЕсли Не ЗакрытаРазработка Тогда
		Ответ = "Задача выложена частично";	
	КонецЕсли;
	
	Возврат Ответ;
КонецФункции

&НаКлиенте
Функция ОтделитьПодзадачи(МассивЗадачИсходный)
	Результат = Новый Массив();
	
	#Если Не ВебКлиент Тогда

	РазбитыйМассивЗадач = ОбщегоНазначенияКлиентСервер.РазбитьМассив(МассивЗадачИсходный, 10);
	Для Каждого МассивЗадач Из РазбитыйМассивЗадач Цикл
		ЗадачиСтрокой = СтрСоединить(МассивЗадач, ",");
		URL = СтрШаблон("%1/rest/api/2/search?jql=key in(%2) and issuetype in subTaskIssueTypes()", Объект.URL_JIRA, ЗадачиСтрокой);
		HTML = ВыполнитьGETЗапрос(URL);	
		Если Не ЗначениеЗаполнено(HTML) Тогда
			Продолжить;	
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(HTML);
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);
		ЧтениеJSON.Закрыть();
		
		Задачи = ОтветОбъект["issues"];
		Если Задачи = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		Для Каждого Задача Из Задачи Цикл
			Результат.Добавить(Задача["key"]);
		КонецЦикла;
	КонецЦикла;
	#КонецЕсли 

	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ПолучитьРодительскиеЗадачи(МассивЗадачИсходный)
	Результат = Новый Массив();
	
	#Если Не ВебКлиент Тогда
	РазбитыйМассивЗадач = ОбщегоНазначенияКлиентСервер.РазбитьМассив(МассивЗадачИсходный, 10);
	Для Каждого МассивЗадач Из РазбитыйМассивЗадач Цикл
		ЗадачиСтрокой = СтрСоединить(МассивЗадач, ",");
		URL = СтрШаблон("%1/rest/api/2/search?jql=issueFunction in parentsOf(""key in(%2)"")", Объект.URL_JIRA, ЗадачиСтрокой);
		HTML = ВыполнитьGETЗапрос(URL);	
		Если Не ЗначениеЗаполнено(HTML) Тогда
			Продолжить;	
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(HTML);
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);
		ЧтениеJSON.Закрыть();
		
		Задачи = ОтветОбъект["issues"];
		Если Задачи = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		Для Каждого Задача Из Задачи Цикл
			Результат.Добавить(Задача["key"]);
		КонецЦикла;
	КонецЦикла;
	#КонецЕсли 

	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция РегламентноеЗаданияЗапущено(ИмяРегЗадания)
	Возврат ОбработкаРегламентныхЗаданий.РегламентноеЗаданияЗапущено(ИмяРегЗадания);	
КонецФункции

&НаСервере
Функция ПолучитьСписокЗадач()
	ЗадачиJIRA = Новый Массив();
	
	ДатаНачала = ТекущаяДатаСеанса();
	ДатаОкончания = ОбщегоНазначенияКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Выборка = ПолучитьСписокРевизий1С();
	Пока Выборка.Следующий() Цикл
		ДатаНачала = Мин(ДатаНачала, Выборка.ДатаИзменений);
		ДатаОкончания = Макс(ДатаОкончания, Выборка.ДатаИзменений);
		
		ЗадачиРевизии = БФТ_ОбщиеМетодыАРМаСборокНаСервере.РазборКомментария(Выборка.Комментарий);
		ЗадачиJIRA = ОбщегоНазначенияКлиентСервер.СлитьМассивы(ЗадачиJIRA, ЗадачиРевизии);
	КонецЦикла;
	
	ЗадачиJIRA = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ЗадачиJIRA);
	
	// Получаем задачи по шаблонам.
	Если Не ЗначениеЗаполнено(НаДату) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "В Release note не попадут задачи по шаблонам, заполните поле ""На дату""";
		Сообщение.Сообщить();
		Возврат ЗадачиJIRA;
	КонецЕсли;
	
	Выборка = ПолучитьСписокРевизийSVN(ДатаНачала, ДатаОкончания);
	Пока Выборка.Следующий() Цикл
		Если ЗадачиJIRA.Найти(Выборка.Задача) = Неопределено Тогда
			ЗадачиJIRA.Добавить(Выборка.Задача);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(ЗадачиJIRA, ",");
КонецФункции

&НаСервере
Функция ПолучитьСписокРевизийSVN(ДатаНачала, ДатаОкончания)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БФТ_НаборыИзмененийНаборИзменений.Ссылка.Код КАК Задача
	|ИЗ
	|	РегистрСведений.БФТ_ИзмененияРепозитория КАК БФТ_ИзмененияРепозитория
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БФТ_НаборыИзменений.НаборИзменений КАК БФТ_НаборыИзмененийНаборИзменений
	|		ПО БФТ_ИзмененияРепозитория.НомерРевизии = БФТ_НаборыИзмененийНаборИзменений.НомерРевизии
	|ГДЕ
	|	БФТ_ИзмененияРепозитория.Период МЕЖДУ &ДатаНачала И &ДатаОкончания";
	
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаОкончания));
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

&НаСервере
Процедура УстановитьОтметкуОВыгрузке()
	Выборка = ПолучитьСписокРевизий1С();
	Пока Выборка.Следующий() Цикл
		Набор = РегистрыСведений.БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.СоздатьНаборЗаписей();
		Набор.Отбор.НомерРевизии.Установить(Выборка.НомерРевизии);
		Набор.Отбор.ДатаИзменений.Установить(Выборка.ДатаИзменений);
		Набор.Отбор.Статус.Установить(Выборка.Статус);
		Набор.Прочитать();
		
		// Т.к. читаем по всем измерениям, запись должна быть одна.
		Набор[0].РевизияВыгружена = Истина;
		Набор.Записать();
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокРевизий1С()
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.Статус,
	|	БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.ДатаИзменений,
	|	БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.НомерРевизии,
	|	БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.Комментарий
	|ИЗ
	|	РегистрСведений.БФТ_ОчередьВыгрузкиРевизийКонфигурации1С КАК БФТ_ОчередьВыгрузкиРевизийКонфигурации1С
	|ГДЕ
	|	(&ВыгружатьАктуальнуюВерсию
	|			ИЛИ БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.НомерРевизии <= &НомерРевизии)
	|	И НЕ БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.РевизияВыгружена";
	
	Запрос.УстановитьПараметр("НомерРевизии", Объект.НомерРевизии);
	Запрос.УстановитьПараметр("ВыгружатьАктуальнуюВерсию", АктуальнаяВерсия);
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

&НаКлиенте
Процедура НаДатуПриИзменении(Элемент)
	Объект.НомерРевизии = ПолучитьРевизиюНаДату(НаДату);
	Если Не ЗначениеЗаполнено(Объект.НомерРевизии) Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект), СтрШаблон("На дату %1 не удалось определить ревизию
		|Загрузить изменения?", Формат(НаДату, "ДФ=dd.MM.yyyy")), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да, "Не найдена ревизия");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		БФТ_ОбщиеМетодыАРМаСборокНаСервере.АнализИзмененийХранилища1С();
		
		Объект.НомерРевизии = ПолучитьРевизиюНаДату(НаДату);
		Если Не ЗначениеЗаполнено(Объект.НомерРевизии) Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Увы, не получилось :(";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьРевизиюНаДату(ДатаИзменений)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.НомерРевизии КАК НомерРевизии
	|ИЗ
	|	РегистрСведений.БФТ_ОчередьВыгрузкиРевизийКонфигурации1С КАК БФТ_ОчередьВыгрузкиРевизийКонфигурации1С
	|ГДЕ
	|	БФТ_ОчередьВыгрузкиРевизийКонфигурации1С.ДатаИзменений = &ДатаИзменений
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерРевизии УБЫВ";
	
	Запрос.УстановитьПараметр("ДатаИзменений", ДатаИзменений);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.НомерРевизии;
	Иначе
		Возврат 0;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ВыгружатьЗащищеннуюКонфигурациюПриИзменении(Элемент)
	ОбновитьДоступностьПолей();
КонецПроцедуры

#КонецОбласти