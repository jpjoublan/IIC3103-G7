class TraderController < ApplicationController

	def inventories
		# Muestro el hash en el navegador, y después lo pruebo en https://reqbin.com/
		auth_hash = getHash('GET', '')
		ret = http_request('https://integracion-2019-dev.herokuapp.com/bodega/almacenes', auth_hash)
		render json: ret
	end

end
