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
        id = '5ce7090250233900041b8c0a'

        resp = getOC_funcion(id)
        render json:resp

    end



end
