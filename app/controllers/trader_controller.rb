class TraderController < ApplicationController

	Names = {
		'1001'=> 'Arroz grano corto',
		'1002'=> 'Vinagre de arroz',
		'1003'=> 'Azúcar',
		'1004'=> 'Sal',
		'1005'=> 'Kanikama entero',
		'1006'=> 'Camarón',
		'1007'=> 'Filete de salmón',
		'1008'=> 'Filete de salmón ahumado',
		'1009'=> 'Filete de atún',
		'1010'=> 'Palta',
		'1011'=> 'Sésamo',
		'1012'=> 'Queso crema',
		'1013'=> 'Masago',
		'1014'=> 'Cebollín entero',
		'1015'=> 'Ciboulette entero',
		'1016'=> 'Nori entero',
		'1101'=> 'Arroz cocido',
		'1105'=> 'Kanikama para roll',
		'1106'=> 'Camarón cocido',
		'1107'=> 'Salmón cortado para roll',
		'1108'=> 'Salmón ahumado cortado para roll',
		'1109'=> 'Atún cortado para roll',
		'1110'=> 'Palta cortada para envoltura',
		'1111'=> 'Sésamo tostado',
		'1112'=> 'Queso crema para roll',
		'1114'=> 'Cebollín cortado para roll',
		'1115'=> 'Ciboulette picado para roll',
		'1116'=> 'Nori entero cortado para roll',
		'1201'=> 'Arroz cocido para roll',
		'1207'=> 'Salmón cortado para nigiri',
		'1209'=> 'Atún cortado para nigiri',
		'1210'=> 'Palta cortada para roll',
		'1211'=> 'Sésamo tostado para envoltura',
		'1215'=> 'Ciboulette picado para envoltura',
		'1216'=> 'Nori entero cortado para nigiri',
		'1301'=> 'Arroz cocido para nigiri',
		'1307'=> 'Salmón cortado para sashimi',
		'1309'=> 'Atún cortado para sashimi',
		'1310'=> 'Palta cortada para nigiri',
		'1407'=> 'Salmón cortado para envoltura'
	}


	def moveStockBodega
        # Mover producto entre bodega de despacho y la bodega de otro grupo (funcion para despachar)
        #
        #
        producto_id = params[:productoid]
        almacen_id = params[:almacenid]
        oc = params[:oc]
        #cambiar precio cuando se necesite
        precio = params[:precio]
        auth_hash = getHash('POST', producto_id + almacen_id)

        body = {"productoId": producto_id, "almacenId": almacen_id, "oc": oc, "precio": precio}
        resp = httpPostRequest(BaseURL + 'moveStockBodega'  , auth_hash, body)

		render json: resp
		return resp
	end


	def inventories
		auth_hash = getHash('GET', '')
		ret = httpGetRequest(BaseURL + 'almacenes', auth_hash)
		stock = []
		ret.each do |almacen|
			puts '****************************************'
			puts almacen
			id = almacen['_id']
			auth_hash = getHash('GET', id)
			aux = httpGetRequest(BaseURL + 'skusWithStock?almacenId=' + id, auth_hash)
			puts aux
			aux.each do |cantidad|
				not_found = true
				stock.each do |total|
					if total[:sku] == cantidad['_id']
						total[:total] += cantidad['total']
						not_found = false
					end
				end
				if not_found
					stock.push({'sku': cantidad['_id'], 'total': cantidad['total'], 'nombre': Names[cantidad['_id']]})
				end
			end
		end
		render json: stock
		return stock
	end

	def orders
		body = JSON.parse(request.body.read)
		sku = body['sku']
		cantidad = [body['cantidad'], 200].min
		almacenid = body['almacenId']
		bodegas = almacenes()
		bodega_pulmon = bodegas.detect {|b| b['pulmon']}
		bodega_recepcion = bodegas.detect {|b| b['recepcion']}
		bodega_despacho = bodegas.detect {|b| b['despacho']}
		recepcion = skusWithStock_funcion(bodega_recepcion["_id"]).detect {|b| b['_id']==sku}
		pulmon = skusWithStock_funcion(bodega_pulmon["_id"]).detect {|b| b['_id']==sku}
		capacidad_pulmon = pulmon.nil? ? 0: pulmon['total']
		capacidad_recepcion = recepcion.nil? ? 0: recepcion['total']
		puts capacidad_recepcion + capacidad_pulmon - cantidad
		if capacidad_recepcion + capacidad_pulmon - cantidad > 500
			enviados = 0
			if capacidad_pulmon > 0
				productos_pulmon = obtener_productos_funcion(bodega_pulmon['_id'], sku, "100")
				productos_pulmon = productos_pulmon.sort_by { |k| k["vencimiento"] }
				while cantidad > 0 and productos_pulmon.length > 0
					prod = productos_pulmon.first
					puts moveStock_funcion(prod["_id"], bodega_despacho["_id"])
					puts moveStockBodega_funcion(prod["_id"], almacenid)
					capacidad_pulmon -= 1
					cantidad -= 1
					productos_pulmon.delete_at(0)
					enviados += 1
				end
			end
			if capacidad_recepcion > 0 and cantidad > 0
				productos_recepcion = obtener_productos_funcion(bodega_recepcion['_id'], sku, "100")
				while cantidad > 0 and productos_recepcion.length > 0
					prod = productos_recepcion.first
					moveStock_funcion(prod["_id"], bodega_despacho["_id"])
					moveStockBodega_funcion(prod["_id"], almacenid)
					capacidad_recepcion -= 1
					cantidad -= 1
					productos_recepcion.delete_at(0)
					enviados += 1
				end
			end
			render :json => {"sku": sku, "cantidad": enviados, "almacenId": almacenid, "grupoProveedor": 7, "aceptado": true, "despachado": true}.to_json, :status => 201
			return
		else
			render :json => {"sku": sku, "cantidad": 0, "almacenId": almacenid, "grupoProveedor": 7, "aceptado": false, "despachado": false }.to_json, :status => 201
			return
		end
	end


	def testear
		# Reemplazar por funcion que se quiere testear.
		# Para las funciones post de nuestra API (orders)
		return orders()
	end
end
