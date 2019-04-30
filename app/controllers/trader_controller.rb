class TraderController < ApplicationController

	def moveStockBodega
        # Mover producto entre bodega de despacho y la bodega de otro grupo (funcion para despachar)
        #
        #
        producto_id = params[:productoid]
        almacen_id = params[:almacenid]
        oc = params[:oc]
        #cambiar precio cuando se necesite
        precio = params[:precio]
        auth_hash = getHash('POST', producto_id + almacen_id)
        
        body = {"productoId": producto_id, "almacenId": almacen_id, "oc": oc, "precio": precio}
        resp = httpPostRequest(BaseURL + 'moveStockBodega'  , auth_hash, body)
		
		render json: resp
		return resp
	end
	

	def inventories
		auth_hash = getHash('GET', '')
		ret = httpGetRequest('https://integracion-2019-dev.herokuapp.com/bodega/almacenes', auth_hash)
		ret.each do |almacen|
			
			if almacen['despacho']
				id = almacen['_id']
				auth_hash = getHash('GET', id)
				ret = httpGetRequest('https://integracion-2019-dev.herokuapp.com/bodega/skusWithStock?almacenId=' + id, auth_hash)
			end
		end
		render json: ret
	end

	def orders
		body = JSON.parse(request.body.read)
		sku = body['sku']
		cantidad = body['cantidad']
		almacenid = body['almacenId']
		bodegas = almacenes()
		productos = []
		bodegas.each do |bodega|
			if bodega['pulmon']
				productos = skusWithStock_funcion(bodega["_id"])
			end
		end
		puts productos
		#puts productos
		render :json => {:error => "not-found"}.to_json, :status => 404
	end
	

	def testear
		# Reemplazar por funcion que se quiere testear.
		# Para las funciones post de nuestra API (orders)
		return orders()		
	end

end
