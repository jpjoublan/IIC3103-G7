class FactoryController < ApplicationController
	Proporciones = {
		'1001' => {'lote': 10, 'materias_primas': []},
		'1003' => {'lote': 100, 'materias_primas': []},
		'1006' => {'lote': 1, 'materias_primas': []},
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
		'1115' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 3}]},
		'1116' => {'lote': 10, 'materias_primas':[{'sku': '1016', 'unidades_lote': 11}]},
		'1207' => {'lote': 12, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
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
		'1101' => {'lote': 10, 'materias_primas': [{'sku': '1001', 'unidades_lote': 8},
												   {'sku': '1003', 'unidades_lote': 2},
												   {'sku': '1004', 'unidades_lote': 3},
												   {'sku': '1002', 'unidades_lote': 4}]
					}
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
				puts moveStock_funcion(prod["_id"], bodega_despacho["_id"])
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
			vaciarDespacho()
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
				puts moveStock_funcion(prod["_id"], bodega_despacho["_id"])
				productos.delete_at(0)
				movidos += 1
			end
		end
		return movidos
	end

end
