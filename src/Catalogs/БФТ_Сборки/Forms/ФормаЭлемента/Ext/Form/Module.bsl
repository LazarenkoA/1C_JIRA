﻿/////////////// Защита модуля ///////////////
// @protect                                //
/////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
  Если Не ЗначениеЗаполнено(Объект.НастройкиРаботыСРепозиторием) Тогда
    Объект.НастройкиРаботыСРепозиторием = Справочники.БФТ_НастройкаПодключенияКРепозиторию.ПолучитьЕдинственнуюНастройкуПодключенияКРепозиторию();  
  КонецЕсли;
  
  Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
    Объект.Дата = ТекущаяДатаСеанса();  
  КонецЕсли;
  
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
  ОбновитьВидимостьЭлементовНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
  Если ИмяСобытия = "СозданиеНовогоНабораИзменений" И Источник = ЭтаФорма Тогда
    Если Объект.НаборыИзменений.НайтиСтроки(Новый Структура("НаборИзменений", Параметр)).Количество() = 0 Тогда
      НовСтр = Объект.НаборыИзменений.Добавить();  
      НовСтр.НаборИзменений = Параметр;
      НовСтр.ВходитВБазовыйНабор = Истина;
      ЭтаФорма.Записать();
      
      ОбновитьВидимостьЭлементовНаКлиенте();
    КонецЕсли;
  КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КартинкаПредупреждениеНажатие(Элемент)
  ПоказатьВопрос(Новый ОписаниеОповещения("КартинкаПредупреждениеНажатиеЗавершение", ЭтотОбъект), 
  "Создать задачу, что бы привязать не привязанные наборы изменений?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да, "Выберите действия");
КонецПроцедуры

&НаКлиенте
Процедура КартинкаПредупреждениеВысокоеНажатие(Элемент)
  НеАктуальныеЗадачи = ПолучитьНеАктуальныеЗадачи();
  ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("По задачам %1 были внесены правки, уже после формирования сборки, необходимо переформировать сборку", СтрСоединить(НеАктуальныеЗадачи, ",")));    
КонецПроцедуры

&НаКлиенте
Процедура КартинкаПредупреждениеСлияниеНажатие(Элемент)
  ОбработатьКонфликты();
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйПутьКСборкеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
  СтандартнаяОбработка = Ложь;
  
  ПутьКДиректории = ПолучитьПутьКДиректории();
  Если ЗначениеЗаполнено(ПутьКДиректории) Тогда
    Объект.ЛокальныйПутьКСборке = ПутьКДиректории;
  КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборыИзменений

&НаКлиенте
Процедура НаборыИзмененийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
  Если Объект.БазовыйНомерРевизии = 0 Тогда
    Отказ = Истина;
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите базовую ревизию");
  КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаборыИзмененийПередУдалением(Элемент, Отказ)
  Для Каждого ИндексСтроки Из Элемент.ВыделенныеСтроки Цикл
    ДанныеСтроки = Элемент.ДанныеСтроки(ИндексСтроки);
    Если ДанныеСтроки <> Неопределено И ДанныеСтроки.ВходитВБазовыйНабор Тогда
      Отказ = Истина;
      ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрещено удалять строки входящие в базовый набор изменений");
      Прервать;
    КонецЕсли;
  КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НаборыИзмененийНаборИзмененийПриИзменении(Элемент)
  ТекущиеДанные = Элементы.НаборыИзменений.ТекущиеДанные;
  Если ТекущиеДанные <> Неопределено Тогда
    Если Объект.НаборыИзменений.НайтиСтроки(Новый Структура("НаборИзменений", ТекущиеДанные.НаборИзменений)).Количество() > 1 Тогда
      ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Набор изменений ""%1"" уже добавлен", ТекущиеДанные.НаборИзменений));
      ТекущиеДанные.НаборИзменений = ПредопределенноеЗначение("Справочник.БФТ_НаборыИзменений.ПустаяСсылка");
    КонецЕсли;
  КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаборыИзмененийПриИзменении(Элемент)
  ОбновитьВидимостьЭлементовНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура НаборыИзмененийНаборИзмененийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
  СтандартнаяОбработка = Ложь;
  
  Парам = Новый Структура("НаборыИсключения", ПолучитьДобавленныеНаборы());
  ОО = Новый ОписаниеОповещения("НаборыИзмененийНаборИзмененийНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ТекущиеДанные", Элементы.НаборыИзменений.ТекущиеДанные));
  ОткрытьФорму("Справочник.БФТ_НаборыИзменений.ФормаВыбора", Парам, ,,,, ОО, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);  
