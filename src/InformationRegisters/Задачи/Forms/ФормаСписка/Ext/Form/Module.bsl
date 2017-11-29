﻿
&НаСервереБезКонтекста
Процедура ПолучитьЗадачиНаСервере(Часы)
	РегистрыСведений.Задачи.ОбновитьЗадачи(, Часы);	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьЗадачиНаСервере(Строки)
	Номера = Новый Массив();
	Для Каждого Стр Из Строки Цикл
		Номера.Добавить(Стр.Номер);	
	КонецЦикла;
	РегистрыСведений.Задачи.ОбновитьЗадачи(Номера);
КонецПроцедуры


&НаКлиенте
Процедура ПолучитьЗадачи(Команда)
	ПолучитьЗадачиНаСервере(Часы);
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьВыделенные(Команда)
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	ОбновитьЗадачиНаСервере(ВыделенныеСтроки);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьИсториюПереходовНаСервере(Строки)
	Номера = Новый Массив();
	Для Каждого Стр Из Строки Цикл
		Номера.Добавить(Стр.Номер);	
	КонецЦикла;
	РегистрыСведений.ИсторияИзмененияСтатусов.ОбновитьЗаписи(Номера);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьИсториюСписанийНаСервере(Строки)
	Номера = Новый Массив();
	Для Каждого Стр Из Строки Цикл
		Номера.Добавить(Стр.Номер);	
	КонецЦикла;
	РегистрыСведений.СписаниеВремени.ОбновитьЗаписи(Номера);
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьИсториюПереходов(Команда)
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	ОбновитьИсториюПереходовНаСервере(ВыделенныеСтроки);
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьИсториюСписаний(Команда)
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	ОбновитьИсториюСписанийНаСервере(ВыделенныеСтроки);
КонецПроцедуры



