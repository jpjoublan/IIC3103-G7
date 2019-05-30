require 'rufus-scheduler'
require 'net/http'
require 'open-uri'
require 'json'
require 'base64'
require 'cgi'
require '././app/controllers/factory_controller.rb'
require '././app/controllers/application_controller.rb'



if defined?(::Rails::Server)
  scheduler = Rufus::Scheduler::singleton
  feedstock = [1009, 1006, 1014, 1015,1005, 1016, 1010, 1012, 1008, 1007, 1011, 1001, 1002, 1003, 1004]

  bodega_recepcion_id = "5cc7b139a823b10004d8e6f1"

  products = {1009 => {'stock_min' =>23, 'nombre' => 'Filete de atún' ,'tiempo_produccion' =>400,'duracion_esperada' =>15,'lote_produccion' =>3,'produce' =>false,'grupos_productores' =>'1,4,8,9,12,14'},
            1109 => {'stock_min' =>50, 'nombre' => 'Atún cortado para roll' ,'tiempo_produccion' =>30,'duracion_esperada' =>1.5,'lote_produccion' =>12,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1209 => {'stock_min' =>50, 'nombre' => 'Atún cortado para nigiri' ,'tiempo_produccion' =>30,'duracion_esperada' =>1.5,'lote_produccion' =>14,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1309 => {'stock_min' =>170, 'nombre' => 'Atún cortado para sashimi' ,'tiempo_produccion' =>50,'duracion_esperada' =>1.2,'lote_produccion' =>11,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1006 => {'stock_min' =>1200, 'nombre' => 'Camarón' ,'tiempo_produccion' =>120,'duracion_esperada' =>720,'lote_produccion' =>1,'produce' =>true,'grupos_productores' =>'2,3,4,5,7,8'},
            1106 => {'stock_min' =>400, 'nombre' => 'Camarón cocido' ,'tiempo_produccion' =>30,'duracion_esperada' =>4,'lote_produccion' =>100,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1014 => {'stock_min' =>5, 'nombre' => 'Cebollín entero' ,'tiempo_produccion' =>240,'duracion_esperada' =>24,'lote_produccion' =>5,'produce' =>false,'grupos_productores' =>'1,3,4,6,12,14'},
            1114 => {'stock_min' =>50, 'nombre' => 'Cebollín cortado para roll' ,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>4,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1015 => {'stock_min' =>2, 'nombre' => 'Ciboulette entero' ,'tiempo_produccion' =>400,'duracion_esperada' =>30,'lote_produccion' =>4,'produce' =>false,'grupos_productores' =>'1,3,4,6,12,14'},
            1115 => {'stock_min' =>20, 'nombre' => 'Ciboulette picado para roll' ,'tiempo_produccion' =>10,'duracion_esperada' =>3,'lote_produccion' =>8,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1215 => {'stock_min' =>30, 'nombre' => 'Ciboulette picado para envoltura' ,'tiempo_produccion' =>10,'duracion_esperada' =>3,'lote_produccion' =>8,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1005 => {'stock_min' =>5, 'nombre' => 'Kanikama entero' ,'tiempo_produccion' =>260,'duracion_esperada' =>24,'lote_produccion' =>5,'produce' =>false,'grupos_productores' =>'1,4,5,6,8,12'},
            1105 => {'stock_min' =>50, 'nombre' => 'Kanikama para roll' ,'tiempo_produccion' =>10,'duracion_esperada' =>3,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1013 => {'stock_min' =>900, 'nombre' => 'Masago' ,'tiempo_produccion' =>320,'duracion_esperada' =>12,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'7,9,10,11,13,14'},
            1016 => {'stock_min' =>350, 'nombre' => 'Nori entero' ,'tiempo_produccion' =>600,'duracion_esperada' =>240,'lote_produccion' =>8,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1116 => {'stock_min' =>250, 'nombre' => 'Nori entero cortado para roll' ,'tiempo_produccion' =>40,'duracion_esperada' =>24,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1216 => {'stock_min' =>50, 'nombre' => 'Nori entero cortado para nigiri' ,'tiempo_produccion' =>30,'duracion_esperada' =>24,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1010 => {'stock_min' =>95, 'nombre' => 'Palta' ,'tiempo_produccion' =>480,'duracion_esperada' =>30,'lote_produccion' =>5,'produce' =>false,'grupos_productores' =>'1,2,3,9,10,13'},
            1110 => {'stock_min' =>80, 'nombre' => 'Palta cortada para envoltura' ,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>6,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1210 => {'stock_min' =>150, 'nombre' => 'Palta cortada para roll' ,'tiempo_produccion' =>10,'duracion_esperada' =>2.3,'lote_produccion' =>9,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1310 => {'stock_min' =>20, 'nombre' => 'Palta cortada para nigiri' ,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>12,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1012 => {'stock_min' =>7, 'nombre' => 'Queso crema' ,'tiempo_produccion' =>150,'duracion_esperada' =>72,'lote_produccion' =>7,'produce' =>false,'grupos_productores' =>'2,6,11,12,13,14'},
            1112 => {'stock_min' =>130, 'nombre' => 'Queso crema para roll' ,'tiempo_produccion' =>10,'duracion_esperada' =>24,'lote_produccion' =>20,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1008 => {'stock_min' =>9, 'nombre' => 'Filete de salmón ahumado' ,'tiempo_produccion' =>220,'duracion_esperada' =>48,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,5,7,9,10,14'},
            1108 => {'stock_min' =>10, 'nombre' => 'Salmón ahumado cortado para roll' ,'tiempo_produccion' =>20,'duracion_esperada' =>4,'lote_produccion' =>6,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1007 => {'stock_min' =>75, 'nombre' => 'Filete de salmón' ,'tiempo_produccion' =>300,'duracion_esperada' =>20,'lote_produccion' =>8,'produce' =>true,'grupos_productores' =>'5,6,7,10,11,13'},
            1107 => {'stock_min' =>50, 'nombre' => 'Salmón cortado para roll' ,'tiempo_produccion' =>20,'duracion_esperada' =>2,'lote_produccion' =>11,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1207 => {'stock_min' =>20, 'nombre' => 'Salmón cortado para nigiri' ,'tiempo_produccion' =>20,'duracion_esperada' =>2,'lote_produccion' =>12,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1307 => {'stock_min' =>170, 'nombre' => 'Salmón cortado para sashimi' ,'tiempo_produccion' =>30,'duracion_esperada' =>1.2,'lote_produccion' =>11,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1407 => {'stock_min' =>40, 'nombre' => 'Salmón cortado para envoltura' ,'tiempo_produccion' =>30,'duracion_esperada' =>2,'lote_produccion' =>14,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1011 => {'stock_min' =>24, 'nombre' => 'Sésamo' ,'tiempo_produccion' =>120,'duracion_esperada' =>168,'lote_produccion' =>4,'produce' =>true,'grupos_productores' =>'2,5,7,10,11,12'},
            1111 => {'stock_min' =>10, 'nombre' => 'Sésamo tostado' ,'tiempo_produccion' =>30,'duracion_esperada' =>12,'lote_produccion' =>2,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1211 => {'stock_min' =>60, 'nombre' => 'Sésamo tostado para envoltura' ,'tiempo_produccion' =>10,'duracion_esperada' =>12,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1001 => {'stock_min' =>60, 'nombre' => 'Arroz grano corto' ,'tiempo_produccion' =>240,'duracion_esperada' =>720,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1002 => {'stock_min' =>11, 'nombre' => 'Vinagre de arroz' ,'tiempo_produccion' =>300,'duracion_esperada' =>720,'lote_produccion' =>10,'produce' =>false,'grupos_productores' =>'1,2,3,6,8,9'},
            1003 => {'stock_min' =>12, 'nombre' => 'Azúcar' ,'tiempo_produccion' =>320,'duracion_esperada' =>720,'lote_produccion' =>100,'produce' =>true,'grupos_productores' =>'6,7,8,11,12,13'},
            1004 => {'stock_min' =>2, 'nombre' => 'Sal' ,'tiempo_produccion' =>400,'duracion_esperada' =>720,'lote_produccion' =>100,'produce' =>false,'grupos_productores' =>'3,4,9,10,13,14'},
            1101 => {'stock_min' =>35, 'nombre' => 'Arroz cocido' ,'tiempo_produccion' =>40,'duracion_esperada' =>3,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1301 => {'stock_min' =>50, 'nombre' => 'Arroz cocido para nigiri' ,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>5,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
            1201 => {'stock_min' =>250, 'nombre' => 'Arroz cocido para roll' ,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'}
    }

    proporciones = {'1101' => {'lote':10 , 'materias_primas': [{'sku': '1001','unidades_lote': 8},{'sku': '1003','unidades_lote': 3},{'sku': '1004','unidades_lote': 2},{'sku': '1002','unidades_lote': 4}]},
						'1001' => {'lote': 10, 'materias_primas': []},
						'1003' => {'lote': 100, 'materias_primas': []},
						'1008' => {'lote': 1, 'materias_primas': []},
						'1016' => {'lote': 10, 'materias_primas': []},
						'1006' => {'lote': 8, 'materias_primas': []},
						'1009' => {'lote': 3, 'materias_primas': []},
						'1105' => {'lote': 10, 'materias_primas': [{'sku': '1005', 'unidades_lote': 1}]},
						'1106' => {'lote': 100, 'materias_primas':[{'sku': '1006', 'unidades_lote': 100}]},
						'1107' => {'lote': 11, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
						'1108' => {'lote': 6, 'materias_primas': [{'sku': '1008', 'unidades_lote': 1}]},
						'1109' => {'lote': 12, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
						'1110' => {'lote': 6, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
						'1111' => {'lote': 2, 'materias_primas': [{'sku': '1011', 'unidades_lote': 2}]},
                        '1112' => {'lote': 20, 'materias_primas': [{'sku': '1012', 'unidades_lote': 1}]},
                        '1114' => {'lote':4 , 'materias_primas': [{'sku': '1014','unidades_lote': 1}]},
						'1115' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 3}]},
						'1116' => {'lote': 10, 'materias_primas':[{'sku': '1016', 'unidades_lote': 11}]},
						'1207' => {'lote': 12, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
						'1209' => {'lote': 14, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
						'1210' => {'lote': 9, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
						'1215' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 4}]},
						'1216' => {'lote': 10, 'materias_primas': [{'sku': '1016', 'unidades_lote': 2}]},
						'1211' => {'lote': 10, 'materias_primas': [{'sku': '1111', 'unidades_lote': 1}]},
						'1301' => {'lote': 5, 'materias_primas': [{'sku': '1101', 'unidades_lote': 1}]},
						'1309' => {'lote': 11, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
						'1307' => {'lote': 11, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
						'1310' => {'lote': 12, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
						'1407' => {'lote': 14, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
						'10001' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1211','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10002' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10003' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210','unidades_lote': 1},{'sku': '1211','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10004' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1210','unidades_lote': 1},{'sku': '1211','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10005' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1013','unidades_lote': 5},{'sku': '1210','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10006' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1107','unidades_lote': 1},{'sku': '1211','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10007' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210','unidades_lote': 1},{'sku': '1107','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10008' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1211','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10009' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10010' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1210','unidades_lote': 1},{'sku': '1110','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10011' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1114','unidades_lote': 1},{'sku': '1110','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10012' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1110','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1108','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10013' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1110','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10014' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1110','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10015' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1115','unidades_lote': 1},{'sku': '1110','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10016' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1110','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1107','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10017' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1110','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1107','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10018' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1407','unidades_lote': 1},{'sku': '1116','unidades_lote': 1}]},
						'10019' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1210','unidades_lote': 1},{'sku': '1116','unidades_lote': 1},{'sku': '1407','unidades_lote': 1}]},
						'10020' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1112','unidades_lote': 1},{'sku': '1114','unidades_lote': 1},{'sku': '1407','unidades_lote': 1}]},
						'10021' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1114','unidades_lote': 1},{'sku': '1407','unidades_lote': 1}]},
						'10022' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116','unidades_lote': 1},{'sku': '1107','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1215','unidades_lote': 1}]},
						'10023' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1215','unidades_lote': 1}]},
						'10024' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1114','unidades_lote': 1},{'sku': '1115','unidades_lote': 1},{'sku': '1211','unidades_lote': 1}]},
						'10025' => {'lote':1 , 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1114','unidades_lote': 1},{'sku': '1115','unidades_lote': 1},{'sku': '1013','unidades_lote': 5}]},
						'20001' => {'lote':1 , 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1207','unidades_lote': 1},{'sku': '1310','unidades_lote': 1},{'sku': '1112','unidades_lote': 1},{'sku': '1216','unidades_lote': 1}]},
						'20002' => {'lote':1 , 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216','unidades_lote': 1},{'sku': '1106','unidades_lote': 4}]},
						'20003' => {'lote':1 , 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216','unidades_lote': 1},{'sku': '1207','unidades_lote': 1}]},
						'20004' => {'lote':1 , 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216','unidades_lote': 1},{'sku': '1209','unidades_lote': 1}]},
						'20005' => {'lote':1 , 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216','unidades_lote': 1},{'sku': '1209','unidades_lote': 1},{'sku': '1310','unidades_lote': 1},{'sku': '1112','unidades_lote': 1}]},
						'30001' => {'lote':1 , 'materias_primas': [{'sku': '1307','unidades_lote': 3}]},
						'30002' => {'lote':1 , 'materias_primas': [{'sku': '1307','unidades_lote': 4}]},
						'30003' => {'lote':1 , 'materias_primas': [{'sku': '1307','unidades_lote': 5}]},
						'30004' => {'lote':1 , 'materias_primas': [{'sku': '1309','unidades_lote': 3}]},
						'30005' => {'lote':1 , 'materias_primas': [{'sku': '1309','unidades_lote': 4}]},
						'30006' => {'lote':1 , 'materias_primas': [{'sku': '1309','unidades_lote': 5}]},
						'30007' => {'lote':1 , 'materias_primas': [{'sku': '1309','unidades_lote': 2},{'sku': '1307','unidades_lote': 2}]},
						'30008' => {'lote':1 , 'materias_primas': [{'sku': '1309','unidades_lote': 3},{'sku': '1307','unidades_lote': 3}]}}

    #SCHEDULER PARA CUBRIR EL STOCK MINIMO, PEDIR EN CASO QUE FALTE.
    order_rate = 1.3
    scheduler.every '8m', first: :now do
        #COMENZAMOS LA ITERACION DEL JOB
        puts '=====================COMENZANDO PRODUCCION========================='
        #BUSCAMOS LO QUE TENEMOS EN STOCK
        stock = FactoryController.new.all_inventories(renders = false)
        
        #RECORREMOS CADA ELEMENTO CORRESPONDIENTE AL STOCK MINIMO
        products.each do |sku, dict|
            sku = sku.to_s
          

            
            #PREDEFINIMOS CANTIDAD EN STOCK = 0
            stock_cantidad = 0
            #product_in es producto que tenemos en stock
            stock.each do |product_in|
                #SI EL SKU ESTA EN STOCK (se tendra que restar el stock que ya tenemos)
                if product_in[:sku] == sku
                    stock_cantidad = product_in[:total]
                    
                end

            end
            #producto no se encuentra en stock
            #PONDERADOR DE CUBRIMIENTO DE STOCK
            ponderador = 1.1
            a_pedir = dict['stock_min']* ponderador - stock_cantidad
            if dict['stock_min'] <= stock_cantidad
            	print 'Pasando producto ', sku, ' porque se tienen ', stock_cantidad, ' y se necesitan ', dict['stock_min']
            	puts ''
            	next
        	end
            if a_pedir > 0
                #si nosotros producimos el producto
                if dict['produce']
                    #PEDIR A LA API
                    
                    a_pedir = a_pedir.to_i
                    if a_pedir % dict['lote_produccion'] != 0
                        a_pedir = (a_pedir / dict['lote_produccion']) * dict['lote_produccion']  + dict['lote_produccion']
                    end
                    
                    numero_lotes = a_pedir / dict['lote_produccion']
                    a_pedir = dict['lote_produccion']
                    #IF ABAJO NO VA, HAY QUE COMPLETAR DICCIONARIO
                    if proporciones[sku] != nil
                        
                        #SI EL SKU NO TIENE MATERIAS PRIMAS
                        if proporciones[sku][:materias_primas] == [] 
                            puts '=========================================='
                        	print 'MANDANDO A COMPRAR: ', sku
                        	puts ''
                        	print 'CANTIDAD: ', a_pedir
                        	puts ''
                        	print 'RESPUESTA: ', FactoryController.new.produce_funcion(sku, a_pedir)
                        	puts ''
                        #SI EL SKU TIENE MATERIAS PRIMAS   
                        else
                            #BOOL PARA CHEQUEAR SI HAY SUFICIENTE DE TODAS LAS MATERIAS PRIMAS
                            hay_todo = true
                            
                            proporciones[sku][:materias_primas].each do |materias|  
                                #BOOL PARA REVISAR SI ESTA EN STOCK
                                esta_stock = false
                                stock.each do |product_en|
                                    if materias[:sku] == product_en[:sku]
                                        esta_stock = true
                                        #revisamos si tenemos el minimo de stock para hacer el producto

                                        if materias[:unidades_lote] * numero_lotes > product_en[:total]
                                            hay_todo = false
                                        end
                                    
                                    end
                                    
                                end
                                #SI FALTA ALGUNA MATERIA PRIMA YA NO PRODUCIMOS 
                                if esta_stock == false
                                    hay_todo = false
                                    break
                                end

                            end
                            if hay_todo 

                            	puts '=========================================='
                        		print 'MANDANDO A PRODUCIR: ', sku
        	                	puts ''
            	            	print 'CANTIDAD: ', a_pedir
                	        	puts ''
                    	    	print 'RESPUESTA: ', FactoryController.new.produce_funcion(sku, a_pedir)
                        		puts ''
                            end
                        end
                    end
                    

                else
                    #PEDIR A OTRO GRUPO
                    
                    a_pedir = a_pedir.to_i
                    a_pedir = 5
                    grupos = dict['grupos_productores'].split(',')
                    grupos.each do |grupo|
                        
						begin
                    	puts '=========================================================='
                        print 'MANDANDO A PEDIR: ', sku
                    	puts ''
	                    print 'GRUPO: ', grupo
                    	puts ''
                        print 'Cantidad: ', a_pedir
    	               	puts ''
                        resp = ApplicationController.new.pedirProductoGrupo(grupo, sku, a_pedir.to_s, bodega_recepcion_id)
                   		puts resp
                        rescue
                        	puts 'LA MIERDA GRUPO QLIAO'
                        end
                        
                    end
                    
                end
            end
            
        end
        puts '=====================FINALIZANDO PRODUCCION========================='
    end

    #SCHEDULER PARA REVISAR LAS ORDENES DE COMPRA DE CLIENTE QUE LLEGAN.

    scheduler.every '2m' do
        puts "===================REVISANDO SFTP====================="
    	# Actualizamos ordenes de compra
        OrdersController.new.sftp(renders = false)
    	# Acepta o rechaza segun criterios
        FactoryController.new.orders_sftp()
        puts "===============TERMINO DE REVISAR SFTP==============="
    end


	scheduler.every '1m' do
        puts "============REVISANDO DESPACHOS CLIENTES============="
    	# Acepta o rechaza segun criterios
        OrdersController.new.refreshSftp(renders = false)
        FactoryController.new.despacharTodo()
        puts "========TERMINÓ DE REVISAR DESPACHOS CLIENTES========"
    end

end
