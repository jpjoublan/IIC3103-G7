class TraderController < ApplicationController


	def moveStockBodega(renders = true)
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
        if renders
			render json: resp
		end
		return resp
	end


	def inventories(renders = true)
		auth_hash = getHash('GET', '')
		ret = httpGetRequest(BaseURL + 'almacenes', auth_hash)
		stock = []
		Products.each do |sku, value|
			stock.push({'sku': sku, 'total': -value['min'], 'nombre': value['name']})
		end
		ret.each do |almacen|
			id = almacen['_id']
			auth_hash = getHash('GET', id)
			aux = httpGetRequest(BaseURL + 'skusWithStock?almacenId=' + id, auth_hash)
			aux.each do |cantidad|
				not_found = true
				stock.each do |total|
					if total[:sku] == cantidad['_id']
						total[:total] += cantidad['total']
						not_found = false
					end
				end
				if not_found
					stock.push({'sku': cantidad['_id'], 'total': cantidad['total'], 'nombre': Products[cantidad['_id']]['name']})
				end
			end
		end
		ret_stock = []
		stock.each do |prod|
			prod[:total] = [[0, prod[:total]].max, 100].min
			if prod[:total] > 0
				ret_stock.push(prod)
			end
		end
		if renders
			render json: ret_stock
		end
		return ret_stock
	end

	def orders(renders = true)
		body = JSON.parse(request.body.read)
		_id = body['oc']
		## NUEVO
		resp = getOC_funcion(_id)
		cantidad = resp[0]['cantidad'].to_i
		sku = resp[0]['sku']
		cliente = resp[0]['cliente']
		puts 'LLEGO UNA ORDEN PARA', sku, 'CLIENTE', cliente, 'CANTIDAD', cantidad
		if cantidad > 100
			rechazo = 'No tenemos suficiente stock'
			rechazarOC_funcion(_id, rechazo)
			if render
				render :json => {"sku": sku, "cantidad": 0, "almacenId": almacenid, "grupoProveedor": 7, "aceptado": false, "despachado": false }.to_json, :status => 201
			end
			return
		end
		## NUEVO
		# sku = body['sku']
		# cantidad = [body['cantidad'], 200].min
		almacenid = body['almacenId'] ### OJOOOO
		bodegas = almacenes()
		bodega_pulmon = bodegas.detect {|b| b['pulmon']}
		bodega_recepcion = bodegas.detect {|b| b['recepcion']}
		bodega_despacho = bodegas.detect {|b| b['despacho']}
		recepcion = skusWithStock_funcion(bodega_recepcion["_id"]).detect {|b| b['_id']==sku}
		pulmon = skusWithStock_funcion(bodega_pulmon["_id"]).detect {|b| b['_id']==sku}
		capacidad_pulmon = pulmon.nil? ? 0: pulmon['total']
		capacidad_recepcion = recepcion.nil? ? 0: recepcion['total']
		if capacidad_recepcion + capacidad_pulmon - cantidad > 500
			enviados = 0
			if capacidad_pulmon > 0
				productos_pulmon = obtener_productos_funcion(bodega_pulmon['_id'], sku, "100")
				productos_pulmon = productos_pulmon.sort_by { |k| k["vencimiento"] }
				while cantidad > 0 and productos_pulmon.length > 0
					prod = productos_pulmon.first
					moveStock_funcion(prod["_id"], bodega_despacho["_id"])
					moveStockBodega_funcion(prod["_id"], almacenid, _id)
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
					moveStockBodega_funcion(prod["_id"], almacenid, _id)
					capacidad_recepcion -= 1
					cantidad -= 1
					productos_recepcion.delete_at(0)
					enviados += 1
				end
			end
			recepcionarOC_funcion(_id)
			resp2 = getOC_funcion(_id)
			puts 'SUPUESTAMENTE SE ENVIÓ LA ORDERN AL GRUPO'
			if renders
				render :json => {"sku": sku, "cantidad": enviados, "almacenId": almacenid, "grupoProveedor": 7, "aceptado": true, "despachado": true}.to_json, :status => 201
			end
			return
		else
			rechazo = 'No tenemos suficiente stock'
			rechazarOC_funcion(_id, rechazo)
			if render
				render :json => {"sku": sku, "cantidad": 0, "almacenId": almacenid, "grupoProveedor": 7, "aceptado": false, "despachado": false }.to_json, :status => 201
			end
			return
		end
	end


	def testear
		# Reemplazar por funcion que se quiere testear.
		# Para las funciones post de nuestra API (orders)
		return orders()
	end
end
