Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get 'welcome/index', to: 'welcome#index'
	root 'welcome#index'
	get 'inventories', to: 'trader#inventories'
	get '/fabrica/fabricarSinPago', to: 'factory#produce'
	get '/fabrica/pedirProductoGrupo', to: 'application#pedirProductoGrupoURL'
	get '/fabrica/fabricarFinal', to: 'factory#produce_final'
	post 'orders', to: 'trader#orders'
	get 'simularOrden', to: 'welcome#simular'
	get 'factorytester', to: 'factory#testear'
	get 'tradertester', to: 'trader#testear'
	get 'showHash', to: 'welcome#showHash'
	get '/moveStockBodega', to: 'trader#moveStockBodega'
	get '/moveStock', to: 'storages#moveStock'
	get '/stock', to: 'storages#obtener_productos'
	post '/orders', to: 'trader#orders'
	get '/almacenes', to: 'welcome#almacenes'
	get '/skusWithStock', to: 'storages#skusWithStock'
	get '/crear', to: 'orders#createOC'
	get '/obtener', to: 'orders#getOC'
	get '/recepcionar', to: 'orders#recepcionarOC'
	get '/anular', to: 'orders#anularOC'
	get '/rechazar', to: 'orders#rechazarOC'
	get 'despachar', to: 'factory#despachar_clientes'
	get 'sftptest', to: 'orders#sftp'
	get '/testingscheduler', to: 'welcome#testsch'
	get 'despachar2', to: 'factory#despacharOrden'
	get '/monitorear', to: 'storages#monitorearBodegas'
end
