class CpusController < ApplicationController
  def edit
    prompt = ["Please select"]
    @cpu = Cpu.find(params[:id])  
    @cpu_types = prompt + CpuType.all.collect(&:name)
    @cpu_brands = prompt + CpuBrand.all.collect(&:name)
    @cpu_classes = prompt + CpuClass.all.collect(&:name)
  end
  
  def update
    @cpu = Cpu.find(params[:id])
    
    if @cpu.update_attributes(params[:cpu])
      # TODO: Delete all the existing cpu_hard_drive_serial and create new here by parsing the comma separated values and storing it
      # params[:cpu_hard_drive_serial]
      donemark "Cpu updated successfully"
      redirect_to pickup_equipment_path(@cpu.pickup_id)
    else
      render :action => "update"
    end
    
  end

end
