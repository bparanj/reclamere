ActionController::Routing::Routes.draw do |map|

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  
  map.resource :session, :only => [ :new, :create, :destroy ]

  map.forgot_password "/forgot_password", :controller => 'sessions', :action => 'forgot_password'
  map.password_ticket "/password_ticket/:id", :controller => 'sessions', :action => 'password_ticket'
  map.feedback_request "/feedback_request/:id", :controller => 'sessions', :action => 'feedback_request'
  
  map.with_options :controller => "search" do |page|
    page.search "search", :action => "new"
    page.search_results "search_results", :action => "index"
  end
    
  map.resources :monitor_sizes, :monitor_brands, :cpu_types, :cpu_brands, :cpu_classes, :loose_hard_drive_brands
  map.resources :flash_hard_drive_brands, :tv_brands, :tv_sizes, :peripherals_brands, :miscellaneous_equipment_types, :miscellaneous_equipment_brands
  map.resources :cpus, :only => [:edit, :update] 
  map.resources :computer_monitors, :only => [:edit, :update] 
  map.resources :loose_hard_drives, :only => [:edit, :update] 
  map.resources :flash_hard_drives, :only => [:edit, :update] 
  map.resources :tvs, :only => [:edit, :update] 
  map.resources :magnetic_medias, :only => [:edit, :update] 
  map.resources :peripherals, :only => [:edit, :update] 
  map.resources :miscellaneous_equipments, :only => [:edit, :update] 

  # map.import_pickup_equipment "/pickups/:pickup_id/equipment/import/:id/:equipment_type",
  #   :controller => 'equipment', :action => 'import'
    
  map.resources :pickups,
    :member => { 
    :address => :get,
    :acknowledge => :post,
    :notify => :post,
    :close_feedback => :post,
    :print_work_order => :get
    },
    :collection => { :update_users_list => :post } do |pickup|
    
      pickup.resources :folders, :member => { :folder_contents => [:get,:post], :create => :post } do |folder|
        folder.resources :documents, :member => { :download => :get, :versions => :get }
      end
      pickup.resources :equipment,
        :singular => 'equip',
        :only => [ :index, :show, :destroy ],
        :collection => { :upload => [ :get, :post ] }
      pickup.resources :tasks, :only => [ :index, :update ]
      pickup.resources :system_emails, :only => [ :index, :show ]
      pickup.resource  :feedback, :only => [ :show, :edit, :update ]
      pickup.resources :audit_logs, :only => :index
      pickup.resources :pallets
      pickup.resources :services
      pickup.resources :internal_documents, :only => [:new, :create]   
  end
  
  map.download_pickup_folder_document_document_version "/pickups/:pickup_id/folders/:folder_id/documents/:id/download/:version",
    :controller => 'documents', :action => 'download'

  # Client Resources
  map.resources :clients do |client|
    client.resources :folders, :member => { :folder_contents => [:get,:post], :create => :post } do |folder|
      folder.resources :documents, :member => { :download => :get, :versions => :get }
    end
    client.resources :equipment,
      :collection => { :export => [:get, :post] },
      :singular => 'equip',
      :only => [ :index, :show, :destroy ]
  end
  map.download_client_folder_document_document_version "/clients/:client_id/folders/:folder_id/documents/:id/download/:version",
    :controller => 'documents', :action => 'download'

  map.resources :pickup_locations

  # Admin Resources
  map.resources :audit_logs,
    :path_prefix => '/admin',
    :name_prefix => 'admin_',
    :only => :index
  map.resources :users,
    :collection => { :recent => :get },
    :path_prefix => '/admin',
    :name_prefix => 'admin_'
  map.resources :clients,
    :path_prefix => '/admin',
    :name_prefix => 'admin_'
  map.resources :pickup_locations,
    :collection => { :update_client_users_list => :post },
    :path_prefix => '/admin',
    :name_prefix => 'admin_'
  map.connect '/admin/dashboard/:action', :controller => 'admin/dashboard'
  
  # Default / Other
  map.connect '/dashboard/:action', :controller => 'dashboard'
  map.connect '/dashboard/calendar/:year/:month', :controller => 'dashboard', :action => 'calendar'
  map.connect '', :controller => 'dashboard'
end
