class TraderController < ApplicationController

	def inventories
		auth_hash = getHash('GET', '')
		ret = httpGetRequest('https://integracion-2019-dev.herokuapp.com/bodega/almacenes', auth_hash)
		ret.each do |almacen|
			if almacen['despacho']
				id = almacen['_id']
				auth_hash = getHash('GET', id)
				ret = httpGetRequest('https://integracion-2019-dev.herokuapp.com/bodega/skusWithStock?almacenId=' + id, auth_hash)
			end
		end
		render json: ret
	end

	def orders
		puts JSON.parse(request.body.read)
		puts request.headers
		render json: {'Hola': 'Still not ready'}
	end

	def testear
		# Reemplazar por funcion que se quiere testear.
		# Para las funciones post de nuestra API (orders)
		return orders()		
	end

end
