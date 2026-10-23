BEGIN TRANSACTION;
CREATE TABLE brokers (
	id INTEGER NOT NULL, 
	name TEXT NOT NULL, 
	name_norm TEXT NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT ux_brokers_name_norm UNIQUE (name_norm)
);
INSERT INTO "brokers" VALUES(1,'KC Energy Group ТОО','kc energy group тоо');
INSERT INTO "brokers" VALUES(2,'Олжа брокер ТОО','олжа брокер тоо');
INSERT INTO "brokers" VALUES(3,'ЮТС Капитал ТОО','ютс капитал тоо');
INSERT INTO "brokers" VALUES(4,'STAR OIL Energy ТОО','star oil energy тоо');
INSERT INTO "brokers" VALUES(5,'ТОО "Адалант777"','тоо "адалант777"');
INSERT INTO "brokers" VALUES(6,'Ак Алтын Ко ТОО','ак алтын ко тоо');
INSERT INTO "brokers" VALUES(7,'ТОО "TBA Group"','тоо "tba group"');
INSERT INTO "brokers" VALUES(8,'ATC Brok ТОО','atc brok тоо');
INSERT INTO "brokers" VALUES(9,'Корунд-777 ТОО','корунд-777 тоо');
INSERT INTO "brokers" VALUES(10,'АЗК АЛМАЗ ТОО','азк алмаз тоо');
INSERT INTO "brokers" VALUES(11,'FB Capital ТОО','fb capital тоо');
INSERT INTO "brokers" VALUES(12,'Torino-06 ТОО','torino-06 тоо');
INSERT INTO "brokers" VALUES(13,'Актор НС ТОО','актор нс тоо');
INSERT INTO "brokers" VALUES(14,'AMKO GROUP ТОО','amko group тоо');
INSERT INTO "brokers" VALUES(15,'ТОО "Азия Ойл"','тоо "азия ойл"');
INSERT INTO "brokers" VALUES(16,'Брокер Стандарт Плюс ТОО','брокер стандарт плюс тоо');
INSERT INTO "brokers" VALUES(17,'ТОО "Ойл"','тоо "ойл"');
INSERT INTO "brokers" VALUES(18,'ТОО «Atlas Brokerage»','тоо «atlas brokerage»');
INSERT INTO "brokers" VALUES(19,'TradeNova','tradenova');
INSERT INTO "brokers" VALUES(20,'ТОО ATC Brok','тоо atc brok');
INSERT INTO "brokers" VALUES(21,'ТОО ЖелДорСервис 2030','тоо желдорсервис 2030');
INSERT INTO "brokers" VALUES(22,'ТОО ALVANUR','тоо alvanur');
INSERT INTO "brokers" VALUES(23,'ТОО Пайдалы','тоо пайдалы');
INSERT INTO "brokers" VALUES(24,'ТОО Market & Stocs LTD','тоо market & stocs ltd');
INSERT INTO "brokers" VALUES(25,'ИП Уголь-Жаксы','ип уголь-жаксы');
INSERT INTO "brokers" VALUES(26,'ТОО Олжа брокер','тоо олжа брокер');
INSERT INTO "brokers" VALUES(27,'ТОО SMET GROUP','тоо smet group');
CREATE TABLE exchanges (
	id INTEGER NOT NULL, 
	code VARCHAR(32) NOT NULL, 
	name VARCHAR(64) NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (code)
);
INSERT INTO "exchanges" VALUES(1,'ETS','ETS');
INSERT INTO "exchanges" VALUES(2,'CASPIAN','Каспий');
CREATE TABLE parse_runs (
	id INTEGER NOT NULL, 
	source VARCHAR(32) NOT NULL, 
	started_at DATETIME NOT NULL, 
	finished_at DATETIME, 
	mode VARCHAR(32) NOT NULL, 
	status VARCHAR(16) NOT NULL, 
	records_added INTEGER NOT NULL, 
	records_seen INTEGER NOT NULL, 
	error_text TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO "parse_runs" VALUES(1,'ets','2026-10-23 11:57:27.907561','2026-10-23 11:57:55.234046','full','success',73,73,NULL);
INSERT INTO "parse_runs" VALUES(2,'caspian','2026-10-23 11:58:04.321720','2026-10-23 11:58:06.807880','full','fail',0,0,'slice indices must be integers or None or have an __index__ method');
INSERT INTO "parse_runs" VALUES(3,'ets','2026-10-23 11:58:09.990212','2026-10-23 11:58:29.828814','full','success',0,73,NULL);
INSERT INTO "parse_runs" VALUES(4,'caspian','2026-10-23 11:59:50.892434','2026-10-23 11:59:56.085134','full','success',17,17,NULL);
INSERT INTO "parse_runs" VALUES(5,'caspian','2026-10-23 11:59:59.231774','2026-10-23 12:00:02.721429','full','success',0,17,NULL);
CREATE TABLE participants (
	id INTEGER NOT NULL, 
	name TEXT NOT NULL, 
	bin VARCHAR(16), 
	name_norm TEXT NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO "participants" VALUES(1,'KC Energy Group ТОО','231240026921','kc energy group тоо');
INSERT INTO "participants" VALUES(2,'ТОО «Барс Трейд Ойл»','040240000509','тоо «барс трейд ойл»');
INSERT INTO "participants" VALUES(3,'ТОО "Alem-Oil"','010940006647','тоо "alem-oil"');
INSERT INTO "participants" VALUES(4,'ТОО «Траст Петролеум»','180840020098','тоо «траст петролеум»');
INSERT INTO "participants" VALUES(5,'STAR OIL Energy ТОО','130640000641','star oil energy тоо');
INSERT INTO "participants" VALUES(6,'ТОО "Тараз- Петрол- Сервис"','011040010040','тоо "тараз- петрол- сервис"');
INSERT INTO "participants" VALUES(7,'ТОО «KAZ Oil Service»','150140023785','тоо «kaz oil service»');
INSERT INTO "participants" VALUES(8,'ТОО TREND ENERGY','230440043193','тоо trend energy');
INSERT INTO "participants" VALUES(9,'HALYK PETROLEUM','240640030507','halyk petroleum');
INSERT INTO "participants" VALUES(10,'ТОО "Almara Petroleum"','220640012852','тоо "almara petroleum"');
INSERT INTO "participants" VALUES(11,'ABI Petro group','240440005449','abi petro group');
INSERT INTO "participants" VALUES(12,'АЗК АЛМАЗ ТОО','011240001881','азк алмаз тоо');
INSERT INTO "participants" VALUES(13,'ТОО «ПетроКазахстан Ойл Продактс»','050140004649','тоо «петроказахстан ойл продактс»');
INSERT INTO "participants" VALUES(14,'ТОО "ТумарМунай"','130640000443','тоо "тумармунай"');
INSERT INTO "participants" VALUES(15,'ТОО "Каспий нефть трейдинг"','190640003062','тоо "каспий нефть трейдинг"');
INSERT INTO "participants" VALUES(16,'АО "Эйр Астана','010940000162','ао "эйр астана');
INSERT INTO "participants" VALUES(17,'"ХЕЛИКОН ТРЕЙДИНГ" ТОО','231140035441','"хеликон трейдинг" тоо');
INSERT INTO "participants" VALUES(18,'ИП Барно','810607402537','ип барно');
INSERT INTO "participants" VALUES(19,'ТОО СахарПром-Казахстан','170540013469','тоо сахарпром-казахстан');
INSERT INTO "participants" VALUES(20,'ИП АЛГЫС','890417301009','ип алгыс');
INSERT INTO "participants" VALUES(21,'ТОО "Азия Ойл"','091140014339','тоо "азия ойл"');
INSERT INTO "participants" VALUES(22,'ИП Ауезов А.Б.','810328301239','ип ауезов а.б.');
INSERT INTO "participants" VALUES(23,'ИП Надирбеков Б.К.','630911301626','ип надирбеков б.к.');
INSERT INTO "participants" VALUES(24,'ТОО "Ойл"','960640000029','тоо "ойл"');
INSERT INTO "participants" VALUES(25,'ТОО "Gold oil group"','260940008377','тоо "gold oil group"');
INSERT INTO "participants" VALUES(26,'ТОО "СП "ЮГХК"','140840001183','тоо "сп "югхк"');
INSERT INTO "participants" VALUES(27,'ИП ПОВАЛЯЕВ ДМИТРИЙ АНАТОЛЬЕВИЧ','731125350010','ип поваляев дмитрий анатольевич');
INSERT INTO "participants" VALUES(28,'ТОО "Кызылкум"','050540001926','тоо "кызылкум"');
INSERT INTO "participants" VALUES(29,'ТОО ""Resource Fusion""','250440026107','тоо ""resource fusion""');
INSERT INTO "participants" VALUES(30,'ТОО "Petro Asia Trading"','260540003480','тоо "petro asia trading"');
INSERT INTO "participants" VALUES(31,'Zenith Energy','240540017417','zenith energy');
INSERT INTO "participants" VALUES(32,'ТОО "Азия Нефтепродукт"','150340023316','тоо "азия нефтепродукт"');
INSERT INTO "participants" VALUES(33,'OilPro Trading','231040031851','oilpro trading');
INSERT INTO "participants" VALUES(34,'ТОО "Alim Group"','140740008692','тоо "alim group"');
INSERT INTO "participants" VALUES(35,'AmanZholl Petroleum','240640029058','amanzholl petroleum');
INSERT INTO "participants" VALUES(36,'ТОО «SP Group»','030440006038','тоо «sp group»');
INSERT INTO "participants" VALUES(37,'ТОО «Petro Trading»','131140007099','тоо «petro trading»');
INSERT INTO "participants" VALUES(38,'ТОО Глори Трэйд','181040023720','тоо глори трэйд');
INSERT INTO "participants" VALUES(39,'ТОО "Коксуский сахарный завод"','150240026911','тоо "коксуский сахарный завод"');
INSERT INTO "participants" VALUES(40,'ТОО «МУКОТ»','120140018377','тоо «мукот»');
INSERT INTO "participants" VALUES(41,'ТОО Производственная компания Цементный завод Семей','021240000022','тоо производственная компания цементный завод семей');
INSERT INTO "participants" VALUES(42,'ТОО "Казцинк"','970140000211','тоо "казцинк"');
INSERT INTO "participants" VALUES(43,'АО Шубарколь Премиум','130440022185','ао шубарколь премиум');
INSERT INTO "participants" VALUES(44,'ИП Уголь-Жаксы','910820350511','ип уголь-жаксы');
INSERT INTO "participants" VALUES(45,'АО Майкубен-Вест','050940003769','ао майкубен-вест');
INSERT INTO "participants" VALUES(46,'ТОО ЖелДорСервис 2030','120440016877','тоо желдорсервис 2030');
INSERT INTO "participants" VALUES(47,'ТОО Производственная компания Цементный завод Семей 02124000002…',NULL,'тоо производственная компания цементный завод семей 02124000002…');
INSERT INTO "participants" VALUES(48,'ИП Караваев Сергей Владимирович','931127350628','ип караваев сергей владимирович');
INSERT INTO "participants" VALUES(49,'ТОО Terminal BS','190240008584','тоо terminal bs');
INSERT INTO "participants" VALUES(50,'ТОО Астана Инерт плюс','080840003631','тоо астана инерт плюс');
INSERT INTO "participants" VALUES(51,'ГКП на праве хозяйственного ведения "Қосшы-Жылу" при акимате го…',NULL,'гкп на праве хозяйственного ведения "қосшы-жылу" при акимате го…');
INSERT INTO "participants" VALUES(52,'ТОО РОМАНА-ГРУПП','170140010093','тоо романа-групп');
INSERT INTO "participants" VALUES(53,'ТОО BARS TECHNOLODGIES','160840017996','тоо bars technolodgies');
INSERT INTO "participants" VALUES(54,'ТОО Бастау','990740000613','тоо бастау');
CREATE TABLE products (
	id INTEGER NOT NULL, 
	name TEXT NOT NULL, 
	product_code VARCHAR(64), 
	tnved_code VARCHAR(32), 
	name_norm TEXT NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO "products" VALUES(1,'д транспортом','D3DE1EA','2710124130','д транспортом');
INSERT INTO "products" VALUES(2,'kolikpen/Бензин АИ-92 ТОО ПНХЗ, FCA ст. Павлодар-порт, поставка только ж/д/ транспортом','D3DE1SP','2710124130','kolikpen/бензин аи-92 тоо пнхз, fca ст. павлодар-порт, поставка только ж/д/ транспортом');
INSERT INTO "products" VALUES(3,'Бензин АИ-92 ТОО ПКОП, FCA ст. Текесу, поставка только ж/д транспортом','D3DE1TO','2710124130','бензин аи-92 тоо пкоп, fca ст. текесу, поставка только ж/д транспортом');
INSERT INTO "products" VALUES(4,'Бензин АИ-95 ТОО ПКОП,FCA ст.Текесу,поставка только ж/д транспортом','D6DE1TO','2710124500','бензин аи-95 тоо пкоп,fca ст.текесу,поставка только ж/д транспортом');
INSERT INTO "products" VALUES(5,'д транспортом','D6DE1SP','2710124500','д транспортом');
INSERT INTO "products" VALUES(6,'Топливо для реактив двиг TC-1, ТОО АНПЗ, FCA, СТ. ТЕНДЫК, поставка ж/д','DTDFCEA','2710192100','топливо для реактив двиг tc-1, тоо анпз, fca, ст. тендык, поставка ж/д');
INSERT INTO "products" VALUES(7,'Топливо для реак двиг марки ТС-1,ТОО ПКОП,FCA,ст.Текесу,только ж/д','DADFCTO','2710192100','топливо для реак двиг марки тс-1,тоо пкоп,fca,ст.текесу,только ж/д');
INSERT INTO "products" VALUES(8,'Топливо д/ реакт двиг марки РТ,ТОО ПНХЗ,FCA,ст.Павлодар-порт,поставка то','DADFCSP','2710192100','топливо д/ реакт двиг марки рт,тоо пнхз,fca,ст.павлодар-порт,поставка то');
INSERT INTO "products" VALUES(9,'сахар белый, условия поставки FCA Жамбылская область','UWDFC08','1701','сахар белый, условия поставки fca жамбылская область');
INSERT INTO "products" VALUES(10,'сахар белый,EXW г.Алматы (мкр.Рахат 224А,склад №7)','UWDEX02','1701','сахар белый,exw г.алматы (мкр.рахат 224а,склад №7)');
INSERT INTO "products" VALUES(11,'Топливо дизельное марки ДТ-Е-K4 ТОО ПКОП,FCA ст.Текесу,базис поставки - только ж','DEDF4TO','2710194240','топливо дизельное марки дт-е-k4 тоо пкоп,fca ст.текесу,базис поставки - только ж');
INSERT INTO "products" VALUES(12,'топливо дизельное зимнее, DDP Туркестанская обл., Сузакский район, рудник Южный Инкай','DRDDDTI','2710194220','топливо дизельное зимнее, ddp туркестанская обл., сузакский район, рудник южный инкай');
INSERT INTO "products" VALUES(13,'сахар белый, условия поставки FCA Акмолинская область','UWDFC03','1701','сахар белый, условия поставки fca акмолинская область');
INSERT INTO "products" VALUES(14,'Дизельное топливо зимнее,DDP Кызылординская обл, Жанакорганский район','DRDDDNH','2710194220','дизельное топливо зимнее,ddp кызылординская обл, жанакорганский район');
INSERT INTO "products" VALUES(15,'сахар белый, условия поставки EXW','UWDEXWA','1701','сахар белый, условия поставки exw');
INSERT INTO "products" VALUES(16,'Цемент ЦЕМ II А-Ш 425 Н DDP ВКО для Малеевского','EUDD16M','2523','цемент цем ii а-ш 425 н ddp вко для малеевского');
INSERT INTO "products" VALUES(17,'Цемент ЦЕМ II А-Ш 425 Н DDP ВКО для Риддер-Сокольного','EUDD16R','2523','цемент цем ii а-ш 425 н ddp вко для риддер-сокольного');
INSERT INTO "products" VALUES(18,'Цемент ЦЕМ II А-Ш 425 Н DDP ВКО для Долинного','EUDD16D','2523','цемент цем ii а-ш 425 н ddp вко для долинного');
INSERT INTO "products" VALUES(19,'уголь Д 10-80 мм АО Шубарколь Прем. FCA ст. Шубарколь на Акмолинскую обл T+3 мес','AD103H3','2701','уголь д 10-80 мм ао шубарколь прем. fca ст. шубарколь на акмолинскую обл t+3 мес');
INSERT INTO "products" VALUES(20,'уголь Д 10-80 мм АО Шубарколь Прем. FCA ст. Шубарколь на СКО T+3 мес.','AD115H3','2701','уголь д 10-80 мм ао шубарколь прем. fca ст. шубарколь на ско t+3 мес.');
INSERT INTO "products" VALUES(21,'кг, Sd (Массовая доля общей серы состояние), 0,40 - 1,40%, Аd (зольность на сухое состояние), не более 28%, W1 (массовая доля общей влаги в рабочем состоянии) 22,0 – 18,0, Vda (выход летучих веществ на сухое беззольное состояние), 40 – 48% Массовая доля кусков размером не более 300 мм. СТ. РК 1689-1-2012',NULL,'2701','кг, sd (массовая доля общей серы состояние), 0,40 - 1,40%, аd (зольность на сухое состояние), не более 28%, w1 (массовая доля общей влаги в рабочем состоянии) 22,0 – 18,0, vda (выход летучих веществ на сухое беззольное состояние), 40 – 48% массовая доля кусков размером не более 300 мм. ст. рк 1689-1-2012');
INSERT INTO "products" VALUES(22,'А-П',NULL,'2523','а-п');
INSERT INTO "products" VALUES(23,'Цемент марки ЦЕМ I',NULL,'2523','цемент марки цем i');
INSERT INTO "products" VALUES(24,'Уголь Бурый',NULL,'2702','уголь бурый');
CREATE TABLE trades (
	id INTEGER NOT NULL, 
	dedup_key VARCHAR(64) NOT NULL, 
	exchange_id INTEGER NOT NULL, 
	trade_date DATE NOT NULL, 
	trade_time VARCHAR(16), 
	product_id INTEGER, 
	seller_id INTEGER, 
	buyer_id INTEGER, 
	seller_broker_id INTEGER, 
	buyer_broker_id INTEGER, 
	volume FLOAT, 
	unit VARCHAR(16), 
	price FLOAT, 
	price_vat VARCHAR(16), 
	amount FLOAT, 
	delivery_place TEXT, 
	delivery_term TEXT, 
	deals_count INTEGER, 
	source_url TEXT, 
	raw_hash VARCHAR(64), 
	created_at DATETIME NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (dedup_key), 
	FOREIGN KEY(exchange_id) REFERENCES exchanges (id), 
	FOREIGN KEY(product_id) REFERENCES products (id), 
	FOREIGN KEY(seller_id) REFERENCES participants (id), 
	FOREIGN KEY(buyer_id) REFERENCES participants (id), 
	FOREIGN KEY(seller_broker_id) REFERENCES brokers (id), 
	FOREIGN KEY(buyer_broker_id) REFERENCES brokers (id)
);
INSERT INTO "trades" VALUES(1,'162e6821b8c59645ebeaa88f908aeb71c7585dc690fe129e43709aedecaa880e',1,'2026-10-13',NULL,1,1,2,1,2,390.0,'т',242736.66,NULL,94667297.4,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','162e6821b8c59645ebeaa88f908aeb71c7585dc690fe129e43709aedecaa880e','2026-10-23 11:57:55.108513');
INSERT INTO "trades" VALUES(2,'bc38ff35c2500ce65fe0c766c1b309630b62a8b65a8d8e8db6c6405626d505df',1,'2026-10-13',NULL,2,1,3,1,2,585.0,'т',277278.66,NULL,162208016.1,'FCA ст. Павлодар-порт, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','bc38ff35c2500ce65fe0c766c1b309630b62a8b65a8d8e8db6c6405626d505df','2026-10-23 11:57:55.111175');
INSERT INTO "trades" VALUES(3,'a20ed75225ce8d9ab4baf7bfb964be28677caa6d9ad5b802b930796efd89ae6f',1,'2026-10-13',NULL,1,1,4,1,3,390.0,'т',240333.34,NULL,93730002.6,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','a20ed75225ce8d9ab4baf7bfb964be28677caa6d9ad5b802b930796efd89ae6f','2026-10-23 11:57:55.113373');
INSERT INTO "trades" VALUES(4,'171fe2bb2d49dc7114a36061d73a75531e8fd4ab42427f22e939118527d6fa46',1,'2026-10-13',NULL,2,1,5,1,4,390.0,'т',277278.66,NULL,108138677.4,'FCA ст. Павлодар-порт, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','171fe2bb2d49dc7114a36061d73a75531e8fd4ab42427f22e939118527d6fa46','2026-10-23 11:57:55.114762');
INSERT INTO "trades" VALUES(5,'f63a6b41285d416c79cb8d6e98d6e99be62cd9e85d8dd2a2ec434bcb6191e646',1,'2026-10-13',NULL,3,1,6,1,2,195.0,'т',278086.66,NULL,54226898.7,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','f63a6b41285d416c79cb8d6e98d6e99be62cd9e85d8dd2a2ec434bcb6191e646','2026-10-23 11:57:55.116767');
INSERT INTO "trades" VALUES(6,'46a7fbe5edcedd980df277f569b4eb5721582968f77fde4c9215ce8f05435e59',1,'2026-10-13',NULL,3,1,7,1,5,780.0,'т',278086.66,NULL,216907594.8,'FCA ст. Текесу, поставка только ж',NULL,4,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','46a7fbe5edcedd980df277f569b4eb5721582968f77fde4c9215ce8f05435e59','2026-10-23 11:57:55.118886');
INSERT INTO "trades" VALUES(7,'17b692ec12f99a71b2e078a4f74925295cbbe3720624c6c7c99ef538f989d324',1,'2026-10-13',NULL,3,1,8,1,6,390.0,'т',278086.66,NULL,108453797.4,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','17b692ec12f99a71b2e078a4f74925295cbbe3720624c6c7c99ef538f989d324','2026-10-23 11:57:55.120819');
INSERT INTO "trades" VALUES(8,'69de403a19e635394aa3cbacecb35e82ae4718aa1000b746c883603225537f18',1,'2026-10-13',NULL,3,1,9,1,7,390.0,'т',278086.66,NULL,108453797.4,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','69de403a19e635394aa3cbacecb35e82ae4718aa1000b746c883603225537f18','2026-10-23 11:57:55.122456');
INSERT INTO "trades" VALUES(9,'31ed5bd3ac6b1717c2a4e00c3d70a2c95c5c8825de2c20bbd27653bd07854c2a',1,'2026-10-13',NULL,3,1,10,1,8,390.0,'т',278086.66,NULL,108453797.4,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','31ed5bd3ac6b1717c2a4e00c3d70a2c95c5c8825de2c20bbd27653bd07854c2a','2026-10-23 11:57:55.124107');
INSERT INTO "trades" VALUES(10,'e43e4c292dce25679ecce6faa59e76b2dffae855502389f9ea874587bcb53b1e',1,'2026-10-13',NULL,3,1,11,1,9,260.0,'т',278086.66,NULL,72302531.6,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','e43e4c292dce25679ecce6faa59e76b2dffae855502389f9ea874587bcb53b1e','2026-10-23 11:57:55.125628');
INSERT INTO "trades" VALUES(11,'b38950d823bc5d57c4991215a64628496bac0c3c811d907796e80bdbb6a9b034',1,'2026-10-13',NULL,4,1,12,1,10,390.0,'т',338902.8,NULL,132172092.0,'FCA ст.Текесу,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','b38950d823bc5d57c4991215a64628496bac0c3c811d907796e80bdbb6a9b034','2026-10-23 11:57:55.129649');
INSERT INTO "trades" VALUES(12,'fdcd8ea3b0e14fd5c69047f87852ed040b0dda45296338e474970e47c800d4a2',1,'2026-10-13',NULL,4,1,12,1,2,130.0,'т',338902.8,NULL,44057364.0,'FCA ст.Текесу,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','fdcd8ea3b0e14fd5c69047f87852ed040b0dda45296338e474970e47c800d4a2','2026-10-23 11:57:55.129652');
INSERT INTO "trades" VALUES(13,'d74eaa3b0a9d11dc4b4a79ea814e91ca1221f00f49b3ec00eb54f4dcf5627edb',1,'2026-10-13',NULL,3,13,11,11,9,65.0,'т',278086.66,NULL,18075632.9,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','d74eaa3b0a9d11dc4b4a79ea814e91ca1221f00f49b3ec00eb54f4dcf5627edb','2026-10-23 11:57:55.131621');
INSERT INTO "trades" VALUES(14,'789f8790146cd9748fab89e820c024b7de71eec872ddff7d77ae44455ef62f3b',1,'2026-10-13',NULL,5,1,14,1,12,325.0,'т',330000.0,NULL,107250000.0,'FCA ст.Павлодар-порт,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','789f8790146cd9748fab89e820c024b7de71eec872ddff7d77ae44455ef62f3b','2026-10-23 11:57:55.134286');
INSERT INTO "trades" VALUES(15,'ccf1794b9f3866dec3aa8213e2154d4d673cce9f035b600c35e428a1fee9d092',1,'2026-10-13',NULL,1,15,2,11,2,130.0,'т',240700.0,NULL,31291000.0,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','ccf1794b9f3866dec3aa8213e2154d4d673cce9f035b600c35e428a1fee9d092','2026-10-23 11:57:55.137078');
INSERT INTO "trades" VALUES(16,'cd1047818f750977b2a3605da087030238f735295ec6afa0da119a7128bf7c29',1,'2026-10-13',NULL,1,15,4,11,3,130.0,'т',240333.34,NULL,31243334.2,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','cd1047818f750977b2a3605da087030238f735295ec6afa0da119a7128bf7c29','2026-10-23 11:57:55.137081');
INSERT INTO "trades" VALUES(17,'a78b4d4c657bf3526bbc864eec72ebb0f4758e0c468c8b3b5e745e9c95fa5cdc',1,'2026-10-13',NULL,6,1,16,1,8,130.0,'т',503666.67,NULL,65476667.1,'FCA, СТ. ТЕНДЫК, поставка ж',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','a78b4d4c657bf3526bbc864eec72ebb0f4758e0c468c8b3b5e745e9c95fa5cdc','2026-10-23 11:57:55.138989');
INSERT INTO "trades" VALUES(18,'cf114a459be56ff8b6325512d78a442bbed6757901807765af1b74974cf7191a',1,'2026-10-13',NULL,7,1,16,1,8,520.0,'т',503000.0,NULL,261560000.0,'FCA,ст.Текесу,только ж',NULL,3,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','cf114a459be56ff8b6325512d78a442bbed6757901807765af1b74974cf7191a','2026-10-23 11:57:55.140694');
INSERT INTO "trades" VALUES(19,'9555df79b0b6a94a0c94218a7120857cad761af494492a0faf279032b78a221e',1,'2026-10-13',NULL,8,1,16,1,8,195.0,'т',505666.67,NULL,98605000.65,'FCA,ст.Павлодар-порт,поставка то',NULL,1,'https://ets.kz/upload/iblock/363/iey2h0zuvh0ej5kg3af7dhwndqxk4b7a.xlsx','9555df79b0b6a94a0c94218a7120857cad761af494492a0faf279032b78a221e','2026-10-23 11:57:55.142446');
INSERT INTO "trades" VALUES(20,'d760e0740089ab2a09a48ec90706d114e570203f7a9283cfe130d987d5f29e43',1,'2026-10-14',NULL,9,17,18,13,14,136.0,'т',300000.0,NULL,40800000.0,'FCA Жамбылская область',NULL,1,'https://ets.kz/upload/iblock/52d/aa1jiw3gin8msg0ffmg2o80qhqtalkja.xlsx','d760e0740089ab2a09a48ec90706d114e570203f7a9283cfe130d987d5f29e43','2026-10-23 11:57:55.144721');
INSERT INTO "trades" VALUES(21,'6985df7b3f49a7a2917ed9fc4f6aada113e668fa39daa2a835bde21531c2cad8',1,'2026-10-14',NULL,10,19,20,11,14,100.0,'т',325000.0,NULL,32500000.0,'EXW г.Алматы (мкр.Рахат 224А,склад №7)',NULL,1,'https://ets.kz/upload/iblock/52d/aa1jiw3gin8msg0ffmg2o80qhqtalkja.xlsx','6985df7b3f49a7a2917ed9fc4f6aada113e668fa39daa2a835bde21531c2cad8','2026-10-23 11:57:55.147227');
INSERT INTO "trades" VALUES(22,'3f19d8622a8504d884fb5fb1e39493349999de934fe50f901b8dd86fb08e66cf',1,'2026-10-15',NULL,1,15,21,11,15,65.0,'т',240333.33,NULL,15621666.45,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','3f19d8622a8504d884fb5fb1e39493349999de934fe50f901b8dd86fb08e66cf','2026-10-23 11:57:55.150847');
INSERT INTO "trades" VALUES(23,'4758129a2b4b07915268f197ed39a8c72709ac07806c0fd99927345df93ba9f8',1,'2026-10-15',NULL,3,1,12,1,6,390.0,'т',280867.52,NULL,109538332.8,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','4758129a2b4b07915268f197ed39a8c72709ac07806c0fd99927345df93ba9f8','2026-10-23 11:57:55.150849');
INSERT INTO "trades" VALUES(24,'8f93e861d76b7f39e501a3f078083d561dd7639206cc65e726f156afb17b8199',1,'2026-10-15',NULL,3,1,22,1,5,390.0,'т',280867.52,NULL,109538332.8,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','8f93e861d76b7f39e501a3f078083d561dd7639206cc65e726f156afb17b8199','2026-10-23 11:57:55.156387');
INSERT INTO "trades" VALUES(25,'570efd7fc7146ab7cb1b6e9865dc748164733a8e3fa8daeafacdc8a5c8829395',1,'2026-10-15',NULL,3,1,8,1,8,390.0,'т',280867.52,NULL,109538332.8,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','570efd7fc7146ab7cb1b6e9865dc748164733a8e3fa8daeafacdc8a5c8829395','2026-10-23 11:57:55.156390');
INSERT INTO "trades" VALUES(26,'cf3092370271b6aad44e505d565565911fcfee80e8b126e5e3a5cd01c392368d',1,'2026-10-15',NULL,3,1,7,1,5,130.0,'т',280867.52,NULL,36512777.6,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','cf3092370271b6aad44e505d565565911fcfee80e8b126e5e3a5cd01c392368d','2026-10-23 11:57:55.156391');
INSERT INTO "trades" VALUES(27,'3b4e19918d96550fd2d195af7ff0068bae88ed16e2cf83bd0dad7b3c9624da99',1,'2026-10-15',NULL,3,1,12,1,10,390.0,'т',280867.52,NULL,109538332.8,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','3b4e19918d96550fd2d195af7ff0068bae88ed16e2cf83bd0dad7b3c9624da99','2026-10-23 11:57:55.156392');
INSERT INTO "trades" VALUES(28,'14b9905fe05608c4a69d198bee4dd28cec96fcdffc99d371b2fa311fba1f61a8',1,'2026-10-15',NULL,3,1,23,1,16,325.0,'т',280867.52,NULL,91281944.0,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','14b9905fe05608c4a69d198bee4dd28cec96fcdffc99d371b2fa311fba1f61a8','2026-10-23 11:57:55.164369');
INSERT INTO "trades" VALUES(29,'6b6f947232734a043bb18e024edfeb467c252cd30524433eecb31166cd13f5a6',1,'2026-10-15',NULL,3,1,8,1,6,390.0,'т',280867.52,NULL,109538332.8,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','6b6f947232734a043bb18e024edfeb467c252cd30524433eecb31166cd13f5a6','2026-10-23 11:57:55.164372');
INSERT INTO "trades" VALUES(30,'9d3dc4673122688bcfde175cff8b9771ea9b30ee25ac353290fa449ad89b8d4d',1,'2026-10-15',NULL,3,13,12,11,8,65.0,'т',280867.52,NULL,18256388.8,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','9d3dc4673122688bcfde175cff8b9771ea9b30ee25ac353290fa449ad89b8d4d','2026-10-23 11:57:55.164373');
INSERT INTO "trades" VALUES(31,'d1a6b023ad1838bf05d68abf014de7ee1d321fd9c163b1252fe3b82eb0f7014b',1,'2026-10-15',NULL,4,13,6,11,2,65.0,'т',338902.8,NULL,22028682.0,'FCA ст.Текесу,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','d1a6b023ad1838bf05d68abf014de7ee1d321fd9c163b1252fe3b82eb0f7014b','2026-10-23 11:57:55.164374');
INSERT INTO "trades" VALUES(32,'fac2801046a87f3d2d14ff042f7314dd442c9f46b2923459e1cbb80eef197995',1,'2026-10-15',NULL,4,1,6,1,2,65.0,'т',335547.33,NULL,21810576.45,'FCA ст.Текесу,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','fac2801046a87f3d2d14ff042f7314dd442c9f46b2923459e1cbb80eef197995','2026-10-23 11:57:55.164375');
INSERT INTO "trades" VALUES(33,'dc2d4f078bd8aac663f3589a4c1f80b25b2a98792fd6776b7aeb654ae5528c49',1,'2026-10-15',NULL,2,1,21,1,15,65.0,'т',274533.33,NULL,17844666.45,'FCA ст. Павлодар-порт, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','dc2d4f078bd8aac663f3589a4c1f80b25b2a98792fd6776b7aeb654ae5528c49','2026-10-23 11:57:55.164375');
INSERT INTO "trades" VALUES(34,'31b5c6a0650049ab4ff87954a0fa80629890b1873727c6c0c1e1a067489f1196',1,'2026-10-15',NULL,1,1,24,1,17,390.0,'т',235526.66,NULL,91855397.4,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','31b5c6a0650049ab4ff87954a0fa80629890b1873727c6c0c1e1a067489f1196','2026-10-23 11:57:55.172346');
INSERT INTO "trades" VALUES(35,'73cad6df0150bbb24ab7787a9b199d93209ba59246b426b3a9a5e267bea190ab',1,'2026-10-15',NULL,5,1,3,1,2,130.0,'т',323500.0,NULL,42055000.0,'FCA ст.Павлодар-порт,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','73cad6df0150bbb24ab7787a9b199d93209ba59246b426b3a9a5e267bea190ab','2026-10-23 11:57:55.172349');
INSERT INTO "trades" VALUES(36,'00c99b73fc6b2d278f80cbf20a2e5aeb0072cb829b580326dc2eae6a7af00a99',1,'2026-10-15',NULL,2,1,24,1,17,520.0,'т',269042.66,NULL,139902183.2,'FCA ст. Павлодар-порт, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','00c99b73fc6b2d278f80cbf20a2e5aeb0072cb829b580326dc2eae6a7af00a99','2026-10-23 11:57:55.172350');
INSERT INTO "trades" VALUES(37,'6ea616307f5c526912dd369fbc3e899dc09aa688f1a36f1268595fa5ff5c249d',1,'2026-10-15',NULL,8,1,16,1,8,260.0,'т',505666.67,NULL,131473334.2,'FCA,ст.Павлодар-порт,поставка то',NULL,2,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','6ea616307f5c526912dd369fbc3e899dc09aa688f1a36f1268595fa5ff5c249d','2026-10-23 11:57:55.172351');
INSERT INTO "trades" VALUES(38,'3f83fbe6bd02015206106ee17605737d11d6401221232476b0fc56813b69068c',1,'2026-10-15',NULL,7,1,16,1,8,455.0,'т',503000.0,NULL,228865000.0,'FCA,ст.Текесу,только ж',NULL,3,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','3f83fbe6bd02015206106ee17605737d11d6401221232476b0fc56813b69068c','2026-10-23 11:57:55.172352');
INSERT INTO "trades" VALUES(39,'38f748299129a886cb8a114f453d70cb12f817a76bf12ce05c16b3dd0fc3a64d',1,'2026-10-15',NULL,6,1,16,1,8,65.0,'т',503666.67,NULL,32738333.55,'FCA, СТ. ТЕНДЫК, поставка ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','38f748299129a886cb8a114f453d70cb12f817a76bf12ce05c16b3dd0fc3a64d','2026-10-23 11:57:55.172353');
INSERT INTO "trades" VALUES(40,'d02e9cc59f6c61d1f1e66a51bd108c817bca8472e3f550881c351aa2aa844496',1,'2026-10-15',NULL,11,13,22,11,5,65.0,'т',352692.0,NULL,22924980.0,'FCA ст.Текесу,базис поставки - только ж',NULL,1,'https://ets.kz/upload/iblock/e76/zrje73x6u3uhr3aff0yiltrbq58z4ipt.xlsx','d02e9cc59f6c61d1f1e66a51bd108c817bca8472e3f550881c351aa2aa844496','2026-10-23 11:57:55.174286');
INSERT INTO "trades" VALUES(41,'dc6a6b2fc306c38fd22aa29a89cfa85791cc4d4cdfd751fe176c22b591e8b5fa',1,'2026-10-16',NULL,12,25,26,16,11,120000.0,'т',517.0,NULL,62040000.0,'DDP Туркестанская обл., Сузакский район, рудник Южный Инкай',NULL,1,'https://ets.kz/upload/iblock/01d/6542h3xsnwq3ov4d3ul51kl2pqjbgbpx.xlsx','dc6a6b2fc306c38fd22aa29a89cfa85791cc4d4cdfd751fe176c22b591e8b5fa','2026-10-23 11:57:55.176404');
INSERT INTO "trades" VALUES(42,'fde9af345d851443ebdf91aebaf6c1677e9dd3eb5f5370e84f627f410e5a3794',1,'2026-10-16',NULL,13,17,27,13,14,68.0,'т',305000.0,NULL,20740000.0,'FCA Акмолинская область',NULL,1,'https://ets.kz/upload/iblock/01d/6542h3xsnwq3ov4d3ul51kl2pqjbgbpx.xlsx','fde9af345d851443ebdf91aebaf6c1677e9dd3eb5f5370e84f627f410e5a3794','2026-10-23 11:57:55.178213');
INSERT INTO "trades" VALUES(43,'7fa32783523537ea6672840d6d7bb7fc943a3c4696f1cb7fbb618fda6035569a',1,'2026-10-19',NULL,14,25,28,16,11,228056.0,'т',456.8,NULL,104175980.8,'DDP Кызылординская обл, Жанакорганский район',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','7fa32783523537ea6672840d6d7bb7fc943a3c4696f1cb7fbb618fda6035569a','2026-10-23 11:57:55.181848');
INSERT INTO "trades" VALUES(44,'76e392e1dae4854da6f10f1789db0ce8e1793bb74590bd62707dd4f117613d39',1,'2026-10-19',NULL,2,1,29,1,8,520.0,'т',271733.08,NULL,141301201.6,'FCA ст. Павлодар-порт, поставка только ж',NULL,3,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','76e392e1dae4854da6f10f1789db0ce8e1793bb74590bd62707dd4f117613d39','2026-10-23 11:57:55.183960');
INSERT INTO "trades" VALUES(45,'f4ab88c05026b6258dd4a93e40a2597a90d52401dd3538aac17a6dd94578eab8',1,'2026-10-19',NULL,2,1,30,1,18,390.0,'т',271733.08,NULL,105975901.2,'FCA ст. Павлодар-порт, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','f4ab88c05026b6258dd4a93e40a2597a90d52401dd3538aac17a6dd94578eab8','2026-10-23 11:57:55.185987');
INSERT INTO "trades" VALUES(46,'f869353881e2cdd3b988a6fd4cf6d5d93528897455862fff3497e55c525cbd0d',1,'2026-10-19',NULL,3,1,31,1,9,390.0,'т',283676.19,NULL,110633714.1,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','f869353881e2cdd3b988a6fd4cf6d5d93528897455862fff3497e55c525cbd0d','2026-10-23 11:57:55.188810');
INSERT INTO "trades" VALUES(47,'f83818619ee27846aebafc1aa5d18f10e53c6ef8ccb7819b66338a5a5c21dce8',1,'2026-10-19',NULL,3,1,32,1,2,260.0,'т',283676.19,NULL,73755809.4,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','f83818619ee27846aebafc1aa5d18f10e53c6ef8ccb7819b66338a5a5c21dce8','2026-10-23 11:57:55.191044');
INSERT INTO "trades" VALUES(48,'6209ebf9ce2e4b2bb0688c2b3c30279bdf7d161be029e3761f5c55f8012e1696',1,'2026-10-19',NULL,3,1,33,1,7,390.0,'т',283676.19,NULL,110633714.1,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','6209ebf9ce2e4b2bb0688c2b3c30279bdf7d161be029e3761f5c55f8012e1696','2026-10-23 11:57:55.192676');
INSERT INTO "trades" VALUES(49,'c546940376925588d32971cc666bc24e85891020dae1cf97bb417cac48b07c36',1,'2026-10-19',NULL,3,1,34,1,7,390.0,'т',283676.19,NULL,110633714.1,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','c546940376925588d32971cc666bc24e85891020dae1cf97bb417cac48b07c36','2026-10-23 11:57:55.196373');
INSERT INTO "trades" VALUES(50,'dfdadcdf058a04ff81dc71d1e7c120ae6937a26b0d6481e163af753bf343d209',1,'2026-10-19',NULL,3,1,10,1,8,390.0,'т',283676.19,NULL,110633714.1,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','dfdadcdf058a04ff81dc71d1e7c120ae6937a26b0d6481e163af753bf343d209','2026-10-23 11:57:55.196376');
INSERT INTO "trades" VALUES(51,'fa2470783fe0da3902e7d17367c4cedab9c62500d2e2d4a543ffb553a2d678bb',1,'2026-10-19',NULL,3,1,35,1,9,325.0,'т',283676.19,NULL,92194761.75,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','fa2470783fe0da3902e7d17367c4cedab9c62500d2e2d4a543ffb553a2d678bb','2026-10-23 11:57:55.200463');
INSERT INTO "trades" VALUES(52,'b6d5536c73303ac18ea1fc3ec4c38ecef72b723f85c47b3cc6a8deb4ef4f39ca',1,'2026-10-19',NULL,2,1,14,1,12,390.0,'т',271733.08,NULL,105975901.2,'FCA ст. Павлодар-порт, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','b6d5536c73303ac18ea1fc3ec4c38ecef72b723f85c47b3cc6a8deb4ef4f39ca','2026-10-23 11:57:55.200465');
INSERT INTO "trades" VALUES(53,'36946396729a6dbd0bcafe469bc1aafb407314c649c0881371bdb6c022cfe0c8',1,'2026-10-19',NULL,2,1,5,1,4,65.0,'т',271733.08,NULL,17662650.2,'FCA ст. Павлодар-порт, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','36946396729a6dbd0bcafe469bc1aafb407314c649c0881371bdb6c022cfe0c8','2026-10-23 11:57:55.200466');
INSERT INTO "trades" VALUES(54,'96ac0fe0e352e1cbc338f97c78ce2f967c5946d587d8605618813fed67aa1217',1,'2026-10-19',NULL,1,1,36,1,8,65.0,'т',235526.66,NULL,15309232.9,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','96ac0fe0e352e1cbc338f97c78ce2f967c5946d587d8605618813fed67aa1217','2026-10-23 11:57:55.202444');
INSERT INTO "trades" VALUES(55,'9ca046c9e87f50d8024824e1df474839380708b96bb8e6be85b7665571cc0ff6',1,'2026-10-19',NULL,3,1,37,1,19,260.0,'т',280867.52,NULL,73025555.2,'FCA ст. Текесу, поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','9ca046c9e87f50d8024824e1df474839380708b96bb8e6be85b7665571cc0ff6','2026-10-23 11:57:55.217463');
INSERT INTO "trades" VALUES(56,'799b13473b34b7fd3a705893061e6ef1a89f8814515041d040e60f03528d9619',1,'2026-10-19',NULL,1,1,21,1,15,130.0,'т',235526.66,NULL,30618465.8,'FCA ст.Тендык,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','799b13473b34b7fd3a705893061e6ef1a89f8814515041d040e60f03528d9619','2026-10-23 11:57:55.217466');
INSERT INTO "trades" VALUES(57,'03c8a8328f63b36f268e263abd97fdd17e809b3ad27e7b63162adafa4d38bd61',1,'2026-10-19',NULL,3,13,33,11,7,65.0,'т',283676.19,NULL,18438952.35,'FCA ст. Текесу, поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','03c8a8328f63b36f268e263abd97fdd17e809b3ad27e7b63162adafa4d38bd61','2026-10-23 11:57:55.217467');
INSERT INTO "trades" VALUES(58,'86dbc12d550975d8a55520001e06ac5cc0e090f763ee26d501763580a5827510',1,'2026-10-19',NULL,5,1,5,1,4,325.0,'т',319000.0,NULL,103675000.0,'FCA ст.Павлодар-порт,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','86dbc12d550975d8a55520001e06ac5cc0e090f763ee26d501763580a5827510','2026-10-23 11:57:55.217469');
INSERT INTO "trades" VALUES(59,'e5eef1965a28b15e063a8cefd2148d270610c395938a31d6b6cfd67795cfd73e',1,'2026-10-19',NULL,5,1,3,1,2,65.0,'т',317029.0,NULL,20606885.0,'FCA ст.Павлодар-порт,поставка только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','e5eef1965a28b15e063a8cefd2148d270610c395938a31d6b6cfd67795cfd73e','2026-10-23 11:57:55.217470');
INSERT INTO "trades" VALUES(60,'7b506a831ee2332d016be62316f6a6ad9435b86aaa4c94b9bf7c5ffd4bf4b29c',1,'2026-10-19',NULL,1,1,4,1,3,520.0,'т',233195.0,NULL,121261400.0,'FCA ст.Тендык,поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','7b506a831ee2332d016be62316f6a6ad9435b86aaa4c94b9bf7c5ffd4bf4b29c','2026-10-23 11:57:55.217471');
INSERT INTO "trades" VALUES(61,'8052ecf707a780c8c5e140b1ec5200394fa9bd4b52a1d4419f17a5f4eb4c451b',1,'2026-10-19',NULL,1,1,24,1,17,455.0,'т',230816.13,NULL,105021339.15,'FCA ст.Тендык,поставка только ж',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','8052ecf707a780c8c5e140b1ec5200394fa9bd4b52a1d4419f17a5f4eb4c451b','2026-10-23 11:57:55.217472');
INSERT INTO "trades" VALUES(62,'6bc387246aeec5b21e56bed85ae006ea6ce46f751d691896d06414d2ed0a49b3',1,'2026-10-19',NULL,8,1,16,1,8,195.0,'т',505666.67,NULL,98605000.65,'FCA,ст.Павлодар-порт,поставка то',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','6bc387246aeec5b21e56bed85ae006ea6ce46f751d691896d06414d2ed0a49b3','2026-10-23 11:57:55.217473');
INSERT INTO "trades" VALUES(63,'7420f3c15d45edf4abac31bf8fd11bc3624ffac65cb8371f41d4546c055290d4',1,'2026-10-19',NULL,7,1,16,1,8,455.0,'т',503000.0,NULL,228865000.0,'FCA,ст.Текесу,только ж',NULL,3,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','7420f3c15d45edf4abac31bf8fd11bc3624ffac65cb8371f41d4546c055290d4','2026-10-23 11:57:55.217473');
INSERT INTO "trades" VALUES(64,'18f34f9997dfe15453197c19d6a1b80be5218b21809a1b4163d7f01b37573b28',1,'2026-10-19',NULL,6,1,16,1,8,130.0,'т',493593.34,NULL,64167134.2,'FCA, СТ. ТЕНДЫК, поставка ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','18f34f9997dfe15453197c19d6a1b80be5218b21809a1b4163d7f01b37573b28','2026-10-23 11:57:55.217474');
INSERT INTO "trades" VALUES(65,'12a82bd482183915ee9512be9a7c308f5e63a4516d14084def914d6f0e28db50',1,'2026-10-19',NULL,11,13,23,11,16,65.0,'т',345638.16,NULL,22466480.4,'FCA ст.Текесу,базис поставки - только ж',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','12a82bd482183915ee9512be9a7c308f5e63a4516d14084def914d6f0e28db50','2026-10-23 11:57:55.217475');
INSERT INTO "trades" VALUES(66,'20009754bc9d071b58301ae289ec6f46430e222193209131a3699c22e0e30040',1,'2026-10-19',NULL,10,17,38,13,14,200.0,'т',325000.0,NULL,65000000.0,'EXW г.Алматы (мкр.Рахат 224А,склад №7)',NULL,2,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','20009754bc9d071b58301ae289ec6f46430e222193209131a3699c22e0e30040','2026-10-23 11:57:55.220605');
INSERT INTO "trades" VALUES(67,'57cb7bc5fd7ae023d8be5dd4d13c11ba249af58325b4fa806c2f87a5478e6fc5',1,'2026-10-19',NULL,10,19,20,11,14,100.0,'т',315000.0,NULL,31500000.0,'EXW г.Алматы (мкр.Рахат 224А,склад №7)',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','57cb7bc5fd7ae023d8be5dd4d13c11ba249af58325b4fa806c2f87a5478e6fc5','2026-10-23 11:57:55.220609');
INSERT INTO "trades" VALUES(68,'909d705897bd8338f0dfe98cf432dd73a28ee8578dc229a50e0224cbc85d5d65',1,'2026-10-19',NULL,15,39,40,11,14,68.0,'т',310000.0,NULL,21080000.0,'EXW',NULL,1,'https://ets.kz/upload/iblock/1f9/i25z3hk17v2pj69wps9zdq9b4bzo8sl4.xlsx','909d705897bd8338f0dfe98cf432dd73a28ee8578dc229a50e0224cbc85d5d65','2026-10-23 11:57:55.223126');
INSERT INTO "trades" VALUES(69,'7da96638efcfa0f6f7eaeed45f1aeae04253dad2592509f06bbdc7c73d3d07da',1,'2026-10-20',NULL,16,41,42,7,11,2400.0,'т',37969.12,NULL,91125888.0,'DDP ВКО для Малеевского',NULL,1,'https://ets.kz/upload/iblock/eaf/zwl94dvmoz1txzip63u7l0ci18j6gspi.xlsx','7da96638efcfa0f6f7eaeed45f1aeae04253dad2592509f06bbdc7c73d3d07da','2026-10-23 11:57:55.225830');
INSERT INTO "trades" VALUES(70,'ecbbba6f79516243b9780f396223e81623627581de0ff8e87ddd0a3d85355964',1,'2026-10-20',NULL,17,41,42,7,11,5500.0,'т',37969.12,NULL,208830160.0,'DDP ВКО для Риддер-Сокольного',NULL,1,'https://ets.kz/upload/iblock/eaf/zwl94dvmoz1txzip63u7l0ci18j6gspi.xlsx','ecbbba6f79516243b9780f396223e81623627581de0ff8e87ddd0a3d85355964','2026-10-23 11:57:55.228104');
INSERT INTO "trades" VALUES(71,'08fa378d7c4267414be7e8ed7222fa34e4ffee539862164efa9481f50d74f8af',1,'2026-10-20',NULL,18,41,42,7,11,11500.0,'т',37969.12,NULL,436644880.0,'DDP ВКО для Долинного',NULL,1,'https://ets.kz/upload/iblock/eaf/zwl94dvmoz1txzip63u7l0ci18j6gspi.xlsx','08fa378d7c4267414be7e8ed7222fa34e4ffee539862164efa9481f50d74f8af','2026-10-23 11:57:55.230036');
INSERT INTO "trades" VALUES(72,'bcfb1216cd4d0c962bd6cfcc4fa871737f902d4f4e3ab233c3ca546c22613cb7',1,'2026-10-20',NULL,19,43,44,11,5,350.0,'т',10237.36,NULL,3583076.0,'FCA ст. Шубарколь на Акмолинскую обл T+3 мес',NULL,1,'https://ets.kz/upload/iblock/eaf/zwl94dvmoz1txzip63u7l0ci18j6gspi.xlsx','bcfb1216cd4d0c962bd6cfcc4fa871737f902d4f4e3ab233c3ca546c22613cb7','2026-10-23 11:57:55.232611');
INSERT INTO "trades" VALUES(73,'539e903b6b588ea74dffce28cb0c565fdaa55301f2b664304defe36ca1e8376b',1,'2026-10-20',NULL,20,43,44,11,5,350.0,'т',10237.36,NULL,3583076.0,'FCA ст. Шубарколь на СКО T+3 мес.',NULL,1,'https://ets.kz/upload/iblock/eaf/zwl94dvmoz1txzip63u7l0ci18j6gspi.xlsx','539e903b6b588ea74dffce28cb0c565fdaa55301f2b664304defe36ca1e8376b','2026-10-23 11:57:55.233743');
INSERT INTO "trades" VALUES(74,'da7fc33f8ed9ac59c09f85b5d94489ac762b7fc2ad0fefe54464f1c73ee4e072',2,'2026-10-23',NULL,21,45,46,20,21,1050.0,'т',8400.0,NULL,8820000.0,'FCA',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','da7fc33f8ed9ac59c09f85b5d94489ac762b7fc2ad0fefe54464f1c73ee4e072','2026-10-23 11:59:56.055829');
INSERT INTO "trades" VALUES(75,'c5edf6a7a9164332789a95d80b6d11be9bc3f4aa6eb82fb702ce69b1a34c4398',2,'2026-10-23',NULL,21,45,44,20,22,1050.0,'т',8400.0,NULL,8820000.0,'FCA',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','c5edf6a7a9164332789a95d80b6d11be9bc3f4aa6eb82fb702ce69b1a34c4398','2026-10-23 11:59:56.058228');
INSERT INTO "trades" VALUES(76,'30116b1a31116404ffe469e5c7c114eef62b18c02eb4cf8258a4fdcefe6803ff',2,'2026-10-23',NULL,22,47,48,23,24,138.0,'т',49500.0,NULL,6831000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','30116b1a31116404ffe469e5c7c114eef62b18c02eb4cf8258a4fdcefe6803ff','2026-10-23 11:59:56.062724');
INSERT INTO "trades" VALUES(77,'0d7b8faef7948f761156b16698d9abe3ffd81e9f17b3ade3faa1cda80421dc53',2,'2026-10-23',NULL,22,47,49,23,24,720.0,'т',45500.0,NULL,32760000.0,'CPT',NULL,2,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','0d7b8faef7948f761156b16698d9abe3ffd81e9f17b3ade3faa1cda80421dc53','2026-10-23 11:59:56.064360');
INSERT INTO "trades" VALUES(78,'2b128a5617a0ad4f38882db69d2036ca273c2dc3f99a721b9120b6b79c030b22',2,'2026-10-23',NULL,23,47,49,23,24,360.0,'т',49000.0,NULL,17640000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','2b128a5617a0ad4f38882db69d2036ca273c2dc3f99a721b9120b6b79c030b22','2026-10-23 11:59:56.066837');
INSERT INTO "trades" VALUES(79,'3bfb20a9b2b8e380687f50fc3b28ec4dfdae9448f9bfaa59301c7ec625d38e49',2,'2026-10-23',NULL,21,45,44,20,25,1050.0,'т',8400.0,NULL,8820000.0,'FCA',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','3bfb20a9b2b8e380687f50fc3b28ec4dfdae9448f9bfaa59301c7ec625d38e49','2026-10-23 11:59:56.069512');
INSERT INTO "trades" VALUES(80,'ee28d92a0dec795afd7b8bfa371311400034703a20a7ef3f69b88b9e385fdf66',2,'2026-10-21',NULL,23,47,49,23,24,360.0,'т',49000.0,NULL,17640000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','ee28d92a0dec795afd7b8bfa371311400034703a20a7ef3f69b88b9e385fdf66','2026-10-23 11:59:56.069515');
INSERT INTO "trades" VALUES(81,'e2641d3c0e86a4299b0fa7b36c3a4538d00207c8c6c1ff02c7425201d8024109',2,'2026-10-20',NULL,24,50,51,26,27,3905.0,'т',25500.0,NULL,99577500.0,'DDP',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','e2641d3c0e86a4299b0fa7b36c3a4538d00207c8c6c1ff02c7425201d8024109','2026-10-23 11:59:56.074248');
INSERT INTO "trades" VALUES(82,'1c6d9bc972f6452720b2ce1c59609e4fc407e3225a682722b56a1698df8cbda2',2,'2026-10-20',NULL,24,50,51,26,27,6500.0,'т',18800.0,NULL,122200000.0,'DDP',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','1c6d9bc972f6452720b2ce1c59609e4fc407e3225a682722b56a1698df8cbda2','2026-10-23 11:59:56.074250');
INSERT INTO "trades" VALUES(83,'ea1c1b4d39e276e4b54e6a3421f0b07a81c7b6a70cf6c363a842dc86545cf043',2,'2026-10-19',NULL,22,47,52,23,24,432.0,'т',45000.0,NULL,19440000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','ea1c1b4d39e276e4b54e6a3421f0b07a81c7b6a70cf6c363a842dc86545cf043','2026-10-23 11:59:56.076113');
INSERT INTO "trades" VALUES(84,'14df0755c7118d79d96e8263452dcd8bce68a34020b2ef90196b16735eb25bbd',2,'2026-10-19',NULL,22,47,53,23,24,720.0,'т',44000.0,NULL,31680000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','14df0755c7118d79d96e8263452dcd8bce68a34020b2ef90196b16735eb25bbd','2026-10-23 11:59:56.077864');
INSERT INTO "trades" VALUES(85,'78b7ce409e8012486d75974a929b9e1dff8e4b2940fbe1c8be04d110d140a00f',2,'2026-10-16',NULL,23,47,54,23,24,207.0,'т',51000.0,NULL,10557000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','78b7ce409e8012486d75974a929b9e1dff8e4b2940fbe1c8be04d110d140a00f','2026-10-23 11:59:56.084756');
INSERT INTO "trades" VALUES(86,'c80a1455e08e8551bd5f231f2a05af455f65e5659d0398e93ed3837bf016576f',2,'2026-10-16',NULL,22,47,53,23,24,720.0,'т',44000.0,NULL,31680000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','c80a1455e08e8551bd5f231f2a05af455f65e5659d0398e93ed3837bf016576f','2026-10-23 11:59:56.084759');
INSERT INTO "trades" VALUES(87,'d8a3c00999104adbc9f14bda6e4587d072788291ceb98ceaa52ce1c52734e960',2,'2026-10-16',NULL,23,47,49,23,24,360.0,'т',49000.0,NULL,17640000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','d8a3c00999104adbc9f14bda6e4587d072788291ceb98ceaa52ce1c52734e960','2026-10-23 11:59:56.084760');
INSERT INTO "trades" VALUES(88,'b350f821ce42b235cd8633e5b3cc046d21e7b061fd8bd1099ad1546ea4d1ba4f',2,'2026-10-16',NULL,22,47,49,23,24,720.0,'т',45500.0,NULL,32760000.0,'CPT',NULL,2,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','b350f821ce42b235cd8633e5b3cc046d21e7b061fd8bd1099ad1546ea4d1ba4f','2026-10-23 11:59:56.084762');
INSERT INTO "trades" VALUES(89,'5fed430981e00960b826a7a0ad244e18230eddc7e8b5b4762ae1f912ecd28681',2,'2026-10-14',NULL,23,47,49,23,24,720.0,'т',49000.0,NULL,35280000.0,'CPT',NULL,2,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','5fed430981e00960b826a7a0ad244e18230eddc7e8b5b4762ae1f912ecd28681','2026-10-23 11:59:56.084763');
INSERT INTO "trades" VALUES(90,'06c53c73573202a74cdf6a9646523f036d822c7c37d4da2c844806b75c56bd9e',2,'2026-10-14',NULL,22,47,49,23,24,360.0,'т',45500.0,NULL,16380000.0,'CPT',NULL,1,'https://ccx.kz/trading-and-analytics/trading-results?lang=ru&page=1&per_page=100&date_from=13.10.2026&date_to=23.10.2026','06c53c73573202a74cdf6a9646523f036d822c7c37d4da2c844806b75c56bd9e','2026-10-23 11:59:56.084763');
CREATE UNIQUE INDEX ux_participants_bin
    ON participants(bin) WHERE bin IS NOT NULL AND bin != '';
CREATE INDEX ix_trades_date ON trades(trade_date);
CREATE INDEX ix_trades_exchange ON trades(exchange_id);
CREATE INDEX ix_trades_product ON trades(product_id);
CREATE INDEX ix_trades_seller ON trades(seller_id);
CREATE INDEX ix_trades_buyer ON trades(buyer_id);
CREATE INDEX ix_trades_seller_broker ON trades(seller_broker_id);
CREATE INDEX ix_trades_buyer_broker ON trades(buyer_broker_id);
CREATE INDEX ix_trades_amount ON trades(amount);
CREATE INDEX ix_trades_delivery ON trades(delivery_place);
CREATE INDEX ix_parse_runs_started ON parse_runs(started_at);
COMMIT;