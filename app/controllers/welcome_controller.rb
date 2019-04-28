class WelcomeController < ApplicationController
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
end
