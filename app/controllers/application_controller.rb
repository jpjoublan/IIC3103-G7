require 'net/http'
require 'open-uri'
require 'json'
require 'base64'
require 'cgi'


class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session
	BaseURL =  'https://integracion-2019-dev.herokuapp.com/bodega/'

	def getHash(action, params)
		key = "WyZsey$Opy37to"
		data = action + params
		digest = OpenSSL::Digest.new('sha1')
		hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), key.encode("ASCII"), data.encode("ASCII"))
		return Base64.encode64(hmac).chomp
	end

	def httpGetRequest(url, auth_hash)
		uri = URI(url)
		req = Net::HTTP::Get.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		req['content-type'] = 'application/json'
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		response = http.request(req)
		return JSON.parse(response.body)
	end

	def httpPostRequest(url, auth_hash, body)
		uri = URI(url)
		req = Net::HTTP::Post.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		req['content-type'] = 'application/json'
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		req.body = body.to_json
		response = http.request(req)
		return JSON.parse(response.body)
	end

	def httpPutRequest(url, auth_hash, body)
		uri = URI(url)
		req = Net::HTTP::Put.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		req['content-type'] = 'application/json'
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		req.body = body.to_json
		response = http.request(req)
		return JSON.parse(response.body)
	end

    def obtener_productos_funcion(almacen_id, sku, limit = 100)
        auth_hash = getHash('GET', almacen_id + sku)
        resp = httpGetRequest(BaseURL + 'stock?almacenId=%s&sku=%s&limit=%s' % [almacen_id, sku, limit] , auth_hash)
        return resp
    end

    def almacenes
		auth_hash = getHash('GET', '')
        ret = httpGetRequest('https://integracion-2019-dev.herokuapp.com/bodega/almacenes', auth_hash)
        return ret
    end

    def skusWithStock_funcion(almacen_id)
        auth_hash = getHash('GET', almacen_id)
        ret = httpGetRequest(BaseURL + 'skusWithStock?almacenId=%s' % [almacen_id], auth_hash)
        return ret
    end

    def moveStock_funcion(producto_id, almacen_id)
        auth_hash = getHash('POST', producto_id + almacen_id)
        body = {"productoId": producto_id, "almacenId": almacen_id}		
        resp = httpPostRequest(BaseURL + 'moveStock' , auth_hash, body)
        return resp
    end

    def moveStockBodega_funcion(producto_id, almacen_id, oc, precio)
		auth_hash = getHash('POST', producto_id + almacen_id)
        body = {"productoId": producto_id, "almacenId": almacen_id, "oc": oc, "precio": precio}
        resp = httpPostRequest(BaseURL + 'moveStockBodega'  , auth_hash, body)
		return resp
	end

end
