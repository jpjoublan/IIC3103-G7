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



end