КонецПроцедуры

&НаКлиенте
Процедура НаборыИзмененийНаборИзмененийНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
  Перем ТекущиеДанные;
  
  Если Результат <> Неопределено И ДополнительныеПараметры.Свойство("ТекущиеДанные", ТекущиеДанные) И ТекущиеДанные <> Неопределено Тогда
    ТекущиеДанные.НаборИзменений = Результат;
    Если ЕстьСвязанныеЗадачи(Результат) Тогда
      ОбщегоНазначенияКлиентСервер.СообщитьПользователю("С выбранным набором существует связанный другой набор изменений");  
    КонецЕсли;
  КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьБазовуюРевизию(Команда)
  Если Элементы.грОбщее.ТолькоПросмотр Тогда
    Возврат;  
  КонецЕсли;
  
  Парам = Новый Структура("РежимВыбора", Истина);
  ОткрытьФорму("РегистрСведений.БФТ_ИзмененияРепозитория.ФормаСписка", Парам,,,,, Новый ОписаниеОповещения("УстановитьБазовуюРевизиюЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
  Отказ = Ложь;
  
  Прогресс = 0;
  Если Объект.ТекущийШаг > 0 Тогда
    Если Объект.ТекущийШаг = 1 Тогда
      ОткатитьПроцессСборки(Отказ);
    ИначеЕсли Объект.ТекущийШаг = 2 Тогда
      УдалитьМакетИзСборки(Объект.Ссылка);
    КонецЕсли;
    
    Если Не Отказ Тогда
      Объект.ТекущийШаг = Объект.ТекущийШаг -1;
    Иначе
      ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Произошли ошибки");
    КонецЕсли;
    ЭтаФорма.Записать();
  КонецЕсли;
  ОбновитьВидимостьЭлементовНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
  Отказ = Ложь;
  
  Если Модифицированность Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Сохраните элемент");    
    Возврат;
  КонецЕсли;
  Если Не ПроверитьЗаполнение() Тогда
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не все обязательные поля заполнены");
    Возврат;  
  КонецЕсли;
  
  
  Прогресс = 0;
  Замечания = Новый Массив();
  Если Элементы.КартинкаПредупреждениеВысокое.Видимость Тогда
    Замечания.Добавить("После формирования сборки были внесены изменения, необходимо переформировать!");
  КонецЕсли;
  Если Элементы.КартинкаПредупреждение.Видимость Тогда
    Замечания.Добавить("Существуют не привязанные наборы изменений, необходимо привязать!");
  КонецЕсли;
  Если Объект.БылКонфликтСлияния Тогда
    Замечания.Добавить("Существуют конфликты слияния, необходимо разрешить конфликты!");
  КонецЕсли;
  
  Если Замечания.Количество() > 0 Тогда
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("Необходимо устранить замечания:%1%2", Символы.ПС, СтрСоединить(Замечания, Символы.ПС)), СтатусСообщения.Важное);  
    Возврат;
  КонецЕсли;
  
  Если Объект.ТекущийШаг < 3 Тогда      
    Если Объект.ТекущийШаг = 2 Тогда
      
      ОО = Новый ОписаниеОповещения("ДалееЗавершение", ЭтотОбъект, Новый Структура("Отказ", Отказ));
      ПоказатьВопрос(ОО, "Действие отменить будет невозможно
      |Продолжить?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да, "Выберите действия");
      Возврат;
    ИначеЕсли Объект.ТекущийШаг = 0 Тогда
      ЗапуститьПроцессСборки(Отказ);
    ИначеЕсли Объект.ТекущийШаг = 1 Тогда
      ЗапуститьПроцессСозданияМакета(Отказ);
    КонецЕсли;
    
    Если Не Отказ Тогда
      ПереходДалее();
    Иначе
      ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Произошли ошибки");
    КонецЕсли;
  КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьКонфликтыСлияния(Команда)
  ОбработатьКонфликты();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьВидимостьЭлементовНаКлиенте()
  ШагВСтатус();
  Элементы.ФормаНазад.Доступность = Объект.ТекущийШаг > 0 И Объект.ТекущийШаг < 3;
  Элементы.ФормаДалее.Доступность = Объект.ТекущийШаг < 3;
  Элементы.грОбщее.ТолькоПросмотр = Объект.ТекущийШаг <> 0;
  Элементы.КартинкаПредупреждение.Видимость = ЕстьНеПривязанныеНаборыИзменений(Объект.БазовыйНомерРевизии);
  
  Отбор = Новый Структура("ЗадачаНеАктуальна", Истина);
  Элементы.КартинкаПредупреждениеВысокое.Видимость = Объект.НаборыИзменений.НайтиСтроки(Отбор).Количество() > 0;
  Элементы.грКонфликтыСлияния.Видимость = Объект.БылКонфликтСлияния;
КонецПроцедуры

&НаСервере
Функция ШагВСтатус()
  Если Объект.ТекущийШаг = 0 Тогда
    ТекущийСтатус = "На редактировании"; 
    Элементы.ТекущийСтатус.Подсказка = "На текущем статусе производится выбор списка задач.
    |При переходе в следующий статус будет сформирован макет содержащий изменения выбранных задач.";
  ИначеЕсли Объект.ТекущийШаг = 1 Тогда
    ТекущийСтатус = "В работе";  
    Элементы.ТекущийСтатус.Подсказка = "На текущем статусе редактирование списка задач запрещено.
    |На текущем статусе происходит устранение конфликтов слияния (если такие имеются).
    |При переходе в следующий статус будет сформирован макет.";
  ИначеЕсли Объект.ТекущийШаг = 2 Тогда
    ТекущийСтатус = "На тестировании";  
    Элементы.ТекущийСтатус.Подсказка = "На текущем статусе редактирование списка задач запрещено.
    |После перехода в следующий статус изменить сборку будет невозможно, только создавать новую."; 
  ИначеЕсли Объект.ТекущийШаг = 3 Тогда
    ТекущийСтатус = "Релиз";  
    Элементы.ТекущийСтатус.Подсказка = "Сборка на текущем статусе протестирована и готова для вывоза клиентам.";
  КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПереходДалее()
  
  Объект.ТекущийШаг = Объект.ТекущийШаг +1;
  ЭтаФорма.Записать();
  ОбновитьВидимостьЭлементовНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьБазовуюРевизиюЗавершение(Результат, ДополнительныеПараметры) Экспорт
  Если Результат <> Неопределено Тогда
    Объект.БазовыйНомерРевизии = Результат;  
    ЗагрузитьБазовыеНаборыИзмененийНаСервере();
    ОбновитьВидимостьЭлементовНаКлиенте();
  КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьБазовыеНаборыИзмененийНаСервере()
  Если Объект.БазовыйНомерРевизии = 0 Тогда
    Возврат;  
  КонецЕсли;
  
  СписокЗадач = ПолучитьСписокЗадачВходящихВРевизию(Объект.БазовыйНомерРевизии);
  Объект.НаборыИзменений.Очистить();
  Для Каждого Задача Из СписокЗадач Цикл
    НовСтр = Объект.НаборыИзменений.Добавить();
    НовСтр.НаборИзменений = Задача;
    НовСтр.ВходитВБазовыйНабор = Истина;
  КонецЦикла;
  
  ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокЗадачВходящихВРевизию(БазовыйНомерРевизии)
  Запрос = Новый Запрос;
  Запрос.Текст = 
  "ВЫБРАТЬ РАЗЛИЧНЫЕ
  | БФТ_НаборыИзмененийНаборИзменений.Ссылка
  |ИЗ
  | Справочник.БФТ_НаборыИзменений.НаборИзменений КАК БФТ_НаборыИзмененийНаборИзменений
  |ГДЕ
  | БФТ_НаборыИзмененийНаборИзменений.НомерРевизии <= &НомерРевизии";
  
  Запрос.УстановитьПараметр("НомерРевизии", БазовыйНомерРевизии);
  
  Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьМакетИзСборки(СборкаСсылка)
  Набор = РегистрыСведений.БФТ_ХранилищеМакетов.СоздатьНаборЗаписей();
  Набор.Отбор.Сборка.Установить(СборкаСсылка);
  Набор.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ДалееЗавершение(РезультатВопроса, ДопПарам) Экспорт
  
  Если РезультатВопроса <> КодВозвратаДиалога.Да ИЛИ ДопПарам.Отказ Тогда
    Возврат;
  КонецЕсли;
  
  ПереходДалее();
  
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьПроцессСозданияМакета(Отказ)
  Перем Расширения, СодержимоеФайлов, Коды;
  // Шаг 1, из полученного каталога сборки загружаем в систему тексты шаблонов;
  // Шаг 2, выгружаем объекты БФТ_ФайлыШаблоновПреобразования, БФТ_ШаблоныПреобразования, БФТ_Системы;
  // Шаг 3, Помещаем полученный макет в регистр;
  // Шаг 4, Откатываем изменения сделанные в шаге 1;
  // Шаг 5, Удаляем все следы из репозитория.
  
  #region Шаг_1
  ДвинутьПрогресс(4);
  Попытка
    Состояние("Загружаем файлы с диска в базу...");
    
    СодержимоеФайлов = Новый Соответствие();
    Коды = Новый Массив();
    
    
    Каталог = Новый Файл(Объект.ЛокальныйПутьКСборке);
    Расширения = Новый Массив();
    Расширения.Добавить(".XSL");
    Расширения.Добавить(".XSLT");
    Расширения.Добавить(".XSD");
    
    Если Каталог.Существует() Тогда
      Для Каждого Ф Из НайтиФайлы(Объект.ЛокальныйПутьКСборке, "*.*", Истина) Цикл
        Если Ф.ЭтоФайл() И Расширения.Найти(ВРег(Ф.Расширение)) <> Неопределено Тогда
          ЧастиИмени = СтрРазделить(Ф.ИмяБезРасширения, "_");
          Если ЧастиИмени.Количество() > 0 И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЧастиИмени[0]) Тогда
            Префикс = ЧастиИмени[0];
            
            ЧтениеТекста = Новый ЧтениеТекста(Ф.ПолноеИмя, КодировкаТекста.UTF8);
            ТекстФайла = ЧтениеТекста.Прочитать();
            ЧтениеТекста.Закрыть();
            
            СодержимоеФайлов.Вставить(Префикс, ТекстФайла);
            Коды.Добавить(Префикс);
          КонецЕсли;
        КонецЕсли;
      КонецЦикла;
    Иначе
      ВызватьИсключение(СтрШаблон("Каталог ""%1"" не существует", Объект.ЛокальныйПутьКСборке));
    КонецЕсли;
    
    БФТ_ОбщиеМетодыАРМаСборокНаСервере.ОбновитьНаСервереТекстыШаблонов(Коды, СодержимоеФайлов);
  Исключение
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("При загрузке файлов в базу произошла ошибка:%1%2", Символы.ПС, ОписаниеОшибки()));
  КонецПопытки;
  
  #endregion
  
  #region Шаг_2_И_Шаг_3
  ДвинутьПрогресс(4);
  Попытка
    Состояние("Выгружаем объекты в макеты и помещаем в базу...");
    ВыгрузитьМакетыНаСервере(Объект.Ссылка);
  Исключение
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("При выгрузке макетов произошла ошибка:%1%2", Символы.ПС, ОписаниеОшибки()));
  КонецПопытки;
  #endregion
  
  #region Шаг_4
  ДвинутьПрогресс(4);
  Попытка
    Состояние("Отменяем изменения...");
    // ЗагрузитьМакетПредыдущейСборки(Объект.Дата);  Пока закомментировал, не понятно нужно ли вообще откатывать.
  Исключение
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("При загрузки предыдущей сборки произошла ошибка:%1%2", Символы.ПС, ОписаниеОшибки()));
  КонецПопытки;
  #endregion
  
  #region Шаг_5
  ДвинутьПрогресс(4);
  Попытка
    Состояние("Чистим репозиторий...");
    ОткатитьПроцессСборки(Ложь);
  Исключение
    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон("При очистки репозитория произошла ошибка:%1%2", Символы.ПС, ОписаниеОшибки()));
  КонецПопытки;
  #endregion
  
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыгрузитьМакетыНаСервере(СборкаСсылка)
  ВремФайл = ПолучитьИмяВременногоФайла("xml");
  Попытка
		
		//ОбъектОбработки = Обработки.БФТ_ВыгрузкаЗагрузкаПоставляемыхДанных.Создать();
		//ОбъектОбработки.Инициализировать();
		//
		//Подсистема = Метаданные.Подсистемы.АЦК_БУ.Подсистемы.БФТ_ПоставляемыеДанные.Подсистемы.НастройкиСинхронизатора.Подсистемы.Шаблоны;
		//ПолноеИмяМетаданных = Подсистема.ПолноеИмя();
		//Строка = ОбъектОбработки.ДеревоМетаданных.Строки.Найти(ПолноеИмяМетаданных, "ПолноеИмяМетаданных", Истина);
		//Для Каждого Стр Из Строка.Строки Цикл
		//  Стр.Выгружать = 1;  
		//КонецЦикла;
		//
		//ОбъектОбработки.ВыполнитьВыгрузку(ВремФайл);
		//ф = Новый Файл(ВремФайл);
		//Если Ф.Существует() Тогда
		//  Ч = Новый ЧтениеТекста(ВремФайл, КодировкаТекста.UTF8);
		//  Тело = Ч.Прочитать();
		//  Ч.Закрыть();
		//  Данные = РегистрыСведений.БФТ_ФайлыШаблоновПреобразования.ПодготовитьТелоФайла(Тело);
		//  
		//  Запись = РегистрыСведений.БФТ_ХранилищеМакетов.СоздатьМенеджерЗаписи();
		//  Запись.Сборка = СборкаСсылка;
		//  Запись.ВерсияАЦК_БУ = БФТ_ОбщиеМетодыАРМаСборокНаСервере.ПолучитьПорядковыйНомерВерсииПодсистемыАЦК();
		//  Запись.ДанныеМакета = Данные;
		//  Запись.ИмяПодсистемы = Подсистема.Имя;
		//  Запись.Записать();
		//КонецЕсли;
		
    УдалитьФайлы(ВремФайл);  
  Исключение
    УдалитьФайлы(ВремФайл);  
    ВызватьИсключение;
  КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьПроцессСборки(Отказ)
  Если Не ЗначениеЗаполнено(Объект.НастройкиРаботыСРепозиторием) Тогда
    ВызватьИсключение "Заполните поле ""Настройки работы с репозиторием""";  
  КонецЕсли;
  
  ВыполнитьМетод("copy", Отказ);
  ДвинутьПрогресс(3);
  ВыполнитьМетод("update", Отказ);
  ДвинутьПрогресс(3);
  ОбъединитьВерсии(Отказ);
  ДвинутьПрогресс(3);
