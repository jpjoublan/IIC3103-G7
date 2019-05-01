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
		return resp		
	end

	def moverMateriasPrimasDespacho(sku, cantidad)
		proporciones = {
			'1106' => {'lote': 100, 'materias_primas':[{'sku': '1006', 'unidades_lote': 100}]},
			'1116' => {'lote': 10, 'materias_primas':[{'sku': '1016', 'unidades_lote': 11}]},
			'1216' => {'lote': 10, 'materias_primas': [{'sku': '1016', 'unidades_lote': 2}]}
			}
		vaciarDespacho()
		bodegas = almacenes()
		producto = proporciones[sku]
		bodega_pulmon = bodegas.detect {|b| b['pulmon']}
		bodega_recepcion = bodegas.detect {|b| b['recepcion']}
		bodega_despacho = bodegas.detect {|b| b['despacho']}
		productos_pulmon = obtener_productos_funcion(bodega_pulmon['_id'], producto[:materias_primas][0][:sku], '100')
		enviados = 0
		while enviados < cantidad*producto[:materias_primas][0][:unidades_lote]/producto[:lote] and enviados < 100
			prod = productos_pulmon.first
			puts prod
			moveStock_funcion(prod["_id"], bodega_despacho["_id"])
			productos_pulmon.delete_at(0)
			enviados += 1
		end
	end

end
