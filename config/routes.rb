Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get 'welcome/index', to: 'welcome#index'
	root 'welcome#index'
	get 'inventories', to: 'trader#inventories'
	get '/fabrica/fabricarSinPago', to: 'factory#produce'
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
end
