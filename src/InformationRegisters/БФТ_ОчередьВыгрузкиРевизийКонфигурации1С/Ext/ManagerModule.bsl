﻿/////////////// Защита модуля ///////////////
// @protect                                //
/////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс


Функция ПолучитьПоследнююЗагруженнуюРевизию() Экспорт 
  Перем Результат;
  
  ПараметрыКоманды = Новый Структура();
  ПараметрыКоманды.Вставить("Пароль", БФТ_ОбщиеМетодыАРМаСборокНаКлиентеНаСервере.ПарольДоступаК_SVN());
  ПараметрыКоманды.Вставить("НачальнаяДата", СтрШаблон("{%1}", Формат(ТекущаяДатаСеанса() -(24*60*60), "ДФ=yyyy-MM-dd")));
  НастройкаПодключенияКРепозиторию = Справочники.БФТ_НастройкаПодключенияКРепозиторию.ПолучитьЕдинственнуюНастройкуПодключенияКРепозиторию();
  
  ТекстXML = БФТ_ОбщиеМетодыАРМаСборокНаКлиентеНаСервере.ВыполнитьМетод(НастройкаПодключенияКРепозиторию, "log_1C_Config", ПараметрыКоманды);  
  XML_DOM = БФТ_УтилитыDOM.ПолучитьDOM(ТекстXML);
  
  ВыборкаУзлов = XML_DOM.ВычислитьВыражениеXPath("/log/logentry[not(@revision < ../logentry/@revision)]/msg", XML_DOM, Новый РазыменовательПространствИменDOM(XML_DOM)); 
  Узел = ВыборкаУзлов.ПолучитьСледующий();
  Если Узел <> Неопределено Тогда
    Если СтрНачинаетсяС(Узел.ТекстовоеСодержимое, "commit_1C") Тогда
      Разбивка1 = СтрРазделить(Узел.ТекстовоеСодержимое, " ", Ложь);  
      Если Разбивка1.Количество() > 1 Тогда
        Разбивка2 = СтрРазделить(Разбивка1[0], ":", Ложь);  
        Если Разбивка2.Количество() = 2 Тогда
          Результат = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СокрЛП(Разбивка2[1]));
        КонецЕсли;
      КонецЕсли;               
    КонецЕсли;
  КонецЕсли;
  
  Возврат ?(Результат = Неопределено, 0, Результат);
КонецФункции


#КонецОбласти

#КонецЕсли