class TraderController < ApplicationController


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
					stock.push({'sku': cantidad['_id'], 'total': cantidad['total'], 'nombre': Products[cantidad['_id']]['name']})
				end
			end
		end
		return stock
	end

	def orders
		body = JSON.parse(request.body.read)
		_id = body['oc']
		##
		resp = getOC_funcion(_id)
		cantidad = resp['cantidad'].to_i
		sku = resp['sku']

		##
		# sku = body['sku']
		# cantidad = [body['cantidad'], 200].min
		# almacenid = body['almacenId']
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
