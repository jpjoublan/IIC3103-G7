class WelcomeController < ApplicationController

	def index
		auth_hash = getHash('GET', '')
		ret = httpGetRequest(BaseURL + 'almacenes', auth_hash)
		stock = []
		Products.each do |sku, value|
			stock.push({'sku': sku, 'total': 0, 'name': value['name'], 'min': value['min']})
		end
		ret.each do |almacen|
			id = almacen['_id']
			auth_hash = getHash('GET', id)
			aux = httpGetRequest(BaseURL + 'skusWithStock?almacenId=' + id, auth_hash)
			aux.each do |cantidad|
				not_found = true
				stock.each do |total|
					if total[:sku] == cantidad['_id']
						total[:total] += cantidad['total']
						not_found = false
					end
				end
				if not_found
					stock.push({'sku': cantidad['_id'], 'total': 0, 
								'name': Products[cantidad['_id']][:name],
								'min': Products[cantidad['_id']][:min]})
				end
			end
		end
		@stocks = stock
		return
	end


	def simular
		uri = URI(params[:url])
		data = {'sku': params[:sku], 'cantidad': params[:cantidad], 'almacenId': params[:almacenId]}
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = false
		request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
		request.body = data.to_json
		response = http.request(request)
		ret = httpPostRequest
	end

	def showHash
		auth = params[:auth]
		action = params[:accion]
		hashed = getHash(action ,auth)
		render json: {'auth': auth, 'action': action, 'hash': hashed}
	end

    def almacenes
		auth_hash = getHash('GET', '')
        ret = httpGetRequest(BaseURL + 'almacenes', auth_hash)
        render json: ret
        return ret
    end

    def testsch(renders = true)
    	puts 'ESTA SE LLAMO DESDE EL SCHEDULER!!'
    	if renders
			    render json: {'status': 'SCHEDULER LLAMO ENDPOINT'}
    	end
    	return {'status': 'SCHEDULER LLAMO ENDPOINT'}
    end
end
