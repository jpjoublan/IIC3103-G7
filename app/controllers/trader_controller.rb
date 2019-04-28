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
		puts '************BODY*************'
			puts JSON.parse(request.body)
		puts '************HEADER*************'
		puts request.headers
		render json: {'Hola': 'Not Working'}
	end

end
