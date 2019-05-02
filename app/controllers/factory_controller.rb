class FactoryController < ApplicationController



	def produce
		# Esta funcion se utiliza para mandar a producir un producto especifico.
			# Ejemplo: http://127.0.0.1:3000/fabrica/fabricarSinPago?sku=1006&cantidad=50 manda a producir 50 producto
		# de 1006 (camarones)
		sku = params[:sku]
		cantidad = params[:cantidad]
		resp = produce_funcion(sku, cantidad)
		render json: resp
		return resp
	end

	def produce_funcion(sku, cantidad)
		auth_hash = getHash('PUT', sku + cantidad)
		body = {"sku": sku, "cantidad": cantidad}
		moverMateriasPrimasDespacho(sku, cantidad.to_i)
		resp = httpPutRequest(BaseURL + 'fabrica/fabricarSinPago'  , auth_hash, body)
		vaciarDespacho()
		return resp
	end

	def moverMateriasPrimasDespacho(sku, cantidad)
		proporciones = {
			'1001' => {'lote': 10, 'materias_primas': []},
			'1003' => {'lote': 100, 'materias_primas': []},
			'1005' => {'lote': 5, 'materias_primas': []},
			'1006' => {'lote': 1, 'materias_primas': []},
			'1008' => {'lote': 1, 'materias_primas': []},
			'1016' => {'lote': 10, 'materias_primas': []},
			'1006' => {'lote': 8, 'materias_primas': []},
			'1106' => {'lote': 100, 'materias_primas':[{'sku': '1006', 'unidades_lote': 100}]},
			'1116' => {'lote': 10, 'materias_primas':[{'sku': '1016', 'unidades_lote': 11}]},
			'1105' => {'lote': 10, 'materias_primas': [{'sku': '1005', 'unidades_lote': 1}]},
			'1108' => {'lote': 6, 'materias_primas': [{'sku': '1008', 'unidades_lote': 1}]},
			'1110' => {'lote': 6, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
			'1111' => {'lote': 2, 'materias_primas': [{'sku': '1011', 'unidades_lote': 1.1}]},
			'1115' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 3}]},
			'1210' => {'lote': 9, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
			'1215' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 4}]},
			'1216' => {'lote': 10, 'materias_primas': [{'sku': '1016', 'unidades_lote': 2}]},
			'1211' => {'lote': 10, 'materias_primas': [{'sku': '1111', 'unidades_lote': 0.5}]},
			'1310' => {'lote': 12, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
			'1310' => {'lote': 12, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
			}
		producto = proporciones[sku]
		if producto[:materias_primas].length > 0
			vaciarDespacho()
			bodegas = almacenes()
			bodega_pulmon = bodegas.detect {|b| b['pulmon']}
			bodega_recepcion = bodegas.detect {|b| b['recepcion']}
			bodega_despacho = bodegas.detect {|b| b['despacho']}
			productos_pulmon = obtener_productos_funcion(bodega_pulmon['_id'], producto[:materias_primas][0][:sku], '100')
			productos_recepcion = obtener_productos_funcion(bodega_recepcion['_id'], producto[:materias_primas][0][:sku], '100')
			productos = []
			bodegas.each do |almacen|
				productos += obtener_productos_funcion(almacen['_id'], producto[:materias_primas][0][:sku], '100')
			end
			enviados = 0
			necesarios = cantidad*producto[:materias_primas][0][:unidades_lote]/producto[:lote]
			necesarios = necesarios.ceil
			print 'SE NECESITAN', necesarios
			while enviados < necesarios and enviados < 100
				prod = productos.first
				puts moveStock_funcion(prod["_id"], bodega_despacho["_id"])
				productos.delete_at(0)
				enviados += 1
			end
		end
	end

end
