class StoragesController < ApplicationController

    def moveStock
        # Esta funcion se utiliza para mover stock desde un almacen a otro, sin importar cual es el almacen de origen
        # Solo se ingresa producto id y almacen id
        #
        producto_id = params[:productoid]
        almacen_id = params[:almacenid]
        auth_hash = getHash('POST', producto_id + almacen_id)
        body = {"productoId": producto_id, "almacenId": almacen_id}		
        resp = httpPostRequest(BaseURL + 'moveStock' , auth_hash, body)
        render json: resp	
        return resp
    end
    
    def obtener_productos
        #
        #
        #
        almacen_id = params[:almacenid]
        sku = params[:sku]
        auth_hash = getHash('GET', almacen_id + sku)
        
        if params[:limit].nil?
            
            resp = httpGetRequest(BaseURL + 'stock?almacenId=%s&sku=%s&limit=100' % [almacen_id, sku] , auth_hash)
            
        else
            limit = params[:limit]
            resp = httpGetRequest(BaseURL + 'stock?almacenId=%s&sku=%s&limit=%s' % [almacen_id, sku, limit] , auth_hash)
        end
        render json: resp
        return resp
        
    end

    
end
