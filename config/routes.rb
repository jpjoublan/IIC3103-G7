Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get 'welcome/index', to: 'welcome#index'
	root 'welcome#index'
	get 'inventories', to: 'trader#inventories'
	put 'producir', to: 'factory#produce'
	post 'orders', to: 'trader#orders'
	get 'simularOrden', to: 'welcome#simular'
	get 'factorytester', to: 'factory#testear'
	get 'tradertester', to: 'trader#testear'
end
