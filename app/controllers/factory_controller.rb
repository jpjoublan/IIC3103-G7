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
		moverProductosDespacho('1016', cantidad.to_i)
		resp = httpPutRequest(BaseURL + 'fabrica/fabricarSinPago'  , auth_hash, body)
		return resp		
	end

	def moverProductosDespacho(sku, cantidad)
		vaciarDespacho()
		bodegas = almacenes()
		bodega_pulmon = bodegas.detect {|b| b['pulmon']}
		bodega_recepcion = bodegas.detect {|b| b['recepcion']}
		bodega_despacho = bodegas.detect {|b| b['despacho']}
		productos_pulmon = obtener_productos_funcion(bodega_pulmon['_id'], '1016', '100') #sku de la materia prima aun esta hardcodeado
		enviados = 0
		while enviados < cantidad*1.1
			prod = productos_pulmon.first
			puts moveStock_funcion(prod['_id'], bodega_despacho['_id'])
			productos_pulmon.delete_at(0)
			enviados += 1
			puts enviados <= cantidad
			puts enviados
			puts cantidad
		end
	end

end
