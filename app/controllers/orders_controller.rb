class OrdersController < ApplicationController

    #PRUEBAS DE FUNCIONES ORDENES DE COMPRA

    def createOC(renders = true)
        grupo = '6'
        sku = '1007'
        cantidad = '20'
        almacen = '1'
        resp = pedirProductoGrupo( grupo, sku, cantidad, almacen)
        if renders
            render json:resp
        end
    end

    def getOC(renders = true)
        id = "5ceb552c1553dd00041ba68a"

        resp = getOC_funcion(id)
        if renders
            render json:resp
        end
    end

    def recepcionarOC(renders = true)
        id = "5ceb0ea6a949a800044c8c09"
        resp = recepcionarOC_funcion(id)
        if renders
            render json:resp
        end
    end

    def anularOC(renders = true)
        id = "5ceb12819b541400040faa46"
        anulacion = "No tenemos"

        resp = anularOC_funcion(id, anulacion)
        if renders
            render json:resp
        end
    end

    def rechazarOC(renders = true)
        id = "5ced6b990fdaa30004c8539b"
        rechazo = 'No hay'
        resp = rechazarOC_funcion(id, rechazo)
        if renders
            render json:resp
        end
    end

    def sftp(renders = true)
        ## Clave produccion: zZvsd7L38kq4TwbC7
        ## Clave development: 9AmQHvLiEwzK37W
        Net::SFTP.start('fierro.ing.puc.cl', 'grupo7', :password => 'zZvsd7L38kq4TwbC7') do |sftp|
            ocs = JSON.load File.new("public/ocs.json")
            sftp.dir.entries('/pedidos').each do |remote_file|
                if !['.', '..'].include? remote_file.name and !ocs.has_key? remote_file.name
                    file_data = sftp.download!('/pedidos/' + remote_file.name)
                    f = Nokogiri::XML(file_data)
                    id = f.xpath('/order/id').text
                    resp = getOC_funcion(id)
                    ocs[remote_file.name] = {'id': id, 'estado': resp[0]['estado'], 'sku': resp[0]['sku'], 'qty': resp[0]['cantidad']}
                end
            end
            File.open("public/ocs.json","w") do |f|
              f.write(JSON.pretty_generate(ocs))
            end
        end
        if renders
            render json:{'status': 'ok'}
        end
    end



end
