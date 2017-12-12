﻿/////////////// Защита модуля ///////////////
// @protect                                //
/////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция выполнения метода
//
// Параметры:
//  НастройкаСсылка  - ЛюбаяСсылка - ссылка настройки;
//  ИмяКоманды  - Строка - имя команды;
//  ВнешниеПараметры  - Неопределено - внешние параметры.
//
// Возвращаемое значение:
//   Произвольный   - что-то.
//
Функция ВыполнитьМетод(НастройкаСсылка, ИмяКоманды, Знач ВнешниеПараметры = Неопределено) Экспорт 
	Перем Файл, Метод, Команда, ВремФайл, ЧтениеТекста;
	
	Метод = БФТ_ОбщиеМетодыАРМаСборокНаСервере.ПолучитьМетод(НастройкаСсылка, ИмяКоманды);
	Если Не ЗначениеЗаполнено(Метод) Тогда
		ВызватьИсключение СтрШаблон("Метод ""%1"" не найден", ИмяКоманды);  
	КонецЕсли;
	
	Команда = БФТ_ОбщиеМетодыАРМаСборокНаСервере.СформироватьКомандуВыполнения(Метод, ВнешниеПараметры);
	
	// Используется Wscript.Shell т.к. КомандаСистемы недоступен на сервере.
	// А ЗапуститьПриложение не умеет получпть результат (вывод результата выполнения комменды в файл ">").
	Попытка
		WshShell = Новый COMОбъект("Wscript.Shell");
		// КодВозврата = 0;
		// ЗапуститьПриложение(СтрШаблон("START /wait %1 > D:\1C_Log\1.txt", Команда),, Истина, КодВозврата);
		// ЗапуститьПриложение(СтрШаблон("cmd /C ""%1"" > D:\1C_Log\1.txt", Команда),, Истина, КодВозврата);
		// Result = WshShell.Run(СтрШаблон("cmd /C ""%1"" > D:\1C_Log\1.txt", Команда),.
		// 0, Истина); СтрШаблон("%1 > D:\1C_Log\1.txt", Команда).
		Result = WshShell.Exec(Команда);
	Исключение
		ВызватьИсключение СтрШаблон("Произошла ошибка при выполнении метода ""%1""
		|Команда:
		|%2
		|Ошибка:
		|%3", ИмяКоманды, Команда, ОписаниеОшибки());
	КонецПопытки;
	
	// Str = "";
	// Пока Не Result.StdOut.AtEndOfStream Цикл.
	//	Str = Str + СтрШаблон(Result.StdOut.ReadLine());
	// КонецЦикла;
	
	Возврат Result.StdOut.ReadAll();
КонецФункции

// Функция возвращает пароль доступа к SVN.
//
// Возвращаемое значение:
//   Строка   - пароль.
//
Функция ПарольДоступаК_SVN() Экспорт 
	Возврат "CitadelClose";
КонецФункции

#КонецОбласти
 