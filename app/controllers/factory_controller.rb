class FactoryController < ApplicationController

	def produce(renders = true)
		# Esta funcion se utiliza para mandar a producir un producto especifico.
		# Ejemplo: http://127.0.0.1:3000/fabrica/fabricarSinPago?sku=1006&cantidad=50 manda a producir 50 producto
		# de 1006 (camarones)
		sku = params[:sku]
		cantidad = params[:cantidad]
		resp = produce_funcion(sku, cantidad.to_i)
		if renders
			render json: resp
		end
		return resp
	end

	def produce_funcion(sku, cantidad)
		producidos = 0
		resps = {'responses': []}
		lote = Proporciones[sku][:lote]
		if cantidad % lote != 0
			resps[:data] = {'error': 'El tamaño del lote no es correcto', 'cantidad': cantidad, 'tamano_lote': lote}
			return resps
		end
		while cantidad > producidos
			auth_hash = getHash('PUT', sku + lote.to_s)
			body = {"sku": sku, "cantidad": lote}
			moverMateriasPrimasDespacho(sku)
			resp = httpPutRequest(BaseURL + 'fabrica/fabricarSinPago'  , auth_hash, body)
			resps[:responses].push(resp)
			producidos += lote
		end
		resps[:data] = {"sku": sku, "producidos": producidos}
		return resps
	end

	def moverMateriasPrimasDespacho(sku)
		producto = Proporciones[sku]
		movidos = 0
		if producto[:materias_primas].length > 0
			vaciarDespacho()
			bodegas = almacenes()
			bodega_despacho = bodegas.detect {|b| b['despacho']}
			productos = []
			bodegas.each do |almacen|
				producto[:materias_primas].each do |ingredient|
					productos += obtener_productos_funcion(almacen['_id'], ingredient[:sku], ingredient[:unidades_lote])
				end
			end
			while productos.length > 0
				prod = productos.first
				moveStock_funcion(prod["_id"], bodega_despacho["_id"])
				productos.delete_at(0)
				movidos += 1
			end
		end
		return movidos
	end

	def cocinar_funcion(sku, cantidad)
		producidos = 0
		resps = {'responses': []}
		lote = Proporciones[sku][:lote]
		if cantidad % lote != 0
			resps[:data] = {'error': 'El tamaño del lote no es correcto', 'cantidad': cantidad, 'tamano_lote': lote}
			return resps
		end
		while cantidad > producidos
			auth_hash = getHash('PUT', sku + lote.to_s)
			body = {"sku": sku, "cantidad": lote}
			moverMateriasPrimasCocina(sku)
			resp = httpPutRequest(BaseURL + 'fabrica/fabricarSinPago'  , auth_hash, body)
			resps[:responses].push(resp)
			producidos += lote
		end
		resps[:data] = {"sku": sku, "producidos": producidos}
		return resps
	end

	def moverMateriasPrimasCocina(sku)
		producto = Proporciones[sku]
		movidos = 0
		if producto[:materias_primas].length > 0
			vaciarCocina()
			bodegas = almacenes()
			bodega_despacho = bodegas.detect {|b| b['cocina']}
			productos = []
			bodegas.each do |almacen|
				producto[:materias_primas].each do |ingredient|
					productos += obtener_productos_funcion(almacen['_id'], ingredient[:sku], ingredient[:unidades_lote])
				end
			end
			while productos.length > 0
				prod = productos.first
				moveStock_funcion(prod["_id"], bodega_despacho["_id"])
				productos.delete_at(0)
				movidos += 1
			end
		end
		return movidos
	end

	def all_inventories(render = true)
		auth_hash = getHash('GET', '')
		ret = httpGetRequest(BaseURL + 'almacenes', auth_hash)
		stock = []
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
		return stock
	end


	def orders_sftp
		ocs = JSON.load File.new("public/ocs.json")
		ocs.each do |oc, value|
			puts oc
			if ocs[oc][:estado] == "creada"
				resp = getOC_funcion(ocs[oc][:id])
				cantidad = resp[0]['cantidad'].to_i
				sku = resp[0]['sku']
				inventory = all_inventories()
				materias_suficientes = True
				# total_materias = Proporciones[sku][:materias_primas].length
				# materias_suficientes = 0
				Proporciones[sku][:materias_primas].each do |materia|
					inventory.each do |producto|
						if producto['sku'] == materia['sku']
							if (materia['unidades_lote'] * cantidad) > producto['total']
								materias_suficientes = false
								break
							end
						end
					end
				end
				if materias_suficientes
					resp = recepcionarOC_funcion(ocs[oc][:id])
					cocinar_funcion(sku, cantidad)
				else
					resp = rechazarOC_funcion(ocs[oc][:id])
				end
				ocs[oc][:estado] = resp[0]['estado']
			end
		end
		File.open("public/ocs.json","w") do |f|
		  f.write(JSON.pretty_generate(ocs))
		end
	end
	
	def moverProductosDespacho(sku, qty)
		vaciarDespacho()
		bodegas = almacenes()
		bodega_despacho = bodegas.detect {|b| b['despacho']}
		productos = []
		bodegas.each do |almacen|
			productos += obtener_productos_funcion(almacen['_id'], sku)
		end
		despachados = []
		while productos.length > 0 and movidos < qty
			prod = productos.first
			moveStock_funcion(prod["_id"], bodega_despacho["_id"])
			despachados.push(prod)
			productos.delete_at(0)
			movidos += 1
		end
		return despachados
	end

	def despachar_cliente
		ocs = JSON.load File.new("public/ocs.json")
		ocs.each do |oc, value|
		inventory = all_inventories()
			if ocs[oc][:estado] == "aceptada"
				materias_suficientes = true
				inventory.each do |producto|
					if producto['sku'] == ocs[oc][:sku]
						if (ocs[oc][:qty]) > producto['total']
							materias_suficientes = false
							break
						end
					end
				end
				if materias_suficientes
					prods = moverProductosDespacho(ocs[oc][:sku], ocs[oc][:qty])
					prods.each do |prod, value|
						auth_hash = getHash('DELETE', prods[prod]['_id'] + '11' + oc)
						body = { 'productoId': prods[prod]['_id'], 'oc': oc, 'direccion': '1', 'precio': '1' }
						puts httpDeleteRequest(BaseURL + 'stock', auth_hash, body)
					end
					## Mover de cocina a despacho o no se de donde, pero a despacho
					## Usar esta funcion despachar de application controller

				end
			end
		end
	end

end
