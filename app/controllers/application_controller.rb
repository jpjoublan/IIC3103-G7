require 'net/http'
require 'open-uri'
require 'json'
require 'base64'
require 'cgi'


class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session
	BaseURL =  'https://integracion-2019-prod.herokuapp.com/bodega/'
	groupsURL = 'tuerca%s.ing.puc.cl/'
	Products = {
			'1001'=> {'min'=> 1, 'name' =>'Arroz grano corto'},
			'1002'=> {'min'=> 1, 'name' =>'Vinagre de arroz'},
			'1003'=> {'min'=> 1, 'name' =>'Azúcar'},
			'1004'=> {'min'=> 1, 'name' =>'Sal'},
			'1005'=> {'min'=> 1, 'name' =>'Kanikama entero'},
			'1006'=> {'min'=> 1, 'name' =>'Camarón'},
			'1007'=> {'min'=> 1, 'name' =>'Filete de salmón'},
			'1008'=> {'min'=> 1, 'name' =>'Filete de salmón ahumado'},
			'1009'=> {'min'=> 1, 'name' =>'Filete de atún'},
			'1010'=> {'min'=> 1, 'name' =>'Palta'},
			'1011'=> {'min'=> 1, 'name' =>'Sésamo'},
			'1012'=> {'min'=> 1, 'name' =>'Queso crema'},
			'1013'=> {'min'=> 300, 'name' =>'Masago'},
			'1014'=> {'min'=> 1, 'name' =>'Cebollín entero'},
			'1015'=> {'min'=> 1, 'name' =>'Ciboulette entero'},
			'1016'=> {'min'=> 1, 'name' =>'Nori entero'},
			'1101'=> {'min'=> 1, 'name' =>'Arroz cocido'},
			'1105'=> {'min'=> 50, 'name' =>'Kanikama para roll'},
			'1106'=> {'min'=> 400, 'name' =>'Camarón cocido'},
			'1107'=> {'min'=> 1, 'name' =>'Salmón cortado para roll'},
			'1108'=> {'min'=> 1, 'name' =>'Salmón ahumado cortado para roll'},
			'1109'=> {'min'=> 50, 'name' =>'Atún cortado para roll'},
			'1110'=> {'min'=> 1, 'name' =>'Palta cortada para envoltura'},
			'1111'=> {'min'=> 1, 'name' =>'Sésamo tostado'},
			'1112'=> {'min'=> 1, 'name' =>'Queso crema para roll'},
			'1114'=> {'min'=> 50, 'name' =>'Cebollín cortado para roll'},
			'1115'=> {'min'=> 30, 'name' =>'Ciboulette picado para roll'},
			'1116'=> {'min'=> 1, 'name' =>'Nori entero cortado para roll'},
			'1201'=> {'min'=> 250, 'name' =>'Arroz cocido para roll'},
			'1207'=> {'min'=> 1, 'name' =>'Salmón cortado para nigiri'},
			'1209'=> {'min'=> 20, 'name' =>'Atún cortado para nigiri'},
			'1210'=> {'min'=> 1, 'name' =>'Palta cortada para roll'},
			'1211'=> {'min'=> 1, 'name' =>'Sésamo tostado para envoltura'},
			'1215'=> {'min'=> 20, 'name' =>'Ciboulette picado para envoltura'},
			'1216'=> {'min'=> 50, 'name' =>'Nori entero cortado para nigiri'},
			'1301'=> {'min'=> 50, 'name' =>'Arroz cocido para nigiri'},
			'1307'=> {'min'=> 1, 'name' =>'Salmón cortado para sashimi'},
			'1309'=> {'min'=> 170, 'name' =>'Atún cortado para sashimi'},
			'1310'=> {'min'=> 1, 'name' =>'Palta cortada para nigiri'},
			'1407'=> {'min'=> 1, 'name' =>'Salmón cortado para envoltura'}
		}
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
        ret = httpGetRequest(BaseURL + 'almacenes', auth_hash)
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

    def moveStockBodega_funcion(producto_id, almacen_id, precio=1, oc=nil)
		auth_hash = getHash('POST', producto_id + almacen_id)
		if oc.nil?
	        body = {"productoId": producto_id, "almacenId": almacen_id, "precio": precio}
    	else
	        body = {"productoId": producto_id, "almacenId": almacen_id, "oc": oc, "precio": precio}
	    end
        resp = httpPostRequest(BaseURL + 'moveStockBodega'  , auth_hash, body)
		return resp
	end

	def pedirProductoGrupo(grupo, sku, cantidad, almacenId)
		# sku: Producto a pedir
		# grupo: Grupo al cual se le quiere pedir
		# cantidad: Cantidad del producto a pedir
		# almacenId: Almacen de destino (nuestro almacen de recepcion)
		body = {'sku': sku, 'cantidad': cantidad, 'almacenId': almacenId}
		ret = httpPostRequest(groupsURL % [grupo], '', body)
		return ret
	end

	def pedirProductoGrupoURL
		# sku: Producto a pedir
		# grupo: Grupo al cual se le quiere pedir
		# cantidad: Cantidad del producto a pedir
		# almacenId: Almacen de destino (nuestro almacen de recepcion)
		grupo = params[:grupo]
		sku = params[:sku]
		cantidad = params[:cantidad]
		almacenId = params[:almacenId]
		groupsURL = 'https://tuerca%s.ing.puc.cl/'
		body = {'sku': sku, 'cantidad': cantidad, 'almacenId': almacenId}
		ret = httpPostRequest(groupsURL % [grupo], '', body)
		return ret
	end

	def vaciarDespacho()
		#TODO: La bodega para sacar el despacho no debe estar hardcodeada.
		puts 'VACIANDO DESPACHO'
		bodegas = almacenes()
		bodega_despacho = bodegas.detect {|b| b['despacho']}
		bodega_pulmon = bodegas.detect {|b| b['pulmon']}
		skus_with_stock = skusWithStock_funcion(bodega_despacho['_id'])
		skus_with_stock.each do |prod|
			productos_despacho = obtener_productos_funcion(bodega_despacho['_id'], prod['_id'], "100")
			productos_despacho.each do |prod2|
				puts moveStock_funcion(prod2['_id'], '5cc7b139a823b10004d8e6f3')
				puts bodega_pulmon
			end
		end
	end

end
