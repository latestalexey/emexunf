﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мWSОпределение Экспорт;
Перем мСписокДопустимыхТиповXDTO;
Перем мWSВозвращаемоеЗначениеВозможноПустое;

#КонецОбласти

#Область ПрограммныйИнтерфейс

//======================================================================================
// ПРОЦЕДУРЫ WEB СЕРВИСА
//======================================================================================

Процедура СообщитьОбОшибке(ТекстСообщения, Статус = Неопределено) Экспорт
	#Если Клиент Тогда
		Сообщить(ТекстСообщения, ?(Неопределено = Статус, СтатусСообщения.Внимание, Статус));	
	#КонецЕсли 
КонецПроцедуры

Функция ПолучитьWSОпределение(ФлагМодифицированности = Ложь) Экспорт
	
	Перем WSОпределение;
		
	Если Не ФлагМодифицированности И Не Неопределено = мWSОпределение Тогда
		WSОпределение = мWSОпределение;
	Иначе
		Попытка
			WSОпределение = Новый WSОпределения(WSURLWSDL, Логин, Пароль);
		Исключение
			СообщитьОбОшибке("Неудачная попытка подключения: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли; 
	
	Возврат WSОпределение;
	
КонецФункции

Функция ПолучитьWSСервис(ФлагМодифицированности = Ложь) Экспорт
	
	Перем WSСервис;
	
	Если Не ЗначениеЗаполнено(WSИмяСервиса) Тогда
		СообщитьОбОшибке("Неудачная попытка получения сервиса: не заполнено имя сервиса!");
	Иначе
		Попытка
			WSОпределение = ПолучитьWSОпределение(ФлагМодифицированности);
			Если Не Неопределено = WSОпределение Тогда
				Для каждого Сервис Из мWSОпределение.Сервисы Цикл
					Если Сервис.Имя = WSИмяСервиса Тогда
						WSСервис = Сервис;
						Прервать;
					КонецЕсли; 
				КонецЦикла; 
			КонецЕсли; 
		Исключение
			СообщитьОбОшибке("Неудачная попытка подключения: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли; 
	
	Возврат WSСервис;
	
КонецФункции

Функция ПолучитьWSТочкуПодключения(ФлагМодифицированности) Экспорт
	
	Перем WSТочкаПодключения;
	
	Если Не ЗначениеЗаполнено(WSИмяТочкиПодключения) Тогда
		СообщитьОбОшибке("Неудачная попытка получения точки подключения: не заполнено имя точки подключения!");
	Иначе
		Попытка
			WSСервис = ПолучитьWSСервис(ФлагМодифицированности);
			Для каждого ТочкаПодключения Из WSСервис.ТочкиПодключения Цикл
				Если ТочкаПодключения.Имя = WSИмяТочкиПодключения Тогда
					WSТочкаПодключения = ТочкаПодключения;
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
		Исключение
			СообщитьОбОшибке("Неудачная попытка подключения: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли; 
	
	Возврат WSТочкаПодключения;
	
КонецФункции

Функция ПолучитьWSОперацию(ФлагМодифицированности) Экспорт
	
	Перем WSОперация;
	
	Если Не ЗначениеЗаполнено(WSИмяОперации) Тогда
		СообщитьОбОшибке("Неудачная попытка получения точки подключения: не заполнено имя операции!");
	Иначе
		Попытка
			WSТочкаПодключения = ПолучитьWSТочкуПодключения(ФлагМодифицированности);
			Для каждого Операция Из WSТочкаПодключения.Интерфейс.Операции Цикл
				Если Операция.Имя = WSИмяОперации Тогда
					WSОперация = Операция;
					мWSВозвращаемоеЗначениеВозможноПустое=WSОперация.ВозвращаемоеЗначение.ВозможноПустое;
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
		Исключение
			СообщитьОбОшибке("Неудачная попытка подключения: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли; 
	
	Возврат WSОперация;
	
КонецФункции

Функция ПолучитьWSПараметры(ФлагМодифицированности = Ложь) Экспорт
	
	Перем WSТаблицаПараметров;
	
	Если Не ЗначениеЗаполнено(WSИмяОперации) Тогда
		СообщитьОбОшибке("Неудачная попытка получения параметров: не заполнено имя операции!");
		WSТаблицаПараметров = Неопределено;
	Иначе
		Попытка
			WSТаблицаПараметров = WSПараметры.ВыгрузитьКолонки();
			WSОперация = ПолучитьWSОперацию(ФлагМодифицированности);
			Для каждого Параметр Из WSОперация.Параметры Цикл
				СтрокаТаблицыПараметров = WSТаблицаПараметров.Добавить();
				СтрокаТаблицыПараметров.Имя = Параметр.Имя;
				СтрокаТаблицыПараметров.ТипXDTO = Параметр.Тип.Имя;
				СтрокаТаблицыПараметров.URIПространстваИменXDTO = Параметр.Тип.URIПространстваИмен;
				Если Параметр.НаправлениеПараметра = WSНаправлениеПараметра.Входной Тогда
					СтрокаТаблицыПараметров.НаправлениеПараметра = "Входной";
				ИначеЕсли Параметр.НаправлениеПараметра = WSНаправлениеПараметра.ВходнойВыходной Тогда 	
					СтрокаТаблицыПараметров.НаправлениеПараметра = "Входной-выходной";
				ИначеЕсли Параметр.НаправлениеПараметра = WSНаправлениеПараметра.Выходной Тогда 	
					СтрокаТаблицыПараметров.НаправлениеПараметра = "Выходной";
				КонецЕсли;
				ОпределитьТипXDTOЗначенияСтрокиWSПараметров(СтрокаТаблицыПараметров);
				СтрокаТаблицыПараметров.ВозможноПустой = Параметр.ВозможноПустой;
				СтрокаТаблицыПараметров.Документация = Параметр.Документация;				
			КонецЦикла; 
		Исключение
		
		КонецПопытки;
	КонецЕсли;
	
	Возврат WSТаблицаПараметров;
	
КонецФункции

Процедура ОпределитьТипXDTOЗначенияСтрокиWSПараметров(знач СтрокаТаблицыПараметров)
	
	Макет = ПолучитьМакет("ОписаниеТиповXDTO");
	Область = Макет.Области["Данные"];
	Для к =  Область.Верх По Область.Низ Цикл
		
		ТипXDTO = СокрЛП(Макет.Область("R"+к+"C1").Текст);
		
		Если ТипXDTO=СтрокаТаблицыПараметров.ТипXDTO тогда
			
			ЗначениеТипаXDTO = СокрЛП(Макет.Область("R"+к+"C2").Текст);	
			Если ЗначениеТипаXDTO="Булево" Тогда	 СтрокаТаблицыПараметров.Значение = Ложь; Возврат;
			ИначеЕсли ЗначениеТипаXDTO="Число" Тогда СтрокаТаблицыПараметров.Значение = 0; Возврат;
			ИначеЕсли ЗначениеТипаXDTO="Дата" Тогда  СтрокаТаблицыПараметров.Значение = ТекущаяДата();Возврат;
			ИначеЕсли ЗначениеТипаXDTO="Строка" Тогда СтрокаТаблицыПараметров.Значение = ""; Возврат;
			Иначе //будет список значений
				СтрокаТаблицыПараметров.Значение =ЗначениеТипаXDTO;
				Список=Новый СписокЗначений;				
				Для мК =  к По Область.Низ Цикл
					ТипXDTO = СокрЛП(Макет.Область("R"+мК+"C1").Текст);
					Если ТипXDTO=СтрокаТаблицыПараметров.ТипXDTO или Не ЗначениеЗаполнено(ТипXDTO) тогда
						Список.Добавить(СокрЛП(Макет.Область("R"+мК+"C2").Текст));
					иначе
						Break;
					КонецЕсли;
				конецЦикла;
				СтрокаТаблицыПараметров.ВозможныеЗначения=ЗначениеВСтрокуВнутр(Список);
				Возврат;
			КонецЕсли;
				
		КонецЕсли;
						
	КонецЦикла;
	
	СтрокаТаблицыПараметров.Значение="<недопустимый тип XDTO>";			
					  
КонецПроцедуры

Функция ЗаполнитьСписокWSПараметров(WSПроксиОбъект, СтрокаПараметров) Экспорт 
	
	Перем РезультатВыполнения;
	РезультатВыполнения = Ложь;
	
    Попытка
		
		ТаблицаПараметров = WSПараметры.Выгрузить();
		
		СписокПустыхПараметров = "";
		СтрокаПараметров = "";
		Для ИндексСтроки = 0 По WSПараметры.Количество() - 1 Цикл
			Если Не ЗначениеЗаполнено(WSПараметры[ИндексСтроки].Значение) Тогда
				Если Найти(ТаблицаПараметров[ИндексСтроки].НаправлениеПараметра, "Входной") И НЕ ТаблицаПараметров[ИндексСтроки].ВозможноПустой Тогда    
					СписокПустыхПараметров = СписокПустыхПараметров + ?(ПустаяСтрока(СписокПустыхПараметров), "", ", ") + ТаблицаПараметров[ИндексСтроки].Имя;
				Иначе
					ТипПакета         = WSПроксиОбъект.ФабрикаXDTO.Тип(ТаблицаПараметров[ИндексСтроки].URIПространстваИменXDTO, ТаблицаПараметров[ИндексСтроки].ТипXDTO);
					XDTOОбъект        = WSПроксиОбъект.ФабрикаXDTO.Создать(ТипПакета);
					ТаблицаПараметров[ИндексСтроки].Значение = ТаблицаПараметров.Колонки.Значение.ТипЗначения.ПривестиЗначение(XDTOОбъект);
				КонецЕсли;
			КонецЕсли;
			СтрокаПараметров = СтрокаПараметров + ?(ПустаяСтрока(СтрокаПараметров), "", ", ") + "WSПараметры[" + ИндексСтроки + "].Значение";
		КонецЦикла;
	   
        Если НЕ ПустаяСтрока(СписокПустыхПараметров) Тогда
			ВызватьИсключение("Не заполнены обязательные входные параметры: " + СписокПустыхПараметров);
		КонецЕсли;
		
		WSПараметры.Загрузить(ТаблицаПараметров);
		
		РезультатВыполнения = Истина;
       
    Исключение
        СообщитьОбОшибке("Ошибка заполнения параметров: " + ОписаниеОшибки());
    КонецПопытки;
	
	Возврат РезультатВыполнения;
	
КонецФункции

Функция ВыполнитьWSОперацию(WSПроксиОбъект, СтрокаПараметров) Экспорт
   
	Перем ВозвращаемоеЗначение;
	
    Попытка
       
        Если ПустаяСтрока(WSИмяОперации) Тогда
            ВызватьИсключение("Не указано имя операции!");
        КонецЕсли;
		
	    Выполнить("ВозвращаемоеЗначение = WSПроксиОбъект." + WSИмяОперации + "(" + СтрокаПараметров + ")");
       
    Исключение
        СообщитьОбОшибке("Ошибка вызова операции: " + ОписаниеОшибки());
    КонецПопытки;
   
	Возврат ВозвращаемоеЗначение;
   
КонецФункции

Процедура ЗаполнитьWebСервисы() Экспорт
	
	WebСервисы.Очистить();
	
	Макет = ПолучитьМакет("URLWSDLИменаСервисовТочекДляМетодов");
	Область = Макет.Области["URL_WSDL"];
	Для к =  Область.Верх По Область.Низ Цикл		
		WebСервисы.Добавить(СокрЛП(Макет.Область("R"+к+"C2").Текст),СокрЛП(Макет.Область("R"+к+"C3").Текст));								
	КонецЦикла;
	
КонецПроцедуры

//======================================================================================
// ПРОЦЕДУРЫ ПРЕДВАРИТЕЛЬНОГО ОПРЕДЕЛЕНИЯ
//======================================================================================

Функция ВыполнитьКомандуWebСервиса(WebМетод,СтруктураЗначенияWSПараметров,Знач ТаблицаРезультат) Экспорт
	
	Ошибка="";	
	ЗаполнитьURLWSDLИменаСервисаИТочкиПодключенияWSОперации(WebМетод);
	мWSОпределение = ПолучитьWSОпределение(Истина);
	WSПараметры.Загрузить(ПолучитьWSПараметры());
	ЗаполнитьЗначенияWSПараметров(СтруктураЗначенияWSПараметров);
	
	WSПрокси=ПолучитьWSПрокси();
	
	СтрокаПараметров = "";
	Если Не ЗаполнитьСписокWSПараметров(WSПрокси, СтрокаПараметров) Тогда
		Возврат "Немогу заполнить список WSПараметров !";
	КонецЕсли;
	
	ВозвращаемоеЗначение = ВыполнитьWSОперацию(WSПрокси, СтрокаПараметров);
	Если Не мWSВозвращаемоеЗначениеВозможноПустое И Неопределено = ВозвращаемоеЗначение Тогда
		Возврат "Ошибка выполнения операции!";
	КонецЕсли; 		
	
	Если WebМетод="FindDetailAdv3" тогда
    	ВыполнитьМетодFindDetailAdv3(WSПрокси,ВозвращаемоеЗначение,ТаблицаРезультат,Ошибка);		
	Иначе
		
	КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

Функция ЗаполнитьURLWSDLИменаСервисаИТочкиПодключенияWSОперации(WebМетод)
	
	WSURLWSDL="";
	WSИмяСервиса="";
	WSИмяТочкиПодключения="";
	WSИмяОперации=WebМетод;
	
	Макет = ПолучитьМакет("URLWSDLИменаСервисовТочекДляМетодов");
	Область = Макет.Области["WSОперации"];
	Для к =  Область.Верх По Область.Низ Цикл
		
		ИмяМетода = СокрЛП(Макет.Область("R"+к+"C1").Текст);
		
		Если ИмяМетода=WSИмяОперации тогда
			WSИмяСервиса=СокрЛП(Макет.Область("R"+к+"C2").Текст);			
			WSИмяТочкиПодключения=СокрЛП(Макет.Область("R"+к+"C3").Текст);
			WSURLWSDL=WebСервисы.Получить(Число(СокрЛП(Макет.Область("R"+к+"C4").Текст))).Значение;
			Break;
		КонецЕсли;
						
	КонецЦикла;
	
КонецФункции

Функция ПолучитьWSПрокси()
		
	WSСервис = ПолучитьWSСервис();

	WSПрокси = Новый WSПрокси(мWSОпределение, WSСервис.URIПространстваИмен, WSИмяСервиса, WSИмяТочкиПодключения);
	WSПрокси.Пользователь = Логин;
	WSПрокси.Пароль = Пароль;
	
	Возврат WSПрокси;
	
КонецФункции

Процедура ЗаполнитьЗначенияWSПараметров(СтруктураПараметров)
	
	Для каждого Параметр из СтруктураПараметров цикл
		Строка=WSПараметры.Найти(Параметр.Ключ,"Имя");
		Если Строка<>Неопределено тогда
			Строка.Значение=Параметр.Значение;	
		конецЕсли;		
	КонецЦикла;
	
КонецПроцедуры

//=======================================================================================
// ПРОЦЕДУРЫ ФУНКЦИИ МЕТОДОВ (КОМАНД)
//=======================================================================================

Процедура ВыполнитьМетодFindDetailAdv3(WSПрокси,ВозвращаемоеЗначение,Знач ДеревоРезультат,Знач Ошибка)
	
	Попытка
		
		Если ТипЗнч(ВозвращаемоеЗначение) = Тип("ОбъектXDTO") Тогда
			
			Сериализатор = Новый СериализаторXDTO(WSПрокси.ФабрикаXDTO);
			Запись = Новый ЗаписьXML;
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".xml");
			Запись.ОткрытьФайл(ИмяВременногоФайла);
			Сериализатор.Фабрика.ЗаписатьXML(Запись, ВозвращаемоеЗначение);			
			
			Запись.Закрыть();
			
			ЧтениеXML = Новый ЧтениеXML;			
			ЧтениеXML.ОткрытьФайл(ИмяВременногоФайла);
				
			ПостроительDOM=Новый ПостроительDOM;
			ДокументDOM=ПостроительDOM.Прочитать(ЧтениеXML);			
			Результат= ДокументDOM.ПолучитьЭлементыПоИмени("SoapDetailItem");
			Для Каждого Эл из Результат цикл
				СтрокаДЗ=ДеревоРезультат.Строки.Добавить();
				Для Каждого Узел из Эл.ДочерниеУзлы цикл
					СтрокаДЗ[Узел.ИмяУзла]=Узел.ТекстовоеСодержимое;     // XMLЗначение(Тип("Строка"),Узел.ИмяУзла);
				КонецЦикла ;
			КонецЦикла;
			
			ЧтениеXML.Закрыть();
			
			УдалитьФайлы(ИмяВременногоФайла);
			
			//ТаблицаРезультат=Новый ДеревоЗначений;

		Иначе
			
		КонецЕсли; 
		
	Исключение
	    СообщитьОбОшибке(ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

#Область Инициализация

ЗаполнитьWebСервисы();
Логин = 11111;
Пароль = "kjhjkh";

#КонецОбласти

#КонецЕсли