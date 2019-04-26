require 'net/http'
require 'open-uri'
require 'json'
require 'base64'
require 'cgi'


class ApplicationController < ActionController::Base

	def getHash(action, params)
		key = "WyZsey$Opy37to"
		data = action + params
		digest = OpenSSL::Digest.new('sha1')
		# Cambiar los hmac para corroborar que efectivamente funciona el ejemplo de la documentacion de la api
		# hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), 'acbd12345'.encode("ASCII"), 'GET534960ccc88ee69029cd3fb2'.encode("ASCII"))
		hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), key.encode("ASCII"), data.encode("ASCII"))
		return Base64.encode64(hmac).chomp
	end

	def http_request(url, auth_hash)
		uri = URI(url)
		req = Net::HTTP::Get.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		response = http.request(req)
		return response.body
	end

end
