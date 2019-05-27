class OrdersController < ApplicationController

    #PRUEBAS DE FUNCIONES ORDENES DE COMPRA

    def createOC
        grupo = '8'
        sku = '1006'
        cantidad = '10'
        almacen = '1'
        resp = pedirProductoGrupo( grupo, sku, cantidad, almacen)
        render json:resp
    end

    def getOC
        id = "5ceb0ea6a949a800044c8c09"

        resp = getOC_funcion(id)
        render json:resp
    end

    def recepcionarOC
        id = "5ceb0ea6a949a800044c8c09"

        resp = recepcionarOC_funcion(id)
        render json:resp
    end

    def anularOC
        id = "5ceb12819b541400040faa46"
        anulacion = "No tenemos"

        resp = anularOC_funcion(id, anulacion)
        render json:resp
    end

    def rechazarOC
        id = "5ceb0f7fa949a800044c8c0c"
        rechazo = 'No hay'
        resp = rechazarOC_funcion(id, rechazo)
        render json:resp
    end

    def sftp
        Net::SFTP.start('fierro.ing.puc.cl', 'grupo7_dev', :password => '9AmQHvLiEwzK37W') do |sftp|
            ocs = JSON.load File.new("public/ocs.json") 
            sftp.dir.entries('/pedidos').each do |remote_file|
                if !['.', '..'].include? remote_file.name and !ocs.has_key? remote_file.name
                    file_data = sftp.download!('/pedidos/' + remote_file.name)
                    f = Nokogiri::XML(file_data)  
                    ocs[remote_file.name] = f.xpath('/order/id').text
                    puts f.xpath('/order/id').text
                end
            end
            File.open("public/ocs.json","w") do |f|
              f.write(JSON.pretty_generate(ocs))
            end
        end
    render json:{'status': 'ok'}
    end



end