КонецПроцедуры

&НаКлиенте
Процедура ДвинутьПрогресс(КолВоОпераций)
  Часть = 100/КолВоОпераций;
  Прогресс = Прогресс + Часть;
  ОбновитьОтображениеДанных(Элементы.Прогресс);
  
  Если 100-Прогресс < 1 Тогда 
    Прогресс = 100; // это нужно для того что бы понять что прогресс дошел до конца, с учетом вещественных чисел   
  КонецЕсли;
  
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьВерсии(Отказ)
  Перем Результат;
  
  НомераРевизийДляСлияния = ПолучитьНомераРевизийДляСлияния();
  Если НомераРевизийДляСлияния.Количество() > 0 Тогда
    
    Парам = Новый Структура("НомераРевизийДляСлияния", СтрСоединить(НомераРевизийДляСлияния, ","));
    Результат = ВыполнитьМетод("merge", Отказ, Парам);
    ЕстьКонфликты = СтрЧислоВхождений(Результат, "Summary of conflicts") > 0;
    Объект.БылКонфликтСлияния = ЕстьКонфликты;
  КонецЕсли;
  
КонецПроцедуры

&НаКлиенте
Процедура ОткатитьПроцессСборки(Отказ)
  Если Не ЗначениеЗаполнено(Объект.НастройкиРаботыСРепозиторием) Тогда
    ВызватьИсключение "Заполните поле ""Настройки работы с репозиторием""";  
  КонецЕсли;
  
  Для Каждого Стр Из Объект.НаборыИзменений Цикл
    Стр.ЗадачаНеАктуальна = Ложь; // Сбрасываем флаг    
  КонецЦикла;
  Объект.БылКонфликтСлияния = Ложь;
  
  ВыполнитьМетод("revert", Отказ);
  ВыполнитьМетод("delete", Отказ);
  ВыполнитьМетод("update", Отказ);
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьМетод(ИмяКоманды, Отказ, Знач ПараметрыКоманды = Неопределено) Экспорт 
  Попытка
    Отказ = Ложь;
    
    Если Не ЗначениеЗаполнено(Объект.ЛокальныйПутьКСборке) Тогда
      Отказ = Истина;
      ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните локальный путь к сборке");  
      Возврат "";
    КонецЕсли;
    
    СделатьНовуюЗаписьЛога(СтрШаблон("Выполняем команду ""%1""", ИмяКоманды));
    
    Если ПараметрыКоманды = Неопределено Тогда
      ПараметрыКоманды = Новый Структура();    
    КонецЕсли;
    Если Не ПараметрыКоманды.Свойство("НомераРевизийДляСлияния") Тогда
      ПараметрыКоманды.Вставить("НомераРевизийДляСлияния", СтрСоединить(ПолучитьНомераРевизийДляСлияния(), ","));  
    КонецЕсли;
    ПараметрыКоманды.Вставить("НомерСборки", Объект.Код);
    ПараметрыКоманды.Вставить("НомерБазовойРевизии", Объект.БазовыйНомерРевизии);
    ПараметрыКоманды.Вставить("ЛокальныйПутьКСборке", Объект.ЛокальныйПутьКСборке);
    ПараметрыКоманды.Вставить("ЛокальныйКаталогДляСинхронизации", СтрШаблон("%1\%2", Объект.ЛокальныйПутьКСборке, Объект.Код));
    ПараметрыКоманды.Вставить("Пароль", БФТ_ОбщиеМетодыАРМаСборокНаКлиентеНаСервере.ПарольДоступаК_SVN());
    
    Результат = БФТ_ОбщиеМетодыАРМаСборокНаКлиентеНаСервере.ВыполнитьМетод(Объект.НастройкиРаботыСРепозиторием, ИмяКоманды, ПараметрыКоманды);
    ДополнитьЗаписьЛога("Готово");
    
    Возврат Результат;
  Исключение
    Отказ = Истина;
    ДополнитьЗаписьЛога(СтрШаблон("Произошла ошибка:%1%2", Символы.ПС, ОписаниеОшибки()));
  КонецПопытки;
