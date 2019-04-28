require 'net/http'
require 'open-uri'
require 'json'
require 'base64'
require 'cgi'


class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session

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
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		response = http.request(req)
		return JSON.parse(response.body)
	end

	def httpPostRequest(url, auth_hash)
		uri = URI(url)
		req = Net::HTTP::Post.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		response = http.request(req)
		return JSON.parse(response.body)
	end

	def httpPutRequest(url, auth_hash)
		uri = URI(url)
		req = Net::HTTP::Get.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		response = http.request(req)
		return JSON.parse(response.body)
	end

end
