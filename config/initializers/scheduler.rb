require 'rufus-scheduler'
require 'net/http'
require 'open-uri'
require 'json'
require 'base64'
require 'cgi'



if defined?(::Rails::Server)
  scheduler = Rufus::Scheduler::singleton
  feedstock = [1009, 1006, 1014, 1015,1005, 1016, 1010, 1012, 1008, 1007, 1011, 1001, 1002, 1003, 1004]

  products = {1009 => {'stock_min' =>22,'tiempo_produccion' =>400,'duracion_esperada' =>15,'lote_produccion' =>3,'produce' =>false,'grupos_productores' =>'1,8,9'},
      1109 => {'stock_min' =>60,'tiempo_produccion' =>30,'duracion_esperada' =>1.5,'lote_produccion' =>12,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1209 => {'stock_min' =>50,'tiempo_produccion' =>30,'duracion_esperada' =>1.5,'lote_produccion' =>14,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1309 => {'stock_min' =>170,'tiempo_produccion' =>50,'duracion_esperada' =>1.2,'lote_produccion' =>11,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1006 => {'stock_min' =>2000,'tiempo_produccion' =>120,'duracion_esperada' =>720,'lote_produccion' =>1,'produce' =>true,'grupos_productores' =>'2,5,7'},
      1106 => {'stock_min' =>400,'tiempo_produccion' =>30,'duracion_esperada' =>4,'lote_produccion' =>100,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1014 => {'stock_min' =>5,'tiempo_produccion' =>240,'duracion_esperada' =>24,'lote_produccion' =>5,'produce' =>false,'grupos_productores' =>'3,4,9'},
      1114 => {'stock_min' =>50,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>4,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1015 => {'stock_min' =>2,'tiempo_produccion' =>400,'duracion_esperada' =>30,'lote_produccion' =>4,'produce' =>false,'grupos_productores' =>'1,12,14'},
      1115 => {'stock_min' =>20,'tiempo_produccion' =>10,'duracion_esperada' =>3,'lote_produccion' =>8,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1215 => {'stock_min' =>30,'tiempo_produccion' =>10,'duracion_esperada' =>3,'lote_produccion' =>8,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1005 => {'stock_min' =>5,'tiempo_produccion' =>260,'duracion_esperada' =>24,'lote_produccion' =>5,'produce' =>false,'grupos_productores' =>'4,5,8'},
      1105 => {'stock_min' =>50,'tiempo_produccion' =>10,'duracion_esperada' =>3,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1013 => {'stock_min' =>300,'tiempo_produccion' =>320,'duracion_esperada' =>12,'lote_produccion' =>10,'produce' =>false,'grupos_productores' =>'10,12,14'},
      1016 => {'stock_min' =>350,'tiempo_produccion' =>600,'duracion_esperada' =>240,'lote_produccion' =>8,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1116 => {'stock_min' =>250,'tiempo_produccion' =>40,'duracion_esperada' =>24,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1216 => {'stock_min' =>50,'tiempo_produccion' =>30,'duracion_esperada' =>24,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1010 => {'stock_min' =>95,'tiempo_produccion' =>480,'duracion_esperada' =>30,'lote_produccion' =>5,'produce' =>false,'grupos_productores' =>'3,9,13'},
      1110 => {'stock_min' =>80,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>6,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1210 => {'stock_min' =>150,'tiempo_produccion' =>10,'duracion_esperada' =>2.3,'lote_produccion' =>9,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1310 => {'stock_min' =>20,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>12,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1012 => {'stock_min' =>6,'tiempo_produccion' =>150,'duracion_esperada' =>72,'lote_produccion' =>7,'produce' =>false,'grupos_productores' =>'11,12,13'},
      1112 => {'stock_min' =>130,'tiempo_produccion' =>10,'duracion_esperada' =>24,'lote_produccion' =>20,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1008 => {'stock_min' =>25,'tiempo_produccion' =>220,'duracion_esperada' =>48,'lote_produccion' =>10,'produce' =>false,'grupos_productores' =>'1,5,7'},
      1108 => {'stock_min' =>10,'tiempo_produccion' =>20,'duracion_esperada' =>4,'lote_produccion' =>6,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1007 => {'stock_min' =>24,'tiempo_produccion' =>300,'duracion_esperada' =>20,'lote_produccion' =>8,'produce' =>false,'grupos_productores' =>'6,11,13'},
      1107 => {'stock_min' =>50,'tiempo_produccion' =>20,'duracion_esperada' =>2,'lote_produccion' =>11,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1207 => {'stock_min' =>20,'tiempo_produccion' =>20,'duracion_esperada' =>2,'lote_produccion' =>12,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1307 => {'stock_min' =>170,'tiempo_produccion' =>30,'duracion_esperada' =>1.2,'lote_produccion' =>11,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1407 => {'stock_min' =>40,'tiempo_produccion' =>30,'duracion_esperada' =>2,'lote_produccion' =>14,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1011 => {'stock_min' =>10,'tiempo_produccion' =>120,'duracion_esperada' =>168,'lote_produccion' =>4,'produce' =>false,'grupos_productores' =>'2,10,11'},
      1111 => {'stock_min' =>10,'tiempo_produccion' =>30,'duracion_esperada' =>12,'lote_produccion' =>2,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1211 => {'stock_min' =>60,'tiempo_produccion' =>10,'duracion_esperada' =>12,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1001 => {'stock_min' =>60,'tiempo_produccion' =>240,'duracion_esperada' =>720,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1002 => {'stock_min' =>11,'tiempo_produccion' =>300,'duracion_esperada' =>720,'lote_produccion' =>10,'produce' =>false,'grupos_productores' =>'6,8,14'},
      1003 => {'stock_min' =>50,'tiempo_produccion' =>320,'duracion_esperada' =>720,'lote_produccion' =>100,'produce' =>true,'grupos_productores' =>'2,6,7'},
      1004 => {'stock_min' =>11,'tiempo_produccion' =>400,'duracion_esperada' =>720,'lote_produccion' =>100,'produce' =>false,'grupos_productores' =>'3,4,10'},
      1101 => {'stock_min' =>35,'tiempo_produccion' =>40,'duracion_esperada' =>3,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1301 => {'stock_min' =>50,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>5,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'},
      1201 => {'stock_min' =>250,'tiempo_produccion' =>10,'duracion_esperada' =>2,'lote_produccion' =>10,'produce' =>true,'grupos_productores' =>'1,2,3,4,5,6,7,8,9,10,11,12,13,14'}
  }
  order_rate = 1.3
  scheduler.every '1m' do
    puts "comenzó el job";
    stock = TraderController.new.inventories()
    puts "ya reviso inventories";
    products.each do |sku, dict|
        puts "esta revisando cada producto"
        produce = dict['produce']
        stock_min = dict['stock_min']
        lote_produccion = dict['lote_produccion']
        productores = dict['grupos_productores'].split(',')
        in_stock = false
        stock.each do |product|
            if product[:sku] == sku
                in_stock = true
                break
            end
        end
        if in_stock
            puts "in stock"
            if product[:total] < (stock_min * order_rate)
                if produce
                    #### Cuando tengamos que pedir menos podemos usar esto
                    # to_produce = (stock_min*0.5).round(0)
                    # while to_produce % lote_produccion !=0
                    #     to_produce -= 1
                    # end
                    puts "mando a producir"
                    FactoryController.new.produce_funcion(sku, stock_min*2)
                else
                  puts "aka"
                    to_produce = (stock_min*0.3).round(0)
                    while to_produce % lote_produccion !=0
                        to_produce -= 1
                    end
                    productores.each do |group|
                        puts "pidio a un grupo"
                        ApplicationController.new.pedirProductoGrupo(group, sku, to_produce, "5cc7b139a823b10004d8e6f1") #### No sé de donde sacar el almacenId (es nuestro?)
                    end
                end
            end
        else
            if produce
                puts "mando a producir 2"
                FactoryController.new.produce_funcion(sku, stock_min*3)
            else
                puts "aqui"
                to_produce = (stock_min*0.3).round(0)
                while to_produce % lote_produccion !=0
                    to_produce -= 1
                end
                productores.each do |group|
                  puts "pide a otro grupo"
                    ApplicationController.new.pedirProductoGrupo(group, sku, to_produce, "5cc7b139a823b10004d8e6f1") #### No sé de donde sacar el almacenId (es nuestro?)
                end
            end
        end
    end

  end

end