КонецФункции

&НаКлиенте
Процедура СделатьНовуюЗаписьЛога(Текст)
  Объект.Лог = Объект.Лог + СтрШаблон("%3------------------------%3 (%1) %2%3", Формат(ТекущаяДата(), "ДЛФ=DDT"), Текст, Символы.ПС);
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьЗаписьЛога(Текст)
  Объект.Лог = Объект.Лог + СтрШаблон("%1- %2", Символы.Таб, Текст);
КонецПроцедуры

&НаСервере
Функция ПолучитьНомераРевизийДляСлияния()
  Запрос = Новый Запрос;
  Запрос.Текст = 
  "ВЫБРАТЬ РАЗЛИЧНЫЕ
  | БФТ_СборкиНаборыИзменений.НаборИзменений КАК НаборИзменений,
  | БФТ_Сборки.БазовыйНомерРевизии КАК БазовыйНомерРевизии
  |ПОМЕСТИТЬ Сборка
  |ИЗ
  | Справочник.БФТ_Сборки.НаборыИзменений КАК БФТ_СборкиНаборыИзменений
  |   ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БФТ_Сборки КАК БФТ_Сборки
  |   ПО БФТ_СборкиНаборыИзменений.Ссылка = БФТ_Сборки.Ссылка
  |ГДЕ
  | БФТ_Сборки.Ссылка = &Ссылка
  |
  |ИНДЕКСИРОВАТЬ ПО
  | НаборИзменений,
  | БазовыйНомерРевизии
  |;
  |
  |////////////////////////////////////////////////////////////////////////////////
  |ВЫБРАТЬ РАЗЛИЧНЫЕ
  | БФТ_НаборыИзмененийНаборИзменений.НомерРевизии
  |ИЗ
  | Сборка КАК Сборка
  |   ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БФТ_НаборыИзменений.НаборИзменений КАК БФТ_НаборыИзмененийНаборИзменений
  |   ПО Сборка.НаборИзменений = БФТ_НаборыИзмененийНаборИзменений.Ссылка
  |     И (БФТ_НаборыИзмененийНаборИзменений.НомерРевизии > Сборка.БазовыйНомерРевизии)";
  
  Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
  Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НомерРевизии");
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьНеПривязанныеНаборыИзменений(БазовыйНабор)
  Возврат ПолучитьНеПривязанныеНаборыИзменений(БазовыйНабор).Количество() > 0;  
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНеПривязанныеНаборыИзменений(БазовыйНабор)
  Запрос = Новый Запрос;
  Запрос.Текст = 
  "ВЫБРАТЬ РАЗЛИЧНЫЕ
  | БФТ_ИзмененияРепозиторияСрезПоследних.НомерРевизии КАК НомерРевизии
  |ИЗ
  | РегистрСведений.БФТ_ИзмененияРепозитория.СрезПоследних КАК БФТ_ИзмененияРепозиторияСрезПоследних
  |   ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БФТ_НаборыИзменений.НаборИзменений КАК БФТ_НаборыИзмененийНаборИзменений
  |   ПО БФТ_ИзмененияРепозиторияСрезПоследних.НомерРевизии = БФТ_НаборыИзмененийНаборИзменений.НомерРевизии
  |ГДЕ
  | БФТ_НаборыИзмененийНаборИзменений.Ссылка ЕСТЬ NULL 
  | И БФТ_ИзмененияРепозиторияСрезПоследних.НомерРевизии <= &БазовыйНабор";
  
  Запрос.УстановитьПараметр("БазовыйНабор", БазовыйНабор);
  
  Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НомерРевизии");
