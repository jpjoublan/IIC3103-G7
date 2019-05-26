class OrdersController < ApplicationController

    #PRUEBAS DE FUNCIONES ORDENES DE COMPRA

    def createOC
        cliente = '5cbd31b7c445af0004739be9'
        proveedor = '5cbd31b7c445af0004739be4'
        sku = '1006'
        fechaEntrega = 26596545850500
        cantidad = '10'
        precioUnitario = '1'
        canal = 'b2b'
        resp = createOC_funcion(cliente, proveedor, sku, fechaEntrega, cantidad, precioUnitario, canal )
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
        id = "5ceb0f59a949a800044c8c0b"
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
