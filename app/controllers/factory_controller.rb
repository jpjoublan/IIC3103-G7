class FactoryController < ApplicationController

	def produce
		# Esta funcion se utiliza para mandar a producir un producto especifico.
		# Ejemplo: http://127.0.0.1:3000/fabrica/fabricarSinPago?sku=1006&cantidad=50 manda a producir 50 producto
		# de 1006 (camarones)
		sku = params[:sku]
		cantidad = params[:cantidad]
		auth_hash = getHash('PUT', sku + cantidad)
		body = {"sku": sku, "cantidad": cantidad}		
		resp = httpPutRequest(BaseURL + 'fabrica/fabricarSinPago'  , auth_hash, body)
		render json: resp
		return resp		
	end


end
