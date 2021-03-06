﻿Функция НайтиСоздатьТип(ДанныеТипа) Экспорт 
	Если ДанныеТипа = Неопределено Тогда
		Возврат Справочники.ТипыЗадач.ПустаяСсылка();	
	КонецЕсли;
	
	ТипыЗадачи =  Справочники.ТипыЗадач.НайтиПоКоду(Число(ДанныеТипа["id"]));
	Если ЗначениеЗаполнено(ТипыЗадачи) Тогда
		Возврат ТипыЗадачи;	
	КонецЕсли;
	
	ТипыЗадачи = Справочники.ТипыЗадач.СоздатьЭлемент();
	ТипыЗадачи.Наименование = ДанныеТипа["name"];
	ТипыЗадачи.Код = Число(ДанныеТипа["id"]);
	ТипыЗадачи.Записать();
	
	Возврат ТипыЗадачи.Ссылка;
КонецФункции
