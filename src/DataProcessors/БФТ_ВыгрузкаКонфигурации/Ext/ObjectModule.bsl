﻿/////////////// Защита модуля ///////////////
// @protect                                //
/////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Выгрузить конфигурацию в файлы.
//
// Параметры:
//  НомерРевизии					 - Строка - Номер ревизии.
//  КаталогСохраненияФайлов			 - Строка - Каталог сохранения файлов.
//  АдресХранилищаРезультата		 - УникальныйИдентификатор - адрес временного хранилища с результатом.
//  ВыгружатьФайлы					 - Булево - Выгружать файлы.
//  ВыгружатьЗащищеннуюКонфигурацию	 - Булево - Выгружать защищенную конфигурацию.
//  ПутьКОбфускатору				 - Строка - Путь к обфускатору.
// 
// Возвращаемое значение:
//  ФоновоеЗадание - фоновое задание.
//
Функция ВыгрузитьКонфигурациюВФайлы(НомерРевизии, КаталогСохраненияФайлов, АдресХранилищаРезультата = Неопределено, ВыгружатьФайлы = Истина, ВыгружатьЗащищеннуюКонфигурацию, ПутьКОбфускатору) Экспорт
	Парам = Новый Массив();  
	Парам.Добавить(АдресХранилищаРезультата); 
	Парам.Добавить(НомерРевизии); 
	Парам.Добавить(ЭтотОбъект.ПутьКХранилищу); 
	Парам.Добавить(ЭтотОбъект.ПользовательХранилища); 
	Парам.Добавить(ЭтотОбъект.ВременныйПользовательХранилища); 
	Парам.Добавить(ЭтотОбъект.ПарольХранилища); 
	Парам.Добавить(СохранитьНастройкиОбъединенияКонфигурации()); 
	Парам.Добавить(КаталогСохраненияФайлов); 
	Парам.Добавить(ВыгружатьФайлы);
	Парам.Добавить(ВыгружатьЗащищеннуюКонфигурацию);
	Парам.Добавить(ПутьКОбфускатору);
		
	ФЗ = ФоновыеЗадания.Выполнить("БФТ_ДлительныеОперацииСервер.ВыполнитьПроцессПереноса", Парам,, СтрШаблон("Выгрузка ревизии ""%1""", Формат(НомерРевизии, "ЧГ=")));
	Возврат ФЗ;
КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Функция СохранитьНастройкиОбъединенияКонфигурации()
  Тело = ЭтотОбъект.ПолучитьМакет("НастройкиОбъединенияКонфигурации").ПолучитьТекст();
  
  ФайлНастроек = ПолучитьИмяВременногоФайла("xml");
  ЗаписьТекста = Новый ЗаписьТекста(ФайлНастроек, КодировкаТекста.UTF8);
  ЗаписьТекста.Записать(Тело);
  ЗаписьТекста.Закрыть();
  
  Возврат ФайлНастроек;
КонецФункции

#КонецОбласти

