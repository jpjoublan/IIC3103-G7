class StoragesController < ApplicationController

    def moveStock(renders = true)
        # Esta funcion se utiliza para mover stock desde un almacen a otro, sin importar cual es el almacen de origen
        # Solo se ingresa producto id y almacen id
        #
        producto_id = params[:productoid]
        almacen_id = params[:almacenid]
        resp = moveStock_funcion(producto_id, almcacen_id)
        if renders
            render json: resp	
        end
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

    
    def skusWithStock
        almacen_id = params[:almacenid]
        ret = skusWithStock_funcion(almacen_id)
        render json: ret
        return ret
    end
    

end
