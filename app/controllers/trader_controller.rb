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
		print 'LLEGO UNA ORDEN PARA: ', sku, ' CLIENTE: ', cliente, ' CANTIDAD: ', cantidad
		puts ''
		if cantidad > 20 || Produce_dict[sku][:produce] == false
			rechazo = 'No tenemos suficiente stock 1'
			puts rechazo
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
		puts 'CALCULANDO PRODUCTOS TOTALES'
		productos = []
		bodegas.each do |almacen|
			puts 'PIDIENDO PRODUCTOS'
			productos_aux = obtener_productos_funcion(almacen['_id'], sku)
			puts 'Se salio de la funcion'
			puts 'PRODUCTOS AUX:', productos_aux
			productos += productos_aux
		end
		print 'PRODUCTOS: ', productos
		puts ''
		bodega_pulmon = bodegas.detect {|b| b['pulmon']}
		bodega_recepcion = bodegas.detect {|b| b['recepcion']}
		bodega_despacho = bodegas.detect {|b| b['despacho']}
		if productos.length >= cantidad
			enviados = 0
			vaciarDespacho()
			while cantidad > 0 and productos.length > 0
				prod = productos.first
				puts 'MOVIENDO PRODUCTO', prod
				puts 'PARA ORDEN DE COMPRA', _id
				puts moveStock_funcion(prod["_id"], bodega_despacho["_id"])
				puts moveStockBodega_funcion(prod["_id"], almacenid, _id)
				cantidad -= 1
				productos.delete_at(0)
				enviados += 1
			end
			puts recepcionarOC_funcion(_id)
			resp2 = getOC_funcion(_id)
			puts 'SUPUESTAMENTE SE ENVIÓ LA ORDERN AL GRUPO'
			puts resp2
			if renders
				render :json => {"sku": sku, "cantidad": enviados, "almacenId": almacenid, "grupoProveedor": 7, "aceptado": true, "despachado": true}.to_json, :status => 201
			end
			return
		else
			rechazo = 'No tenemos suficiente stock 2'
			puts rechazo
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
