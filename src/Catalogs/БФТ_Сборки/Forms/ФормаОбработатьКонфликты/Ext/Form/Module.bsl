﻿/////////////// Защита модуля ///////////////
// @protect                                //
/////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
  Если ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") Тогда
    Элементы.ПутьКЛокальнойДиректории.Заголовок = СтрШаблон("Локальный путь к сборке №%1", ЭтаФорма.ВладелецФормы.Объект.Наименование);
    ЭтаФорма.ВладелецФормы.Объект.Свойство("ЛокальныйПутьКСборке", ПутьКЛокальнойДиректории);
    НайтиКонфликтующиеФайлы();
  КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредПросмотрКонфликтаПриИзменении(Элемент)
  Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКонфликтующиеФайлы

&НаКлиенте
Процедура КонфликтующиеФайлыПриАктивизацииСтроки(Элемент)
  РазборВыбранногоФайла();
КонецПроцедуры

&НаКлиенте
Процедура КонфликтующиеФайлыПолныйПутьКФайлуОткрытие(Элемент, СтандартнаяОбработка)
  СтандартнаяОбработка = Ложь;
  ТекДанные = Элементы.КонфликтующиеФайлы.ТекущиеДанные;
  Если ТекДанные = Неопределено Тогда
    Возврат;  
  КонецЕсли;

  ЗапуститьПриложение(ТекДанные.ПолныйПутьКФайлу,, Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКонфликтыФайла

&НаКлиенте
Процедура КонфликтыФайлаПриАктивизацииСтроки(Элемент)
  ТекДанные = Элементы.КонфликтыФайла.ТекущиеДанные;
  Если ТекДанные = Неопределено Тогда
    Возврат;  
  КонецЕсли;
  
  ПредварительныйПросмотрКонфликта = ТекДанные.ТекстКонфликта;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
  Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КонфликтыОбработаны(Команда)
  Если Модифицированность Тогда
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Сохраните изменения файла");
    Возврат;
  КонецЕсли;
  
  Если Не СуществуютКонфликты() Тогда
    Если ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") Тогда
      ЭтаФорма.ВладелецФормы.ВыполнитьМетод("resolve", Ложь);
    КонецЕсли;
    Закрыть(Истина);
  КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияВФайл(Команда)
  ТекДанные = Элементы.КонфликтующиеФайлы.ТекущиеДанные;
  ТекДанныеКонфликт = Элементы.КонфликтыФайла.ТекущиеДанные;
  Если ТекДанные = Неопределено ИЛИ ТекДанныеКонфликт = Неопределено Тогда
    Возврат;  
  КонецЕсли;
  
  Конфликты = Новый Соответствие();
  ЧтениеТекста = Новый ЧтениеТекста(ТекДанные.ПолныйПутьКФайлу, КодировкаТекста.UTF8);
  Строка = ЧтениеТекста.Прочитать();
  ЧтениеТекста.Закрыть();

  ЗаписьТекста = Новый ЗаписьТекста(ТекДанные.ПолныйПутьКФайлу, КодировкаТекста.UTF8);
  ЗаписьТекста.Записать(СтрЗаменить(Строка, ТекДанныеКонфликт.ТекстКонфликта, ПредварительныйПросмотрКонфликта));
  ЗаписьТекста.Закрыть();
  
  Модифицированность = Ложь;
  ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Файл изменен");
  
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НайтиКонфликтующиеФайлы()
  Каталог = Новый Файл(ПутьКЛокальнойДиректории);
  Если ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") И Каталог.Существует() Тогда
    Результат = ЭтаФорма.ВладелецФормы.ВыполнитьМетод("status", Ложь);
    РазобратьРезультат(Результат);
  Иначе
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Каталог ""%1"" не существует", ПутьКЛокальнойДиректории));
  КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазобратьРезультат(ТекстXML)
  Перем DOM, XML, ЧтениеXML, Узел;
  
  ЧтениеXML = Новый ЧтениеXML();
  ЧтениеXML.УстановитьСтроку(ТекстXML);
  
  DOM = Новый ПостроительDOM;                      
  XML = DOM.Прочитать(ЧтениеXML); 
  
  ВыборкаУзлов = XML.ВычислитьВыражениеXPath("//wc-status[@item = 'conflicted']/..", XML, Новый РазыменовательПространствИменDOM(XML)); 
  Узел = ВыборкаУзлов.ПолучитьСледующий();
  Пока Узел <> Неопределено Цикл
    Путь = Узел.Атрибуты.ПолучитьИменованныйЭлемент("path");
    Если Путь <> Неопределено Тогда
      НовСтр = КонфликтующиеФайлы.Добавить();
      НовСтр.ПолныйПутьКФайлу = Путь.Значение;
      НовСтр.ФайлИмеетКонфликт = Истина;
    КонецЕсли;
    
    Узел = ВыборкаУзлов.ПолучитьСледующий();
  КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Функция СуществуютКонфликты()
  Перем ФайлыСКонфликтами, Расширения, Каталог, ЧтениеТекста;
  Состояние("Анализ файлов...");
  
  Каталог = Новый Файл(ПутьКЛокальнойДиректории);
  ФайлыСКонфликтами = Новый Массив();
  Расширения = Новый Массив();
  Расширения.Добавить(".XSL");
  Расширения.Добавить(".XSLT");
  
  Если Каталог.Существует() Тогда
    Для Каждого Ф Из НайтиФайлы(ПутьКЛокальнойДиректории, "*.*", Истина) Цикл
      Если Ф.ЭтоФайл() И Расширения.Найти(ВРег(Ф.Расширение)) <> Неопределено Тогда
        ЧтениеТекста = Новый ЧтениеТекста(Ф.ПолноеИмя, КодировкаТекста.UTF8);
        ТекстФайла = ЧтениеТекста.Прочитать();
        ЧтениеТекста.Закрыть();
        
        Если СтрЧислоВхождений(ТекстФайла, "<<<<<<<") > 0 Тогда
          ФайлыСКонфликтами.Добавить(Ф.ПолноеИмя);
        КонецЕсли;
      КонецЕсли;
    КонецЦикла;
  Иначе
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Каталог ""%1"" не существует", ПутьКЛокальнойДиректории));
  КонецЕсли;
  
  Если ФайлыСКонфликтами.Количество() > 0 Тогда
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не все файлы исправлены!");
    
    Для Каждого Стр Из КонфликтующиеФайлы Цикл
      Стр.ФайлИмеетКонфликт = ФайлыСКонфликтами.Найти(Стр.ПолныйПутьКФайлу) <> Неопределено;
    КонецЦикла;
    
    Возврат Истина;
  Иначе
    Возврат Ложь;
  КонецЕсли;
КонецФункции

&НаКлиенте
Процедура РазборВыбранногоФайла()
  Перем ЧтениеТекста, Конфликты;
  
  ТекДанные = Элементы.КонфликтующиеФайлы.ТекущиеДанные;
  Если ТекДанные = Неопределено Тогда
    Возврат;  
  КонецЕсли;
  
  Конфликты = Новый Соответствие();
  ЧтениеТекста = Новый ЧтениеТекста(ТекДанные.ПолныйПутьКФайлу, КодировкаТекста.UTF8);
  Строка = ЧтениеТекста.ПрочитатьСтроку();
  
  ОткрытНаборСтрок = Ложь;
  ИндексКонфликта = 0;
  Пока Строка <> Неопределено Цикл
    Если СтрЧислоВхождений(Строка, "<<<<<<<") > 0 Тогда
      ОткрытНаборСтрок = Истина;
      ИндексКонфликта = ИндексКонфликта +1;
    ИначеЕсли СтрЧислоВхождений(Строка, ">>>>>>>") > 0 Тогда
      ОткрытНаборСтрок = Ложь;
      Конфликты[ИндексКонфликта].Добавить(Строка);
      
      Строка = ЧтениеТекста.ПрочитатьСтроку();
      Продолжить;
    КонецЕсли;
    
    Если ОткрытНаборСтрок Тогда
      Если Конфликты[ИндексКонфликта] = Неопределено Тогда
        Конфликты.Вставить(ИндексКонфликта, Новый Массив());
      КонецЕсли;
      Конфликты[ИндексКонфликта].Добавить(Строка);
    КонецЕсли;
    
    Строка = ЧтениеТекста.ПрочитатьСтроку();
  КонецЦикла;
  ЧтениеТекста.Закрыть();
  
  
  ПредварительныйПросмотрКонфликта = "";
  КонфликтыФайла.Очистить();
  Для Каждого Стр Из Конфликты Цикл
    НовСтр = КонфликтыФайла.Добавить();
    НовСтр.НомерКонфликта = КонфликтыФайла.Количество();
    НовСтр.ТекстКонфликта = СтрСоединить(Стр.Значение, Символы.ПС);
  КонецЦикла;
  
  Элементы.ПредварительныйПросмотрКонфликта.Заголовок = СтрШаблон("Предварительный просмотр конфликтов. Найдено ""%1"" конфликта", Конфликты.Количество());
КонецПроцедуры

#КонецОбласти

