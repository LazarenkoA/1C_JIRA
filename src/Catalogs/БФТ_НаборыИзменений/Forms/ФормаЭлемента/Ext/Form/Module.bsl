﻿/////////////// Защита модуля ///////////////
// @protect                                //
/////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
  Перем НаборыИзменений;
  
	Если Параметры.Свойство("НаборыИзменений", НаборыИзменений) И НаборыИзменений <> Неопределено Тогда
	  Для Каждого Стр Из НаборыИзменений Цикл
	    НовСтр = Объект.НаборИзменений.Добавить();
	    НовСтр.НомерРевизии = Стр;
	  КонецЦикла;
	КонецЕсли;
  
  СписокИзменений.Параметры.УстановитьЗначениеПараметра("НаборИзменений", Объект.НаборИзменений.Выгрузить().ВыгрузитьКолонку("НомерРевизии")); // для отображения пока не сохранили объект
	СписокИзменений.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
  Если ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") Тогда
    Оповестить("СозданиеНовогоНабораИзменений", Объект.Ссылка, ЭтаФорма.ВладелецФормы);
  КонецЕсли;
КонецПроцедуры

#КонецОбласти