КонецФункции

&НаКлиенте
Процедура КартинкаПредупреждениеНажатиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
  
  Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
    Наборы = ПолучитьНеПривязанныеНаборыИзменений(Объект.БазовыйНомерРевизии);  
    ОткрытьФорму("Справочник.БФТ_НаборыИзменений.ФормаОбъекта", Новый Структура("НаборыИзменений", Наборы), ЭтаФорма);
  КонецЕсли;
  
КонецПроцедуры

&НаСервере
Функция ПолучитьНеАктуальныеЗадачи()
  НаборыИзменений = Объект.НаборыИзменений.Выгрузить();
  НеАктуальныеСтроки = НаборыИзменений.НайтиСтроки(Новый Структура("ЗадачаНеАктуальна", Истина));  
  Возврат НаборыИзменений.Скопировать(НеАктуальныеСтроки).ВыгрузитьКолонку("НаборИзменений");
КонецФункции

&НаКлиенте
Процедура ОбработатьКонфликты()
  ОткрытьФорму("Справочник.БФТ_Сборки.Форма.ФормаОбработатьКонфликты",, ЭтаФорма,,,, Новый ОписаниеОповещения("ОбработатьКонфликтыЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьКонфликтыЗавершение(Результат, ДополнительныеПараметры) Экспорт
  
  Если Результат = Истина Тогда
    ОбъединитьВерсии(Ложь); // могут быть другие конфликты
    ЭтаФорма.Записать();
    ОбновитьВидимостьЭлементовНаКлиенте();
  КонецЕсли;
  
КонецПроцедуры

&НаСервере
Функция ЕстьСвязанныеЗадачи(НаборСсылка)
  Запрос = Новый Запрос;
  Запрос.Текст = 
  "ВЫБРАТЬ
  | БФТ_НаборыИзмененийНаборИзменений1.Ссылка
  |ИЗ
  | Справочник.БФТ_НаборыИзменений.НаборИзменений КАК БФТ_НаборыИзмененийНаборИзменений
  |   ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.БФТ_НаборыИзменений.НаборИзменений КАК БФТ_НаборыИзмененийНаборИзменений1
  |   ПО БФТ_НаборыИзмененийНаборИзменений.НомерРевизии = БФТ_НаборыИзмененийНаборИзменений1.НомерРевизии
  |     И БФТ_НаборыИзмененийНаборИзменений.Ссылка <> БФТ_НаборыИзмененийНаборИзменений1.Ссылка
  |     И (БФТ_НаборыИзмененийНаборИзменений.Ссылка = &НаборСсылка)";
  
  Запрос.УстановитьПараметр("НаборСсылка", НаборСсылка);
  
  Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

&НаСервере
Функция ПолучитьДобавленныеНаборы()
  Возврат Объект.НаборыИзменений.Выгрузить().ВыгрузитьКолонку("НаборИзменений");
КонецФункции

&НаКлиенте
Функция ПолучитьПутьКДиректории()
  #Если ВебКлиент Тогда 
    Каталог = КаталогДокументов();
  #Иначе
    Каталог = КаталогПрограммы();
  #КонецЕсли 
  
  Если ЗначениеЗаполнено(Объект.ЛокальныйПутьКСборке) Тогда
    Файл = Новый Файл(Объект.ЛокальныйПутьКСборке); 
    Если Файл.Существует() Тогда
      Каталог = Файл.Путь;
    КонецЕсли;
  КонецЕсли;
  
  Диалог            = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
  Диалог.Заголовок  = "Выберите каталог";  
  Диалог.МножественныйВыбор = Ложь;
  Диалог.Каталог = Каталог; 
  
  Если Диалог.Выбрать() Тогда
    Возврат Диалог.Каталог;
  КонецЕсли;  
КонецФункции

//&НаСервереБезКонтекста
//Процедура ЗагрузитьМакетПредыдущейСборки(ДатаТекСборки)
//  Запрос = Новый Запрос;
//  Запрос.Текст = 
//    "ВЫБРАТЬ ПЕРВЫЕ 1
//    | БФТ_Сборки.Ссылка
//    |ИЗ
//    | Справочник.БФТ_Сборки КАК БФТ_Сборки
//    |ГДЕ
//    | БФТ_Сборки.Дата < &ДатаТекСборки
//    | И БФТ_Сборки.ТекущийШаг = 3
//    |
//    |УПОРЯДОЧИТЬ ПО
//    | БФТ_Сборки.Дата УБЫВ";
//  
//  Запрос.УстановитьПараметр("ДатаТекСборки", ДатаТекСборки);
//  
//  Выборка = Запрос.Выполнить().Выбрать();
//  
//  Если Выборка.Следующий() Тогда
//    ОбъектОбработки = Обработки.БФТ_ВыгрузкаЗагрузкаПоставляемыхДанных.Создать();
//    ОбъектОбработки.ВыполнитьЗагрузкуИзСборки(Выборка.Ссылка);  
//  Иначе
//    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//      "Предыдущая сборка на статусе ""Релиз"" не найдена, восстановите макеты в ручном режиме");
//  КонецЕсли;
//КонецПроцедуры

#КонецОбласти
