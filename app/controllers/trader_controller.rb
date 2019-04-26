class TraderController < ApplicationController

	def inventories
		# Muestro el hash en el navegador, y después lo pruebo en https://reqbin.com/
		auth_hash = getHash('GET', '')
		render json: auth_hash
	end

end
