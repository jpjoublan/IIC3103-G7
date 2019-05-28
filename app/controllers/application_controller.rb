require 'net/http'
require 'open-uri'
require 'json'
require 'base64'
require 'cgi'
require 'date'


class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session
	BaseURL =  'https://integracion-2019-prod.herokuapp.com/bodega/'
	BaseURL_oc = 'https://integracion-2019-dev.herokuapp.com/oc/'
	GroupsURL = 'http://tuerca%s.ing.puc.cl/'
	Products = {'1009' => {'min' =>23, 'name' => 'Filete de atún'},
                '1109' => {'min' =>50, 'name' => 'Atún cortado para roll'},
                '1209' => {'min' =>50, 'name' => 'Atún cortado para nigiri'},
                '1309' => {'min' =>170, 'name' => 'Atún cortado para sashimi'},
                '1006' => {'min' =>1200,'name' => 'Camarón'},
                '1106' => {'min' =>400,'name' => 'Camarón cocido'},
                '1014' => {'min' =>5,  'name' => 'Cebollín entero'},
                '1114' => {'min' =>50, 'name' => 'Cebollín cortado para roll'},
                '1015' => {'min' =>2,  'name' => 'Ciboulette entero'},
                '1115' => {'min' =>20, 'name' => 'Ciboulette picado para roll'},
                '1215' => {'min' =>30, 'name' => 'Ciboulette picado para envoltura'},
                '1005' => {'min' =>5,  'name' => 'Kanikama entero'},
                '1105' => {'min' =>50, 'name' => 'Kanikama para roll'},
                '1013' => {'min' =>900,'name' => 'Masago'},
                '1016' => {'min' =>350,'name' => 'Nori entero'},
                '1116' => {'min' =>250,'name' => 'Nori entero cortado para roll'},
                '1216' => {'min' =>50, 'name' => 'Nori entero cortado para nigiri'},
                '1010' => {'min' =>95, 'name' => 'Palta'},
                '1110' => {'min' =>80, 'name' => 'Palta cortada para envoltura'},
                '1210' => {'min' =>150,'name' => 'Palta cortada para roll' },
                '1310' => {'min' =>20, 'name' => 'Palta cortada para nigiri'},
                '1012' => {'min' =>7,  'name' => 'Queso crema'},
                '1112' => {'min' =>130,'name' => 'Queso crema para roll'},
                '1008' => {'min' =>9,  'name' => 'Filete de salmón ahumado'},
                '1108' => {'min' =>10, 'name' => 'Salmón ahumado cortado para roll' },
                '1007' => {'min' =>75, 'name' => 'Filete de salmón'},
                '1107' => {'min' =>50, 'name' => 'Salmón cortado para roll'},
                '1207' => {'min' =>20, 'name' => 'Salmón cortado para nigiri'},
                '1307' => {'min' =>170,'name' => 'Salmón cortado para sashimi'},
                '1407' => {'min' =>40, 'name' => 'Salmón cortado para envoltura'},
                '1011' => {'min' =>24, 'name' => 'Sésamo'},
                '1111' => {'min' =>10, 'name' => 'Sésamo tostado'},
                '1211' => {'min' =>60, 'name' => 'Sésamo tostado para envoltura'},
                '1001' => {'min' =>60, 'name' => 'Arroz grano corto'},
                '1002' => {'min' =>11, 'name' => 'Vinagre de arroz'},
                '1003' => {'min' =>12, 'name' => 'Azúcar'},
                '1004' => {'min' =>2,  'name' => 'Sal'},
                '1101' => {'min' =>35, 'name' => 'Arroz cocido'},
                '1301' => {'min' =>50, 'name' => 'Arroz cocido para nigiri'},
                '1201' => {'min' =>250,'name' => 'Arroz cocido para roll'}
	}

	Proporciones = {
		'1001' => {'lote': 10, 'materias_primas': []},
		'1002' => {'lote': 10, 'materias_primas': []},
		'1009' => {'lote': 3, 'materias_primas': []},
		'1003' => {'lote': 100, 'materias_primas': []},
		'1004' => {'lote': 100, 'materias_primas': []},
		'1005' => {'lote': 100, 'materias_primas': []},
		'1006' => {'lote': 1, 'materias_primas': []},
		'1008' => {'lote': 10, 'materias_primas': []},
		'1016' => {'lote': 10, 'materias_primas': []},
		'1007' => {'lote': 8, 'materias_primas': []},
		'1010' => {'lote': 5, 'materias_primas': []},
		'1011' => {'lote': 4, 'materias_primas': []},
		'1012' => {'lote': 7, 'materias_primas': []},
		'1013' => {'lote': 10, 'materias_primas': []},
		'1014' => {'lote': 5, 'materias_primas': []},
		'1015' => {'lote': 4, 'materias_primas': []},
		'1016' => {'lote': 8, 'materias_primas': []},
		'1105' => {'lote': 10, 'materias_primas': [{'sku': '1005', 'unidades_lote': 1}]},
		'1106' => {'lote': 100, 'materias_primas':[{'sku': '1006', 'unidades_lote': 100}]},
		'1107' => {'lote': 11, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1108' => {'lote': 6, 'materias_primas': [{'sku': '1008', 'unidades_lote': 1}]},
		'1109' => {'lote': 12, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
		'1110' => {'lote': 6, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
		'1111' => {'lote': 2, 'materias_primas': [{'sku': '1011', 'unidades_lote': 2}]},
		'1112' => {'lote': 20, 'materias_primas': [{'sku': '1012', 'unidades_lote': 1}]},
		'1114' => {'lote': 4, 'materias_primas': [{'sku': '1014', 'unidades_lote': 1}]},
		'1115' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 3}]},
		'1116' => {'lote': 10, 'materias_primas':[{'sku': '1016', 'unidades_lote': 11}]},
		'1201' => {'lote': 10, 'materias_primas':[{'sku': '1101', 'unidades_lote': 1}]},
		'1209' => {'lote': 14, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
		'1210' => {'lote': 9, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
		'1215' => {'lote': 8, 'materias_primas': [{'sku': '1015', 'unidades_lote': 4}]},
		'1216' => {'lote': 10, 'materias_primas': [{'sku': '1016', 'unidades_lote': 2}]},
		'1211' => {'lote': 10, 'materias_primas': [{'sku': '1111', 'unidades_lote': 1}]},
		'1207' => {'lote': 12, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1301' => {'lote': 5, 'materias_primas': [{'sku': '1101', 'unidades_lote': 1}]},
		'1309' => {'lote': 11, 'materias_primas': [{'sku': '1009', 'unidades_lote': 1}]},
		'1307' => {'lote': 11, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1310' => {'lote': 12, 'materias_primas': [{'sku': '1010', 'unidades_lote': 3}]},
		'1407' => {'lote': 14, 'materias_primas': [{'sku': '1007', 'unidades_lote': 1}]},
		'1101' => {'lote': 10, 'materias_primas': [{'sku': '1001', 'unidades_lote': 8}, {'sku': '1003', 'unidades_lote': 2},{'sku': '1004', 'unidades_lote': 3},{'sku': '1002', 'unidades_lote': 4}]},
		'10001' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10002' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10003' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10004' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1210','unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10005'	=> {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10006' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1210','unidades_lote': 1},{'sku': '1107','unidades_lote': 1},{'sku': '1211','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10007' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1013','unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10008' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10009' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109','unidades_lote': 1},{'sku': '1013', 'unidades_lote': 5},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10010' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1210', 'unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10011' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1114', 'unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10012' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1108', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10013' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106','unidades_lote': 4},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10014' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105','unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10015' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1109', 'unidades_lote': 1},{'sku': '1115', 'unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10016' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10017' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1110', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10018' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1105', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1}]},
		'10019' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4},{'sku': '1210', 'unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1}]},
		'10020' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4},{'sku': '1112', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1}]},
		'10021' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1109', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1407', 'unidades_lote': 1}]},
		'10022' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1107', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1215', 'unidades_lote': 1}]},
		'10023' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1109', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1215', 'unidades_lote': 1}]},
		'10024' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1115', 'unidades_lote': 1},{'sku': '1211', 'unidades_lote': 1}]},
		'10025' => {'lote': 1, 'materias_primas': [{'sku': '1201','unidades_lote': 1},{'sku': '1116', 'unidades_lote': 1},{'sku': '1210', 'unidades_lote': 1},{'sku': '1114', 'unidades_lote': 1},{'sku': '1115', 'unidades_lote': 1},{'sku': '1013', 'unidades_lote': 5}]},
		'20001' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1207', 'unidades_lote': 1},{'sku': '1310', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1}]},
		'20002' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1106', 'unidades_lote': 4}]},
		'20003' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1207', 'unidades_lote': 1}]},
		'20004' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1209', 'unidades_lote': 1}]},
		'20005' => {'lote': 1, 'materias_primas': [{'sku': '1301','unidades_lote': 1},{'sku': '1216', 'unidades_lote': 1},{'sku': '1209', 'unidades_lote': 1},{'sku': '1310', 'unidades_lote': 1},{'sku': '1112', 'unidades_lote': 1}]},
		'30001' => {'lote': 1, 'materias_primas': [{'sku': '1307','unidades_lote': 3}]},
		'30002' => {'lote': 1, 'materias_primas': [{'sku': '1307','unidades_lote': 4}]},
		'30003' => {'lote': 1, 'materias_primas': [{'sku': '1307','unidades_lote': 5}]},
		'30004' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 3}]},
		'30005' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 4}]},
		'30006' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 5}]},
		'30007' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 2},{'sku': 1307,'unidades_lote': 2}]},
		'30008' => {'lote': 1, 'materias_primas': [{'sku': '1309','unidades_lote': 3},{'sku': 1307,'unidades_lote': 3}]}
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
		http.use_ssl = (uri.scheme == 'https')
		response = http.request(req)
		return JSON.parse(response.body)
	end

	def httpPostRequest(url, auth_hash, body)
		uri = URI(url)
		req = Net::HTTP::Post.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		req['content-type'] = 'application/json'
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = (uri.scheme == 'https')
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
		http.use_ssl = (uri.scheme == 'https')
		req.body = body.to_json
		response = http.request(req)
		return JSON.parse(response.body)
	end

	def httpDeleteRequest(url, auth_hash, body)
		uri = URI(url)
		req = Net::HTTP::Delete.new(uri)
		req['Authorization'] = 'INTEGRACION grupo7:' + auth_hash
		req['content-type'] = 'application/json'
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = (uri.scheme == 'https')
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

    def moveStockBodega_funcion(producto_id, almacen_id, oc, precio=1)
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
		id_grupos = {
			'1' => {'desarrollo': '5cbd31b7c445af0004739be3', 'produccion': '5cc66e378820160004a4c3bc'},
			'2' => {'desarrollo': '5cbd31b7c445af0004739be4', 'produccion': '5cc66e378820160004a4c3bd'},
			'3' => {'desarrollo': '5cbd31b7c445af0004739be5', 'produccion': '5cc66e378820160004a4c3be'},
			'4' => {'desarrollo': '5cbd31b7c445af0004739be6', 'produccion': '5cc66e378820160004a4c3bf'},
			'5' => {'desarrollo': '5cbd31b7c445af0004739be7', 'produccion': '5cc66e378820160004a4c3c0'},
			'6' => {'desarrollo': '5cbd31b7c445af0004739be8', 'produccion': '5cc66e378820160004a4c3c1'},
			'7' => {'desarrollo': '5cbd31b7c445af0004739be9', 'produccion': '5cc66e378820160004a4c3c2'},
			'8' => {'desarrollo': '5cbd31b7c445af0004739bea', 'produccion': '5cc66e378820160004a4c3c3'},
			'9' => {'desarrollo': '5cbd31b7c445af0004739beb', 'produccion': '5cc66e378820160004a4c3c4'},
			'10' => {'desarrollo': '5cbd31b7c445af0004739bec', 'produccion': '5cc66e378820160004a4c3c5'},
			'11' => {'desarrollo': '5cbd31b7c445af0004739bed', 'produccion': '5cc66e378820160004a4c3c6'},
			'12' => {'desarrollo': '5cbd31b7c445af0004739bee', 'produccion': '5cc66e378820160004a4c3c7'},
			'13' => {'desarrollo': '5cbd31b7c445af0004739bef', 'produccion': '5cc66e378820160004a4c3c8'},
			'14' => {'desarrollo': '5cbd31b7c445af0004739bf0', 'produccion': '5cc66e378820160004a4c3c9'},
			}
		fecha = p DateTime.now.strftime('%Q').to_i
		fecha += 86400000 ## Le sumamos un dia de plazo
		bodegas = almacenes()
		bodega_recepcion = bodegas.detect {|b| b['recepcion']}
		## Obtener stock
		begin
			cantidad_int = cantidad.to_i
			stock_grupo = obtenerStock(grupo)
			stock_grupo.each do |product|
			if product["sku"] == sku
				if product["total"] >= cantidad_int
					resp = createOC_funcion(id_grupos['7'][:produccion], id_grupos[grupo][:produccion], sku, fecha, cantidad, '1', 'b2b') ## Cambiar a produccion
					id = resp['_id']
					body = {'sku': sku, 'cantidad': cantidad_int, 'almacenId': bodega_recepcion['_id'], 'oc': id}
					ret = httpPostRequest(GroupsURL % [grupo] + 'orders', '', body)
					return ret
				elsif product["total"] < cantidad_int and product["total"] > 0
					resp = createOC_funcion(id_grupos['7'][:produccion], id_grupos[grupo][:produccion], sku, fecha, product["total"].to_s, '1', 'b2b') ## Cambiar a produccion
					id = resp['_id']
					body = {'sku': sku, 'cantidad': product["total"], 'almacenId': bodega_recepcion['_id'], 'oc': id}
					ret = httpPostRequest(GroupsURL % [grupo] + 'orders', '', body)
					return ret
				end
			end
		rescue
			return 'fallo!'
		end
		end


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


	# HACIA ABAJO REVISAR, ES NUEVO.


	#SE DEJARON FUERA PARAMETROS OPCIONALES
	def createOC_funcion(cliente, proveedor, sku, fechaEntrega, cantidad, precioUnitario, canal)
		auth_hash = getHash('PUT', '')
		body = {'cliente': cliente, 'proveedor': proveedor, 'sku': sku, 'fechaEntrega': fechaEntrega,
			 'cantidad': cantidad, 'precioUnitario': precioUnitario, 'canal': canal}
		resp = httpPutRequest(BaseURL_oc + 'crear', auth_hash, body)
		return resp
	end

	def getOC_funcion(id)
		auth_hash = getHash('GET', '')
		body = {}
		resp = httpGetRequest(BaseURL_oc + 'obtener/' + id, auth_hash )
		return resp
	end

	def recepcionarOC_funcion(id)
		auth_hash = getHash('POST', '')
		body = {'_id': id}
		resp = httpPostRequest(BaseURL_oc + 'recepcionar/' + id, auth_hash, body)
	end

	def rechazarOC_funcion(id, rechazo)
		auth_hash = getHash('POST', '')
		body = {'_id': id, 'rechazo': rechazo}
		resp = httpPostRequest(BaseURL_oc + 'rechazar/' + id, auth_hash, body)
	end

	def anularOC_funcion(id, anulacion)
		auth_hash = getHash('POST', '')
		body = {'_id': id, 'anulacion': anulacion}
		resp = httpDeleteRequest(BaseURL_oc + 'anular/' + id, auth_hash, body)
	end

	def obtenerStock(grupo)
		auth_hash = getHash('GET', '')
		resp = httpGetRequest(GroupsURL % [grupo] + 'inventories', auth_hash )
		return resp
	end

end