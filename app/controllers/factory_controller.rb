class FactoryController < ApplicationController

	def produce
		# Funcion para llamar al fabricar sin pagar del profe. Aun
		# no implementada
		render json: params		
	end


	def testear
		return produce()
	end

end
