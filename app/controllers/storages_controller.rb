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
   
    def monitorearBodegas
        bodegas = almacenes()
        bodega_recepcion = bodegas.detect {|b| b['recepcion']}
        skus_recepcion = skusWithStock_funcion(bodega_recepcion['_id'])
        bodega_pulmon = bodegas.detect {|b| b['pulmon']}
        skus_pulmon = skusWithStock_funcion(bodega_recepcion['_id'])
        bodegas_auxiliares = []
        bodegas.each do |b|
            if !b['pulmon'] and !b['recepcion'] and !b['cocina'] and !b['despacho']
                b['trasladados'] = 0
                bodegas_auxiliares.push(b)
            end
        end
        b1 = bodegas_auxiliares[0]
        b2 = bodegas_auxiliares[1]
        # HASTA ESTA LINEA ESTÁ TESTEADO Y VA BIEN. SE CAYÓ LA API DEL PROFE, ASIQUE SIGO CUANDO VUELVA.
        skus_pulmon.each do |prod|
            productos = obtener_productos_funcion(bodega_pulmon['_id'], prod['_id'], 200)
            productos.each do |pr|
                if b1['totalSpace'] > b1['usedSpace'] + b1['trasladados']
                    moveStock_funcion(pr['_id'], b1['_id'])
                    b1['trasladados'] += 1
                elsif b2['totalSpace'] > b2['usedSpace'] + b2['trasladados']
                    moveStock_funcion(pr['_id'], b2['_id'])
                    b2['trasladados'] += 1
                end
            end
        end
        skus_recepcion.each do |prod|
            productos = obtener_productos_funcion(bodega_recepcion['_id'], prod['_id'], 200)
            productos.each do |pr|
                if b1['totalSpace'] > b1['usedSpace'] + b1['trasladados']
                    moveStock_funcion(pr['_id'], b1['_id'])
                    b1['trasladados'] += 1
                elsif b2['totalSpace'] > b2['usedSpace'] + b2['trasladados']
                    moveStock_funcion(pr['_id'], b2['_id'])
                    b2['trasladados'] += 1
                end
            end
        end
        render json: bodegas_auxiliares
    end

end
