class OrdersController < ApplicationController

    #PRUEBAS DE FUNCIONES ORDENES DE COMPRA

    def createOC(renders = true)
        grupo = '1'
        sku = '1009'
        cantidad = '100'
        almacen = '1'
        resp = pedirProductoGrupo( grupo, sku, cantidad, almacen)
        if renders
            render json:resp
        end
    end

    def getOC(renders = true)
        id = "5ceb0ea6a949a800044c8c09"

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

    def rechazarOC
        id = "5ceb0f7fa949a800044c8c0c"
        rechazo = 'No hay'
        resp = rechazarOC_funcion(id, rechazo)
        if renders
            render json:resp
        end
    end

    def sftp(renders = true)
        Net::SFTP.start('fierro.ing.puc.cl', 'grupo7_dev', :password => '9AmQHvLiEwzK37W') do |sftp|
            ocs = JSON.load File.new("public/ocs.json")
            sftp.dir.entries('/pedidos').each do |remote_file|
                if !['.', '..'].include? remote_file.name and !ocs.has_key? remote_file.name
                    file_data = sftp.download!('/pedidos/' + remote_file.name)
                    f = Nokogiri::XML(file_data)
                    ocs[remote_file.name] = {'id': f.xpath('/order/id').text, 'estado': 'recibida'}
                    puts f.xpath('/order/id').text
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
