class FactoryController < ApplicationController


	Proporciones = {
		'1001' => {'lote': 10, 'materias_primas': []},
		'1002' => {'lote': 10, 'materias_primas': []},
		'1009' => {'lote': 3, 'materias_primas': []},
		'1003' => {'lote': 100, 'materias_primas': []},
		'1004' => {'lote': 100, 'materias_primas': []},
		'1005' => {'lote': 100, 'materias_primas': []},
		'1006' => {'lote': 1, 'materias_primas': []},
		'1008' => {'lote': 10, 'materias_primas': []},
		'1007' => {'lote': 8, 'materias_primas': []},
		'1010' => {'lote': 5, 'materias_primas': []},
		'1011' => {'lote': 4, 'materias_primas': []},
		'1012' => {'lote': 7, 'materias_primas': []},
		'1013' => {'lote': 10, 'materias_primas': []},
		'1014' => {'lote': 5, 'materias_primas': []},
		'1015' => {'lote': 4, 'materias_primas': []},
		'1016' => {'lote': 8, 'materias_primas': []},
		'1105' => {'lote': 10, 'materias_primas': [{'sku': '1005', 'unidades_lote': 1}]},
		'1106' => {'lote': 100, 'materias_primas':[{'sku': '1006', 'unidades_lote': 100}]},
		'1107' => {'lote': 11, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1108' => {'lote': 6, 'materias_primas': [{'sku': '1008', 'unidades_lote': 1}]},
		'1109' => {'lote': 12, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
		'1110' => {'lote': 6, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
		'1111' => {'lote': 2, 'materias_primas': [{'sku': '1011', 'unidades_lote': 2}]},
		'1112' => {'lote': 20, 'materias_primas': [{'sku': '1012', 'unidades_lote': 1}]},
		'1114' => {'lote': 4, 'materias_primas': [{'sku': '1014', 'unidades_lote': 1}]},
		'1115' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 3}]},
		'1116' => {'lote': 10, 'materias_primas':[{'sku': '1016', 'unidades_lote': 11}]},
		'1201' => {'lote': 10, 'materias_primas':[{'sku': '1101', 'unidades_lote': 1}]},
		'1209' => {'lote': 14, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
		'1210' => {'lote': 9, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
		'1215' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 4}]},
		'1216' => {'lote': 10, 'materias_primas': [{'sku': '1016', 'unidades_lote': 2}]},
		'1211' => {'lote': 10, 'materias_primas': [{'sku': '1111', 'unidades_lote': 1}]},
		'1207' => {'lote': 12, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1301' => {'lote': 5, 'materias_primas': [{'sku': '1101', 'unidades_lote': 1}]},
		'1309' => {'lote': 11, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
		'1307' => {'lote': 11, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1310' => {'lote': 12, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
		'1407' => {'lote': 14, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1101' => {'lote': 10, 'materias_primas': [{'sku': '1001', 'unidades_lote': 8}, {'sku': '1003', 'unidades_lote': 3},{'sku': '1004', 'unidades_lote': 2},{'sku': '1002', 'unidades_lote': 4}]},
		'10001' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10002' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10003' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10004' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1210','unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10005'	=> {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10006' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1107','unidades_lote': 1},{'sku': '1211','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10007' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10008' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10009' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1013', 'unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10010' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1210', 'unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10011' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1114', 'unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10012' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1108', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10013' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10014' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10015' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109', 'unidades_lote': 1},{'sku': '1115', 'unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10016' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10017' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10018' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10019' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1}]},
		'10020' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4},{'sku': '1112', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1}]},
		'10021' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1109', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1}]},
		'10022' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1215', 'unidades_lote': 1}]},
		'10023' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1109', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1215', 'unidades_lote': 1}]},
		'10024' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1115', 'unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1}]},
		'10025' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1115', 'unidades_lote': 1},{'sku': '1013', 'unidades_lote': 5}]},
		'20001' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1207', 'unidades_lote': 1},{'sku': '1310', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1}]},
		'20002' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4}]},
		'20003' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1207', 'unidades_lote': 1}]},
		'20004' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1209', 'unidades_lote': 1}]},
		'20005' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1209', 'unidades_lote': 1},{'sku': '1310', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1}]},
		'30001' => {'lote': 1, 'materias_primas': [{'sku': '1307','unidades_lote': 3}]},
		'30002' => {'lote': 1, 'materias_primas': [{'sku': '1307','unidades_lote': 4}]},
		'30003' => {'lote': 1, 'materias_primas': [{'sku': '1307','unidades_lote': 5}]},
		'30004' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 3}]},
		'30005' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 4}]},
		'30006' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 5}]},
		'30007' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 2},{'sku': '1307','unidades_lote': 2}]},
		'30008' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 3},{'sku': '1307','unidades_lote': 3}]}
	}

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

	def produce_final(renders = true)
		sku = params[:sku]
		cantidad = params[:cantidad]
		resp = cocinar_funcion(sku, cantidad.to_i)
		if renders
			render json: resp
		end
		return resp
	end


	def cocinar_funcion(sku, cantidad)
		producidos = 0
		resps = {'responses': [], 'cocinado': false}
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
			resps[:cocinado] = resp.has_key? 'disponible'
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
			#vaciarCocina()
			bodegas = almacenes()
			bodega_despacho = bodegas.detect {|b| b['cocina']}
			productos = []
			bodegas.each do |almacen|
				producto[:materias_primas].each do |ingredient|
					news = obtener_productos_funcion(almacen['_id'], ingredient[:sku], ingredient[:unidades_lote])
					productos += news
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
		ocs.each do |useless, oc|
			if oc["estado"] == "creada"
				resp = getOC_funcion(oc["id"])
				cantidad = resp[0]['cantidad'].to_i
				sku = resp[0]['sku']
				inventory = all_inventories()
				materias_suficientes = true
				resp = recepcionarOC_funcion(oc["id"]) ## rechazarOC_funcion(oc["id"], "no hay")
				oc["estado"] = resp[0]['estado']
				File.open("public/ocs.json","w") do |f|
				  f.write(JSON.pretty_generate(ocs))
				end
				# total_materias = Proporciones[sku][:materias_primas].length
				# materias_suficientes = 0
				#Proporciones[sku][:materias_primas].each do |materia|
				#	inventory.each do |producto|
				#		if producto['sku'] == materia[:sku]
				#			if (materia[:unidades_lote] * cantidad) > producto[:total]
				#				materias_suficientes = false
				#			end
				#		end
				#	end
				#end
				#if materias_suficientes
				#	resp = cocinar_funcion(sku, cantidad)
				#else
				#	resp = rechazarOC_funcion(ocs[oc]["id"])
				#end
			end
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
		movidos = 0
		while productos.length > 0 and movidos < qty
			prod = productos.first
			moveStock_funcion(prod["_id"], bodega_despacho["_id"])
			despachados.push(prod)
			productos.delete_at(0)
			movidos += 1
		end
		return despachados
	end

	def despachar_clientes
		ocs = JSON.load File.new("public/ocs.json")
		inventory = all_inventories()
		ocs.each do |oc, value|
			sku = value[sku]
			materias_suficientes = true
			if value['estado'] === 'creada' || value['estado'] === 'aceptada'
				Proporciones[sku][:materias_primas].each do |materia|
					inventory.each do |producto|
						if producto['sku'] == materia[:sku]
							if (materia[:unidades_lote] * cantidad) > producto[:total]
								materias_suficientes = false
							end
						end
					end
				end
				if materias_suficientes
					resp = recepcionarOC_funcion(oc["id"])
					cocinar_funcion(sku, cantidad)
				end
			end
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
						body = { 'productoId': prods[prod]['_id'], 'oc': value['id'], 'direccion': '1', 'precio': '1' }
						httpDeleteRequest(BaseURL + 'stock', auth_hash, body)
					end
					## Mover de cocina a despacho o no se de donde, pero a despacho
					## Usar esta funcion despachar de application controller
				end
			end
		end
	end

	def cocinarOrden_funcion(sku, cantidad, oc, renders=true)
		vaciarCocina()
		resp = cocinar_funcion(sku, cantidad)
		# if resp.key?("disponible")
			# ocs = JSON.load File.new("public/ocs.json")
			# ocs.each do |file, orden|
				# if orden['id'] == oc
				# 	orden['estado'] = 'cocinando'
				# 	File.open("public/ocs.json","w") do |f|
				#   		f.write(JSON.pretty_generate(ocs))
					# end
				# end
			# end
		# end
		print 'TRATANDO DE COCINAR: ', resp
		puts ''
		if renders
			render json: resp
		end
		return resp
	end

	def cocinarTodo
		ocs = JSON.load File.new("public/ocs.json")
		ocs.each do |key, oc|
			if oc['estado'] == 'aceptada'
				puts 'Cocinando', oc
				resp = cocinarOrden_funcion(oc['sku'], oc['qty'], oc['id'], false)
				if resp[:cocinado] == true
					oc['estado'] = 'cocinando'
				end
			end
		end
		File.open("public/ocs.json","w") do |f|
			f.write(JSON.pretty_generate(ocs))
		end
	end

	def despacharOrden(renders=true)
		sku = params[:sku]
		cantidad = params[:cantidad]
		oc = params[:oc]
		resps = despacharOrden_funcion(sku, cantidad.to_i, oc, renders)
		#prods = moverProductosDespacho(sku, cantidad.to_i)
		#resps = []
		#prods.each do |prod|
		#	auth_hash = getHash('DELETE', prod['_id'] + '11' + oc)
		#	body = { 'productoId': prod['_id'], 'oc': oc, 'direccion': '1', 'precio': '1' }
		#	resps.push(httpDeleteRequest(BaseURL + 'stock', auth_hash, body))
		#end
		#render json: resps
		return resps
	end

end
